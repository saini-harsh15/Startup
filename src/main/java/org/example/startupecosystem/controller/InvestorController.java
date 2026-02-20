package org.example.startupecosystem.controller;

import jakarta.servlet.http.HttpSession;
import org.example.startupecosystem.entity.*;
import org.example.startupecosystem.repository.InvestorRepository;
import org.example.startupecosystem.repository.StartupProfileViewRepository;
import org.example.startupecosystem.service.*;
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

    @Autowired
    private StartupProfileViewRepository startupProfileViewRepository;

    @Autowired
    private InvestmentRequestService investmentRequestService;

    @Autowired
    private ChatService chatService;


    // --- Helper method for robust session ID retrieval ---
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
        } catch (Exception e) {
            session.invalidate();
            redirectAttributes.addFlashAttribute("error", "Authentication error. Please log in again.");
            return Optional.empty();
        }
    }

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

        // 1️⃣ Get chat partner IDs
        List<Long> partnerIds = chatService.getChatPartnerIds(investorId);

        List<Startup> startupsList;

        if (partnerIds.isEmpty()) {
            startupsList = List.of();
        } else {
            startupsList = startupService.findAllByIds(partnerIds);
        }

// 2️⃣ Apply search filter ONLY within chat partners
        if (search != null && !search.trim().isEmpty()) {
            String lower = search.trim().toLowerCase();

            startupsList = startupsList.stream()
                    .filter(s ->
                            s.getName().toLowerCase().contains(lower) ||
                                    (s.getIndustry() != null &&
                                            s.getIndustry().toLowerCase().contains(lower))
                    )
                    .toList();
        }


        model.addAttribute("investorId", investorId);
        model.addAttribute("startupsList", startupsList);
        model.addAttribute("searchTerm", search);

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

        // ===== REAL ENGAGEMENT TRACKING (5 MIN COOLDOWN) =====

        Optional<StartupProfileViewEntity> lastViewOpt =
                startupProfileViewRepository
                        .findTopByStartupIdAndInvestorIdOrderByViewedAtDesc(startup.getId(), investorId);

        boolean shouldCount = true;

        if (lastViewOpt.isPresent()) {
            long seconds = java.time.Duration.between(
                    lastViewOpt.get().getViewedAt(),
                    java.time.LocalDateTime.now()
            ).getSeconds();

            // Ignore refresh spam
            if (seconds < 300) {
                shouldCount = false;
            }
        }

        if (shouldCount) {

            StartupProfileViewEntity view = new StartupProfileViewEntity();
            view.setStartupId(startup.getId());
            view.setInvestorId(investorId);
            view.setViewedAt(java.time.LocalDateTime.now());

            startupProfileViewRepository.save(view);

            long updatedCount = startupProfileViewRepository.countByStartupId(startup.getId());

            ProfileViewEvent event = new ProfileViewEvent();
            event.setStartupId(startup.getId());
            event.setTotalViews(updatedCount);

            messagingTemplate.convertAndSend(
                    "/topic/startup/profile-views/" + startup.getId(),
                    event
            );
        }


        model.addAttribute("startup", startup);

        return "startupExpandedView";
    }

    // --- NEW: Method to show the Investment Application Form ---
    @GetMapping("/apply")
    public String showInvestmentForm(
            @RequestParam("startupId") Long startupId,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt = getUserIdFromSession(session, redirectAttributes);
        if (userIdOpt.isEmpty()) return "redirect:/login";

        Long investorId = userIdOpt.get();
        Optional<Investor> investorOptional = investorRepository.findById(investorId);
        Optional<Startup> startupOpt = startupService.getStartupById(startupId);

        if (investorOptional.isEmpty() || startupOpt.isEmpty()) {
            return "redirect:/investor/dashboard";
        }

        model.addAttribute("investor", investorOptional.get());
        model.addAttribute("startup", startupOpt.get());

        // Returns the investment application JSP
        return "investment-application";
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

    // --- UPDATED: Handle the actual form submission ---
    @PostMapping("/submit-investment-request")
    public String applyForInvestment(
            @RequestParam("startupId") Long startupId,
            @RequestParam("amount") Double amount,
            @RequestParam("fundingStage") String fundingStage,
            @RequestParam(value = "expectedRoi", required = false) Double expectedRoi,
            @RequestParam(value = "horizon", required = false) Integer horizon,
            @RequestParam(value = "message", required = false) String message,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt = getUserIdFromSession(session, redirectAttributes);
        if (userIdOpt.isEmpty()) return "redirect:/login";

        Long investorId = userIdOpt.get();

        Investor investor = investorRepository
                .findById(investorId)
                .orElseThrow();

        Startup startup = startupService
                .getStartupById(startupId)
                .orElseThrow();

        // 🔥 REAL PERSISTENCE
        investmentRequestService.createRequest(
                investor,
                startup,
                amount,
                fundingStage,
                expectedRoi,
                horizon,
                message
        );

        redirectAttributes.addFlashAttribute("investmentSuccess", true);

        return "redirect:/investor/apply?startupId=" + startupId;
    }
}