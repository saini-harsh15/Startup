package org.example.startupecosystem.controller;

import jakarta.servlet.http.HttpSession;
import org.example.startupecosystem.entity.*;
import org.example.startupecosystem.repository.InvestorRepository;
import org.example.startupecosystem.repository.StartupProfileViewRepository;
import org.example.startupecosystem.service.InvestorService;
import org.example.startupecosystem.service.StartupService;
import org.example.startupecosystem.service.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/investor")
public class InvestorController {

    @Autowired
    private StartupService startupService;

    @Autowired
    private InvestorRepository investorRepository;

    @Autowired
    private InvestorService investorService;

    @Autowired
    private NewsService newsService;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    // 🔥 ADDED (only new dependency)
    @Autowired
    private StartupProfileViewRepository startupProfileViewRepository;

    // --- Helper method for robust session ID retrieval (UNCHANGED) ---
    private Optional<Long> getUserIdFromSession(HttpSession session, RedirectAttributes redirectAttributes) {
        Object userIdObj = session.getAttribute("loggedInUserId");
        Object roleObj = session.getAttribute("loggedInRole");
        final String expectedRole = "Investor";

        if (userIdObj == null || !expectedRole.equals(roleObj)) {
            return Optional.empty();
        }

        try {
            Long userId = (userIdObj instanceof String)
                    ? Long.parseLong((String) userIdObj)
                    : (Long) userIdObj;
            return Optional.of(userId);

        } catch (NumberFormatException | ClassCastException e) {
            session.invalidate();
            if (redirectAttributes != null) {
                redirectAttributes.addFlashAttribute("error", "Authentication error. Please log in again.");
            }
            return Optional.empty();
        }
    }
    // ----------------------------------------------------


    @GetMapping({"/dashboard", "/dashboard/{id}"})
    public String showInvestorDashboard(
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "industry", required = false) String industry,
            Model model, HttpSession session, RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt = getUserIdFromSession(session, redirectAttributes);
        if (userIdOpt.isEmpty()) return "redirect:/login";

        Long userId = userIdOpt.get();
        Optional<Investor> investorOptional = investorRepository.findById(userId);

        if (investorOptional.isEmpty()) return "redirect:/";

        Investor investor = investorOptional.get();
        model.addAttribute("investor", investor);

        List<Startup> startups = startupService.findStartupsByCriteria(search, industry);
        model.addAttribute("startups", startups);
        model.addAttribute("industries", startupService.getDistinctIndustries());
        model.addAttribute("currentSearch", search);
        model.addAttribute("currentIndustry", industry);

        String topic;
        if (industry != null && !industry.trim().isEmpty()) {
            topic = industry.trim();
        } else if (investor.getPreferredDomains() != null && !investor.getPreferredDomains().trim().isEmpty()) {
            topic = investor.getPreferredDomains().split(",")[0].trim();
        } else if (investor.getInvestmentPreferences() != null && !investor.getInvestmentPreferences().trim().isEmpty()) {
            topic = investor.getInvestmentPreferences().trim();
        } else {
            topic = "startup";
        }

        model.addAttribute("newsTopic", topic);
        model.addAttribute("newsList", newsService.fetchNews(topic));

