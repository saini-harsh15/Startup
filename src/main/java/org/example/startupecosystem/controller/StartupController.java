package org.example.startupecosystem.controller;

import jakarta.servlet.http.HttpSession;
import org.example.startupecosystem.entity.ChatMessage;
import org.example.startupecosystem.entity.Startup;
import org.example.startupecosystem.entity.Investor;
import org.example.startupecosystem.repository.StartupRepository;
import org.example.startupecosystem.service.ChatService;
import org.example.startupecosystem.service.NewsService;
import org.example.startupecosystem.service.StartupService;
import org.example.startupecosystem.service.InvestorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/startup")
public class StartupController {

    @Autowired
    private StartupRepository startupRepository;

    @Autowired
    private StartupService startupService;

    @Autowired
    private NewsService newsService;

    @Autowired
    private ChatService chatService;

    @Autowired
    private InvestorService investorService;

    // --- Helper method for robust session ID retrieval (FIX) ---
    private Optional<Long> getUserIdFromSession(HttpSession session, String expectedRole, RedirectAttributes redirectAttributes) {
        Object userIdObj = session.getAttribute("loggedInUserId");
        String role = (String) session.getAttribute("loggedInRole");

        if (userIdObj == null || !expectedRole.equals(role)) {
            return Optional.empty(); // Fails authentication
        }

        try {
            // Safely parse the ID regardless of whether Spring stored it as String or Long.
            Long userId = (userIdObj instanceof String) ? Long.parseLong((String) userIdObj) : (Long) userIdObj;
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


    @GetMapping("/dashboard/{id}")
    public String showStartupDashboard(@PathVariable("id") Long id, Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        // Use helper to validate session
        Optional<Long> userIdOpt = getUserIdFromSession(session, "Startup", redirectAttributes);
        if (userIdOpt.isEmpty()) {
            return "redirect:/login";
        }
        Long userId = userIdOpt.get();

        Optional<Startup> startupOptional = startupRepository.findById(userId);
        if (startupOptional.isPresent()) {
            Startup startup = startupOptional.get();
            model.addAttribute("startup", startup);

            // --- Dashboard metrics (placeholder) ---
            model.addAttribute("totalInvestments", 0);
            model.addAttribute("totalMessages", 0);
            model.addAttribute("profileViews", 0);

            // --- News Fetching Logic ---
            String industry = startup.getIndustry();
            String topic = (industry != null && !industry.trim().isEmpty()) ? industry.trim() : "startup";
            model.addAttribute("newsList", newsService.fetchNews(topic));

            return "startupDashboard";
        } else {
            return "redirect:/";
        }
    }

    /**
     * Handles the request for the real-time messaging page, loads chat history, and handles partner search.
     */
    @GetMapping("/messages")
    public String showMessagesPage(
            @RequestParam(value = "search", required = false) String search,
            Model model, HttpSession session, RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt = getUserIdFromSession(session, "Startup", redirectAttributes);
        if (userIdOpt.isEmpty()) {
            return "redirect:/login";
        }
        Long startupId = userIdOpt.get();

        // Fetch startup object (for navbar context)
        Optional<Startup> startupOptional = startupRepository.findById(startupId);
        if (startupOptional.isPresent()) {
            model.addAttribute("startup", startupOptional.get());
        } else {
            return "redirect:/login";
        }

        // --- 1. Fetch Investor Partners (Filtered or All) ---
        List<Investor> investors;
        if (search != null && !search.trim().isEmpty()) {
            investors = investorService.searchInvestors(search.trim());
        } else {
            investors = investorService.findAll();
        }

        // --- 2. Chat History (Initial Load) ---
        // NOTE: We do not load history here, as the client needs to click a user first.
        List<ChatMessage> chatHistory = null;

        // Pass all necessary data to the JSP
        model.addAttribute("startupId", startupId);
        model.addAttribute("investorsList", investors);
        model.addAttribute("searchTerm", search);
        model.addAttribute("chatHistory", chatHistory);

        return "startupMessages";
    }

    @GetMapping("/profile")
    public String showProfile(Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        Optional<Long> userIdOpt = getUserIdFromSession(session, "Startup", redirectAttributes);
        if (userIdOpt.isEmpty()) {
            return "redirect:/login";
        }
        Long userId = userIdOpt.get();

        Optional<Startup> startupOptional = startupRepository.findById(userId);
        if (startupOptional.isPresent()) {
            model.addAttribute("startup", startupOptional.get());
            return "startupProfile";
        } else {
            redirectAttributes.addFlashAttribute("error", "Profile not found.");
            return "redirect:/startup/dashboard/" + userId;
        }
    }

    @PostMapping("/profile/save")
    public String saveProfile(
            @RequestParam("companyName") String name,
            @RequestParam("description") String description,
            @RequestParam("industry") String industry,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt = getUserIdFromSession(session, "Startup", redirectAttributes);
        if (userIdOpt.isEmpty()) {
            return "redirect:/login";
        }
        Long userId = userIdOpt.get();

        try {
            Startup updatedStartup = startupService.updateStartupProfile(userId, name, description, industry);
            redirectAttributes.addFlashAttribute("message", "Profile updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "An error occurred while saving your profile.");
        }

        return "redirect:/startup/dashboard/" + userId;
    }
}