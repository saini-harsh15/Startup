package org.example.startupecosystem.controller;

import jakarta.servlet.http.HttpSession;
import org.example.startupecosystem.entity.*;
import org.example.startupecosystem.repository.InvestmentRequestRepository;
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

    @Autowired
    private InvestmentRequestRepository investmentRequestRepository;

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
        } catch (Exception e) {
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
       ✅ STARTUP DASHBOARD (CLEAN + UX-DRIVEN)
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

        // 🔒 SECURITY CHECK
        if (!loggedInStartupId.equals(id)) {
            return "redirect:/login";
        }

        Startup startup = startupRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Startup not found"));

        model.addAttribute("startup", startup);

        // ---------- METRICS ----------
        long profileViews =
                startupProfileViewRepository.countByStartupId(id);
        model.addAttribute("profileViews", profileViews);

        model.addAttribute("totalInvestments", 0); // later from ACCEPTED
        model.addAttribute("totalMessages", 0);
        // -----------------------------

        // ================= INVESTMENT REQUESTS (UX LOGIC) =================
        List<InvestmentRequest> allRequests =
                investmentRequestRepository
                        .findByStartupIdOrderByCreatedAtDesc(id);

        // Pending ONLY → dashboard main list (max 4)
        List<InvestmentRequest> pendingRequests = allRequests.stream()
                .filter(r -> r.getStatus() == InvestmentRequestStatus.PENDING)
                .limit(4)
                .toList();

        // True pending count (for summary card)
        long pendingCount = allRequests.stream()
                .filter(r -> r.getStatus() == InvestmentRequestStatus.PENDING)
                .count();

        model.addAttribute("pendingRequests", pendingRequests);
        model.addAttribute("pendingRequestCount", pendingCount);
        // ==================================================================

        // ---------- NEWS ----------
        String topic = (startup.getIndustry() != null && !startup.getIndustry().trim().isEmpty())
                ? startup.getIndustry().trim()
                : "startup";

        model.addAttribute("newsList", newsService.fetchNews(topic));
        // --------------------------

        return "startupDashboard";
    }

    @GetMapping("/investments")
    public String showAllInvestmentRequests(
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt =
                getUserIdFromSession(session, "Startup", redirectAttributes);

        if (userIdOpt.isEmpty()) {
            return "redirect:/login";
        }

        Long startupId = userIdOpt.get();

        Startup startup = startupRepository.findById(startupId)
                .orElseThrow(() -> new RuntimeException("Startup not found"));

        List<InvestmentRequest> allRequests =
                investmentRequestRepository
                        .findByStartupIdOrderByCreatedAtDesc(startupId);

        model.addAttribute("startup", startup);
        model.addAttribute("allRequests", allRequests);

        return "startupInvestmentRequests";
    }

    /* ================= INVESTMENT REQUEST REVIEW ================= */

    @GetMapping("/investment-requests/{requestId}")
    public String reviewInvestmentRequest(
            @PathVariable Long requestId,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt =
                getUserIdFromSession(session, "Startup", redirectAttributes);

        if (userIdOpt.isEmpty()) {
            return "redirect:/login";
        }

        Long startupId = userIdOpt.get();

        InvestmentRequest request = investmentRequestRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Request not found"));

        // 🔒 SECURITY CHECK
        if (!request.getStartup().getId().equals(startupId)) {
            return "redirect:/login";
        }

        model.addAttribute("request", request);
        return "investmentRequestReview";
    }


    @PostMapping("/investment-requests/{requestId}/accept")
    public String acceptInvestmentRequest(
            @PathVariable Long requestId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Long startupId = getUserIdFromSession(session, "Startup", redirectAttributes)
                .orElseThrow();

        InvestmentRequest request = investmentRequestRepository.findById(requestId)
                .orElseThrow();

        if (!request.getStartup().getId().equals(startupId)
                || request.getStatus() != InvestmentRequestStatus.PENDING) {
            return "redirect:/startup/dashboard/" + startupId;
        }

        request.setStatus(InvestmentRequestStatus.ACCEPTED);
        investmentRequestRepository.save(request);

        redirectAttributes.addFlashAttribute(
                "success", "Investment request accepted");

        return "redirect:/startup/dashboard/" + startupId;
    }


    @PostMapping("/investment-requests/{requestId}/reject")
    public String rejectInvestmentRequest(
            @PathVariable Long requestId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Long startupId = getUserIdFromSession(session, "Startup", redirectAttributes)
                .orElseThrow();

        InvestmentRequest request = investmentRequestRepository.findById(requestId)
                .orElseThrow();

        if (!request.getStartup().getId().equals(startupId)
                || request.getStatus() != InvestmentRequestStatus.PENDING) {
            return "redirect:/startup/dashboard/" + startupId;
        }

        request.setStatus(InvestmentRequestStatus.REJECTED);
        investmentRequestRepository.save(request);

        redirectAttributes.addFlashAttribute(
                "success", "Investment request rejected");

        return "redirect:/startup/dashboard/" + startupId;
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

        Startup startup = startupRepository.findById(startupId)
                .orElseThrow(() -> new RuntimeException("Startup not found"));

        model.addAttribute("startup", startup);

        List<Investor> investors;

        if (search != null && !search.trim().isEmpty()) {

            // 🔍 SEARCH ENTIRE INVESTOR DATABASE
            investors = investorService.searchInvestors(search.trim());

        } else {

            // 💬 SHOW ONLY EXISTING CHAT PARTNERS
            List<Long> partnerIds = chatService.getChatPartnerIds(startupId);

            if (partnerIds.isEmpty()) {
                investors = List.of();
            } else {
                investors = investorService.findAllByIds(partnerIds);
            }
        }



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

        Startup startup = startupRepository.findById(startupId)
                .orElseThrow(() -> new RuntimeException("Startup not found"));

        model.addAttribute("startup", startup);
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

        startupService.updateStartupProfile(
                startupId, name, description, industry);

        redirectAttributes.addFlashAttribute(
                "message", "Profile updated successfully!");

        return "redirect:/startup/dashboard/" + startupId;
    }
}
