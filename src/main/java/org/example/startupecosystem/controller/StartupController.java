package org.example.startupecosystem.controller;

import jakarta.servlet.http.HttpSession;
import org.example.startupecosystem.dto.ProfileViewerAnalyticsDTO;
import org.example.startupecosystem.dto.ProfileViewerDTO;
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
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import com.fasterxml.jackson.databind.ObjectMapper;
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

        Optional<Startup> startupOpt = startupRepository.findById(id);
        if (startupOpt.isEmpty()) {
            session.invalidate();
            return "redirect:/login";
        }
        Startup startup = startupOpt.get();


        model.addAttribute("startup", startup);

        // ---------- METRICS ----------
        long profileViews = startupProfileViewRepository.countUniqueViewers(id);
        model.addAttribute("profileViews", profileViews);

        Double totalInvestment =
                investmentRequestRepository.getTotalAcceptedInvestmentByStartupId(id);

        model.addAttribute("totalInvestment", totalInvestment);
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


    @GetMapping("/accepted-investments")
    public String showAcceptedInvestments(
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes)throws Exception {

        Optional<Long> userIdOpt =
                getUserIdFromSession(session, "Startup", redirectAttributes);

        if (userIdOpt.isEmpty()) {
            return "redirect:/login";
        }

        Long startupId = userIdOpt.get();

        Startup startup = startupRepository.findById(startupId)
                .orElseThrow(() -> new RuntimeException("Startup not found"));

        List<InvestmentRequest> acceptedRequests =
                investmentRequestRepository
                        .findByStartupIdAndStatusOrderByCreatedAtDesc(
                                startupId,
                                InvestmentRequestStatus.ACCEPTED);

        // ================= FORMAT FOR DISPLAY =================

        DateTimeFormatter formatter =
                DateTimeFormatter.ofPattern("dd MMM yyyy");

        List<Map<String, Object>> formattedRequests =
                acceptedRequests.stream().map(req -> {

                    Map<String, Object> map = new HashMap<>();
                    map.put("investorName",
                            req.getInvestor().getInvestorName());
                    map.put("amount", req.getAmount());
                    map.put("formattedDate",
                            req.getCreatedAt().format(formatter));
                    map.put("fundingStage",
                            req.getFundingStage());

                    return map;

                }).toList();

        // ================= MONTHLY AGGREGATION =================

        Map<String, Double> monthlyMap =
                acceptedRequests.stream()
                        .collect(java.util.stream.Collectors.groupingBy(
                                req -> req.getCreatedAt()
                                        .getMonth()
                                        .toString() + " " +
                                        req.getCreatedAt().getYear(),
                                java.util.stream.Collectors.summingDouble(
                                        InvestmentRequest::getAmount)
                        ));

        List<String> chartMonths = new java.util.ArrayList<>(monthlyMap.keySet());
        List<Double> chartTotals = new java.util.ArrayList<>(monthlyMap.values());

        // ================= FUNDING STAGE AGGREGATION =================

        Map<String, Double> stageMap =
                acceptedRequests.stream()
                        .collect(java.util.stream.Collectors.groupingBy(
                                InvestmentRequest::getFundingStage,
                                java.util.stream.Collectors.summingDouble(
                                        InvestmentRequest::getAmount)
                        ));

        List<String> stageLabels = new java.util.ArrayList<>(stageMap.keySet());
        List<Double> stageTotals = new java.util.ArrayList<>(stageMap.values());

        Double totalInvestment =
                investmentRequestRepository
                        .getTotalAcceptedInvestmentByStartupId(startupId);

        model.addAttribute("startup", startup);
        model.addAttribute("acceptedRequests", formattedRequests);
        model.addAttribute("totalInvestment", totalInvestment);

        ObjectMapper mapper = new ObjectMapper();

        model.addAttribute("chartMonthsJson",
                chartMonths.isEmpty() ? "[]" :
                        mapper.writeValueAsString(chartMonths));

        model.addAttribute("chartTotalsJson",
                chartTotals.isEmpty() ? "[]" :
                        mapper.writeValueAsString(chartTotals));

        model.addAttribute("stageLabelsJson",
                stageLabels.isEmpty() ? "[]" :
                        mapper.writeValueAsString(stageLabels));

        model.addAttribute("stageTotalsJson",
                stageTotals.isEmpty() ? "[]" :
                        mapper.writeValueAsString(stageTotals));

        return "startupAcceptedInvestments";
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

        Optional<Long> userIdOpt =
                getUserIdFromSession(session, "Startup", redirectAttributes);

        if (userIdOpt.isEmpty()) {
            return "redirect:/login";
        }

        Long startupId = userIdOpt.get();


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

        Optional<Long> userIdOpt =
                getUserIdFromSession(session, "Startup", redirectAttributes);

        if (userIdOpt.isEmpty()) {
            return "redirect:/login";
        }

        Long startupId = userIdOpt.get();


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


    @GetMapping("/profile-viewers")
    public org.springframework.http.ResponseEntity<List<ProfileViewerDTO>> getProfileViewers(
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt =
                getUserIdFromSession(session, "Startup", redirectAttributes);

        if (userIdOpt.isEmpty()) {
            return org.springframework.http.ResponseEntity.status(401).body(List.of());
        }

        Long startupId = userIdOpt.get();

        List<StartupProfileViewEntity> views =
                startupProfileViewRepository.findTop20ByStartupIdOrderByViewedAtDesc(startupId);

        List<Long> investorIds = views.stream()
                .map(StartupProfileViewEntity::getInvestorId)
                .distinct()
                .toList();

        List<Investor> investors = investorService.findAllByIds(investorIds);

        List<ProfileViewerDTO> response = views.stream().map(view -> {
            Investor investor = investors.stream()
                    .filter(i -> i.getId().equals(view.getInvestorId()))
                    .findFirst().orElse(null);

            return new ProfileViewerDTO(
                    view.getInvestorId(),
                    investor != null ? investor.getInvestorName() : "Unknown",
                    investor != null ? investor.getInvestorType() : "",
                    view.getViewedAt()
            );
        }).toList();

        return org.springframework.http.ResponseEntity.ok(response);
    }


    @GetMapping("/profile-analytics")
    public String profileAnalytics(
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<Long> userIdOpt =
                getUserIdFromSession(session, "Startup", redirectAttributes);

        if (userIdOpt.isEmpty()) {
            return "redirect:/login";
        }

        Long startupId = userIdOpt.get();

        Optional<Startup> startupOpt = startupRepository.findById(startupId);
        if (startupOpt.isEmpty()) {
            session.invalidate();
            return "redirect:/login";
        }

        Startup startup = startupOpt.get();

        List<Object[]> rows = startupProfileViewRepository.findViewerAnalytics(startupId);

        List<Long> investorIds = rows.stream()
                .map(r -> (Long) r[0])
                .toList();

        List<Investor> investors = investorService.findAllByIds(investorIds);

        List<ProfileViewerAnalyticsDTO> analytics = rows.stream().map(r -> {

            Long investorId = (Long) r[0];
            long visits = (Long) r[1];
            java.time.LocalDateTime lastViewed = (java.time.LocalDateTime) r[2];

            Investor inv = investors.stream()
                    .filter(i -> i.getId().equals(investorId))
                    .findFirst().orElse(null);

            int score = (int)(visits * 5);

            long hoursSinceLastView =
                    java.time.Duration.between(lastViewed, java.time.LocalDateTime.now()).toHours();

            if (hoursSinceLastView < 24) score += 20;
            else if (hoursSinceLastView < 72) score += 10;

            String temperature =
                    score >= 35 ? "HOT" :
                            score >= 18 ? "WARM" : "COLD";

            String lastSeenText =
                    hoursSinceLastView < 1 ? "Active now" :
                            hoursSinceLastView < 6 ? "Viewed recently" :
                                    hoursSinceLastView < 24 ? "Viewed today" :
                                            hoursSinceLastView < 72 ? "Seen this week" :
                                                    "Inactive lead";

            return new ProfileViewerAnalyticsDTO(
                    investorId,
                    inv != null ? inv.getInvestorName() : "Unknown",
                    inv != null ? inv.getInvestorType() : "",
                    visits,
                    lastViewed,
                    score,
                    temperature,
                    lastSeenText
            );

        }).toList();

        model.addAttribute("startup", startup);
        model.addAttribute("analytics", analytics);

        return "startupProfileAnalytics";
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