        return "investorDashboard";
    }

    @GetMapping("/messages")
    public String showInvestorMessages(
            @RequestParam(value = "search", required = false) String search,
            Model model, HttpSession session, RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt = getUserIdFromSession(session, redirectAttributes);
        if (userIdOpt.isEmpty()) return "redirect:/login";

        Long investorId = userIdOpt.get();

        Optional<Investor> investorOptional = investorRepository.findById(investorId);
        if (investorOptional.isEmpty()) return "redirect:/login";

        model.addAttribute("investor", investorOptional.get());

        List<Startup> startupsList;
        if (search != null && !search.trim().isEmpty()) {
            startupsList = startupService.findStartupsByCriteria(search.trim(), null);
        } else {
            startupsList = startupService.findAll();
        }

        List<ChatMessage> chatHistory = null;

        model.addAttribute("investorId", investorId);
        model.addAttribute("startupsList", startupsList);
        model.addAttribute("searchTerm", search);
        model.addAttribute("chatHistory", chatHistory);

        return "investorMessages";
    }

    @GetMapping("/investors")
    public String showAllInvestors(
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "sort", required = false) String sort,
            Model model, HttpSession session, RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt = getUserIdFromSession(session, redirectAttributes);
        if (userIdOpt.isEmpty()) return "redirect:/login";

        Long userId = userIdOpt.get();

        Optional<Investor> investorOptional = investorRepository.findById(userId);
        if (investorOptional.isEmpty()) return "redirect:/login";

        model.addAttribute("investor", investorOptional.get());

        List<Investor> investors = investorService.findInvestorsByCriteria(search, sort);
        model.addAttribute("investors", investors);
        model.addAttribute("currentSearch", search);
        model.addAttribute("currentSort", sort);

        return "exploreInvestors";
    }

    // 🔥 ONLY METHOD WITH LOGIC ADDITION
    @GetMapping("/startup/{id}")
    public String showStartupProfile(
            @PathVariable("id") Long id,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt = getUserIdFromSession(session, redirectAttributes);
        if (userIdOpt.isEmpty()) return "redirect:/login";

        Long investorId = userIdOpt.get();

        Optional<Investor> investorOptional = investorRepository.findById(investorId);
        if (investorOptional.isEmpty()) return "redirect:/login";

        model.addAttribute("investor", investorOptional.get());

        Optional<Startup> startupOpt = startupService.getStartupById(id);
        if (startupOpt.isEmpty()) return "redirect:/investor/dashboard";

        Startup startup = startupOpt.get();

        // ===============================
        // 🔥 PROFILE VIEW TRACKING (SAFE)
        // ===============================
        boolean alreadyViewed =
                startupProfileViewRepository
                        .existsByStartupIdAndInvestorId(startup.getId(), investorId);

        if (!alreadyViewed) {
            StartupProfileViewEntity view = new StartupProfileViewEntity();
            view.setStartupId(startup.getId());
            view.setInvestorId(investorId);
            startupProfileViewRepository.save(view);

            // 🔥 REAL-TIME PUSH TO STARTUP DASHBOARD
            long updatedCount =
                    startupProfileViewRepository.countByStartupId(startup.getId());

            ProfileViewEvent event = new ProfileViewEvent();
            event.setStartupId(startup.getId());
            event.setTotalViews(updatedCount);

            messagingTemplate.convertAndSend(
                    "/topic/startup/profile-views/" + startup.getId(),
                    event
            );
        }
        // ===============================

        model.addAttribute("startup", startup);

        return "startupExpandedView";
    }


    @GetMapping("/profile")
    public String showProfile(Model model, HttpSession session, RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt = getUserIdFromSession(session, redirectAttributes);
        if (userIdOpt.isEmpty()) return "redirect:/login";

        Long userId = userIdOpt.get();

        Optional<Investor> investorOptional = investorRepository.findById(userId);
        if (investorOptional.isEmpty()) return "redirect:/investor/dashboard";

        model.addAttribute("investor", investorOptional.get());
        return "investorprofile";
    }

    @PostMapping("/profile/save")
    public String saveProfile(
            @RequestParam("investorName") String investorName,
            @RequestParam("bio") String bio,
            @RequestParam("investmentPreferences") String investmentPreferences,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt = getUserIdFromSession(session, redirectAttributes);
        if (userIdOpt.isEmpty()) return "redirect:/login";

        Long userId = userIdOpt.get();

        try {
            investorService.updateInvestorProfile(userId, investorName, bio, investmentPreferences);
            redirectAttributes.addFlashAttribute("message", "Profile updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "An error occurred while saving your profile.");
        }

        return "redirect:/investor/dashboard";
    }

    @PostMapping("/apply-for-investment")
    public String applyForInvestment(
            @RequestParam("startupId") Long startupId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt = getUserIdFromSession(session, redirectAttributes);
        if (userIdOpt.isEmpty()) return "redirect:/login";

        redirectAttributes.addFlashAttribute("message", "Your investment application has been submitted successfully!");

        return "redirect:/investor/startup/" + startupId;
    }
}
