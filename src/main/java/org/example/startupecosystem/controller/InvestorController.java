package org.example.startupecosystem.controller;

import jakarta.servlet.http.HttpSession;
import org.example.startupecosystem.entity.ChatMessage;
import org.example.startupecosystem.entity.Startup;
import org.example.startupecosystem.entity.Investor;
import org.example.startupecosystem.repository.InvestorRepository;
import org.example.startupecosystem.service.InvestorService;
import org.example.startupecosystem.service.StartupService;
import org.example.startupecosystem.service.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
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

    // --- Helper method for robust session ID retrieval (FIX) ---
    private Optional<Long> getUserIdFromSession(HttpSession session, RedirectAttributes redirectAttributes) {
        Object userIdObj = session.getAttribute("loggedInUserId");
        Object roleObj = session.getAttribute("loggedInRole");
        final String expectedRole = "Investor";

        if (userIdObj == null || !expectedRole.equals(roleObj)) {
            return Optional.empty(); // Fails authentication
        }

        try {
            // Safely parse the ID regardless of whether Spring stored it as String or Long.
            Long userId = (userIdObj instanceof String)
                    ? Long.parseLong((String) userIdObj)
                    : (Long) userIdObj;
            return Optional.of(userId);

        } catch (NumberFormatException | ClassCastException e) {
            // Session corruption detected: invalidate and redirect
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

        // startups list
        List<Startup> startups = startupService.findStartupsByCriteria(search, industry);
        model.addAttribute("startups", startups);
        model.addAttribute("industries", startupService.getDistinctIndustries()); // CORRECTED: Calling existing StartupService method
        model.addAttribute("currentSearch", search);
        model.addAttribute("currentIndustry", industry);

        // news fetch logic
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

    /**
     * Handles the request for the investor-side message center.
     */
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

        // 1. Fetch Startup partners (Filtered or All)
        List<Startup> startupsList;
        if (search != null && !search.trim().isEmpty()) {
            // FIX: Call the existing criteria method, passing null for industry
            startupsList = startupService.findStartupsByCriteria(search.trim(), null);
        } else {
            // FIX: Call the existing findAll method for an unfiltered list
            startupsList = startupService.findAll();
        }

        // 2. Initial chat history placeholder (History will be loaded dynamically on client)
        List<ChatMessage> chatHistory = null;

        // 3. Model attributes
        model.addAttribute("investorId", investorId);
        model.addAttribute("startupsList", startupsList); // Renamed attribute for clarity
        model.addAttribute("searchTerm", search);
        model.addAttribute("chatHistory", chatHistory);

        return "investorMessages";
    }

    // New method to show the list of all investors
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
            Model model, HttpSession session, RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt = getUserIdFromSession(session, redirectAttributes);
        if (userIdOpt.isEmpty()) return "redirect:/login";

        Long investorId = userIdOpt.get();

        Optional<Investor> investorOptional = investorRepository.findById(investorId);
        if (investorOptional.isEmpty()) return "redirect:/login";

        model.addAttribute("investor", investorOptional.get());

        Optional<Startup> startup = startupService.getStartupById(id);
        if (startup.isEmpty()) return "redirect:/investor/dashboard";

        model.addAttribute("startup", startup.get());

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