package org.example.startupecosystem.controller;

import jakarta.servlet.http.HttpSession;
import org.example.startupecosystem.entity.ChatMessage;
import org.example.startupecosystem.entity.Startup;
import org.example.startupecosystem.entity.Investor;
import org.example.startupecosystem.repository.StartupRepository;
import org.example.startupecosystem.repository.StartupProfileViewRepository;
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

    @Autowired
    private StartupProfileViewRepository startupProfileViewRepository;

    // ---------------- SESSION HELPER (UNCHANGED) ----------------
    private Optional<Long> getUserIdFromSession(
            HttpSession session,
            String expectedRole,
            RedirectAttributes redirectAttributes) {

        Object userIdObj = session.getAttribute("loggedInUserId");
        String role = (String) session.getAttribute("loggedInRole");

        if (userIdObj == null || !expectedRole.equals(role)) {
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
                redirectAttributes.addFlashAttribute(
                        "error", "Authentication error. Please log in again.");
            }
            return Optional.empty();
        }
    }
    // ------------------------------------------------------------


    /* ============================================================
       ✅ OPTION B: DASHBOARD WITH ID (SECURE + CORRECT)
       ============================================================ */
    @GetMapping("/dashboard/{id}")
    public String showStartupDashboard(
            @PathVariable("id") Long id,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt =
                getUserIdFromSession(session, "Startup", redirectAttributes);

        if (userIdOpt.isEmpty()) {
            return "redirect:/login";
        }

        Long loggedInStartupId = userIdOpt.get();

        // 🔒 SECURITY CHECK (CRITICAL)
        if (!loggedInStartupId.equals(id)) {
            return "redirect:/login";
        }

        Optional<Startup> startupOptional =
                startupRepository.findById(id);

        if (startupOptional.isEmpty()) {
            return "redirect:/login";
        }

        Startup startup = startupOptional.get();
        model.addAttribute("startup", startup);

        // ---------- DASHBOARD METRICS ----------
        model.addAttribute("totalInvestments", 0);
        model.addAttribute("totalMessages", 0);

        long profileViews =
                startupProfileViewRepository.countByStartupId(id);
        model.addAttribute("profileViews", profileViews);
        // ---------------------------------------

        // ---------- NEWS ----------
        String industry = startup.getIndustry();
        String topic = (industry != null && !industry.trim().isEmpty())
                ? industry.trim()
                : "startup";

        model.addAttribute("newsList", newsService.fetchNews(topic));
        // --------------------------

        return "startupDashboard";
    }


    /* ===================== MESSAGES ===================== */
    @GetMapping("/messages")
    public String showMessagesPage(
            @RequestParam(value = "search", required = false) String search,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt =
                getUserIdFromSession(session, "Startup", redirectAttributes);

        if (userIdOpt.isEmpty()) {
            return "redirect:/login";
        }

        Long startupId = userIdOpt.get();

        Optional<Startup> startupOptional =
                startupRepository.findById(startupId);

        if (startupOptional.isEmpty()) {
            return "redirect:/login";
        }

        model.addAttribute("startup", startupOptional.get());

        List<Investor> investors =
                (search != null && !search.trim().isEmpty())
                        ? investorService.searchInvestors(search.trim())
                        : investorService.findAll();

        model.addAttribute("startupId", startupId);
        model.addAttribute("investorsList", investors);
        model.addAttribute("searchTerm", search);
        model.addAttribute("chatHistory", null);

        return "startupMessages";
    }


    /* ===================== PROFILE ===================== */
    @GetMapping("/profile")
    public String showProfile(
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt =
                getUserIdFromSession(session, "Startup", redirectAttributes);

        if (userIdOpt.isEmpty()) {
            return "redirect:/login";
        }

        Long startupId = userIdOpt.get();

        Optional<Startup> startupOptional =
                startupRepository.findById(startupId);

        if (startupOptional.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Profile not found.");
            return "redirect:/startup/dashboard/" + startupId;
        }

        model.addAttribute("startup", startupOptional.get());
        return "startupProfile";
    }


    @PostMapping("/profile/save")
    public String saveProfile(
            @RequestParam("companyName") String name,
            @RequestParam("description") String description,
            @RequestParam("industry") String industry,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt =
                getUserIdFromSession(session, "Startup", redirectAttributes);

        if (userIdOpt.isEmpty()) {
            return "redirect:/login";
        }

        Long startupId = userIdOpt.get();

        try {
            startupService.updateStartupProfile(
                    startupId, name, description, industry);
            redirectAttributes.addFlashAttribute(
                    "message", "Profile updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(
                    "error", "An error occurred while saving your profile.");
        }

        return "redirect:/startup/dashboard/" + startupId;
    }
}
