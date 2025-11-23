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

    @GetMapping("/dashboard/{id}")
    public String showStartupDashboard(@PathVariable("id") Long id, Model model, HttpSession session) {
        if (session.getAttribute("loggedInUserId") == null || !"Startup".equals(session.getAttribute("loggedInRole"))) {
            return "redirect:/login";
        }

        Optional<Startup> startupOptional = startupRepository.findById(id);
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
            model.addAttribute("newsTopic", topic);
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
            Model model, HttpSession session) {

        Object userIdObj = session.getAttribute("loggedInUserId");
        if (userIdObj == null || !"Startup".equals(session.getAttribute("loggedInRole"))) {
            return "redirect:/login";
        }

        Long startupId;
        try {
            // Safely cast/parse the userId from session
            startupId = (userIdObj instanceof String) ? Long.parseLong((String) userIdObj) : (Long) userIdObj;
        } catch (Exception e) {
            return "redirect:/login";
        }

        // Fetch startup object (needed for name in the navbar)
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

        // --- 2. Chat History (Initial Load - Setting a safe, empty list) ---
        // History will be loaded dynamically on the client, but we ensure the model attribute exists.
        // We initialize the history to null or an empty list if no partner is selected by default.
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
        Object userIdObj = session.getAttribute("loggedInUserId");
        if (userIdObj == null || !"Startup".equals(session.getAttribute("loggedInRole"))) {
            redirectAttributes.addFlashAttribute("error", "Your session has expired. Please log in again.");
            return "redirect:/login";
        }

        Long userId;
        try {
            if (userIdObj instanceof String) {
                userId = Long.parseLong((String) userIdObj);
            } else {
                userId = (Long) userIdObj;
            }
        } catch (NumberFormatException | ClassCastException e) {
            redirectAttributes.addFlashAttribute("error", "An authentication error occurred. Please log in again.");
            return "redirect:/login";
        }

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

        Object userIdObj = session.getAttribute("loggedInUserId");
        if (userIdObj == null || !"Startup".equals(session.getAttribute("loggedInRole"))) {
            redirectAttributes.addFlashAttribute("error", "Your session has expired. Please log in again.");
            return "redirect:/login";
        }

        Long userId;
        try {
            if (userIdObj instanceof String) {
                userId = Long.parseLong((String) userIdObj);
            } else {
                userId = (Long) userIdObj;
            }
        } catch (NumberFormatException | ClassCastException e) {
            redirectAttributes.addFlashAttribute("error", "An authentication error occurred. Please log in again.");
            return "redirect:/login";
        }

        try {
            Startup updatedStartup = startupService.updateStartupProfile(userId, name, description, industry);
            redirectAttributes.addFlashAttribute("message", "Profile updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "An error occurred while saving your profile.");
        }

        return "redirect:/startup/dashboard/" + userId;
    }
}