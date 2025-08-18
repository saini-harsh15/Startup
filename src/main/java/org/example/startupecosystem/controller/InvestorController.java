package org.example.startupecosystem.controller;

import jakarta.servlet.http.HttpSession;
import org.example.startupecosystem.entity.Investor;
import org.example.startupecosystem.entity.Startup;
import org.example.startupecosystem.repository.InvestorRepository;
import org.example.startupecosystem.service.InvestorService;
import org.example.startupecosystem.service.StartupService;
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

    @GetMapping({"/dashboard", "/dashboard/{id}"})
    public String showInvestorDashboard(
            @PathVariable(value = "id", required = false) Long id,
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "industry", required = false) String industry,
            Model model, HttpSession session, RedirectAttributes redirectAttributes) {

        Object userIdObj = session.getAttribute("loggedInUserId");
        if (userIdObj == null || !"Investor".equals(session.getAttribute("loggedInRole"))) {
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

        Optional<Investor> investorOptional = investorRepository.findById(userId);
        if (investorOptional.isPresent()) {
            model.addAttribute("investor", investorOptional.get());
        } else {
            return "redirect:/";
        }

        List<Startup> startups = startupService.findStartupsByCriteria(search, industry);
        model.addAttribute("startups", startups);
        model.addAttribute("industries", startupService.getDistinctIndustries());
        model.addAttribute("currentSearch", search);
        model.addAttribute("currentIndustry", industry);

        return "investorDashboard";
    }

    @GetMapping("/startup/{id}")
    public String showStartupProfile(@PathVariable("id") Long id, Model model, HttpSession session) {
        Object userIdObj = session.getAttribute("loggedInUserId");
        if (userIdObj == null || !"Investor".equals(session.getAttribute("loggedInRole"))) {
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
            return "redirect:/login";
        }

        Optional<Investor> investorOptional = investorRepository.findById(userId);
        if (investorOptional.isPresent()) {
            model.addAttribute("investor", investorOptional.get());
        } else {
            return "redirect:/login";
        }

        Optional<Startup> startup = startupService.getStartupById(id);
        if (startup.isPresent()) {
            model.addAttribute("startup", startup.get());
            return "startupExpandedView";
        } else {
            return "redirect:/investor/dashboard";
        }
    }

    @GetMapping("/profile")
    public String showProfile(Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        Object userIdObj = session.getAttribute("loggedInUserId");
        if (userIdObj == null || !"Investor".equals(session.getAttribute("loggedInRole"))) {
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

        Optional<Investor> investorOptional = investorRepository.findById(userId);
        if (investorOptional.isPresent()) {
            model.addAttribute("investor", investorOptional.get());
            return "investorprofile";
        } else {
            redirectAttributes.addFlashAttribute("error", "Profile not found.");
            return "redirect:/investor/dashboard/" + userId;
        }
    }

    @PostMapping("/profile/save")
    public String saveProfile(
            @RequestParam("investorName") String investorName,
            @RequestParam("bio") String bio,
            @RequestParam("investmentPreferences") String investmentPreferences,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Object userIdObj = session.getAttribute("loggedInUserId");
        if (userIdObj == null || !"Investor".equals(session.getAttribute("loggedInRole"))) {
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
            Investor updatedInvestor = investorService.updateInvestorProfile(userId, investorName, bio, investmentPreferences);
            redirectAttributes.addFlashAttribute("message", "Profile updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "An error occurred while saving your profile.");
        }

        return "redirect:/investor/dashboard/" + userId;
    }

    @PostMapping("/apply-for-investment")
    public String applyForInvestment(
            @RequestParam("startupId") Long startupId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Object userIdObj = session.getAttribute("loggedInUserId");
        if (userIdObj == null || !"Investor".equals(session.getAttribute("loggedInRole"))) {
            redirectAttributes.addFlashAttribute("error", "Your session has expired. Please log in again.");
            return "redirect:/login";
        }

        Long investorId;
        try {
            if (userIdObj instanceof String) {
                investorId = Long.parseLong((String) userIdObj);
            } else {
                investorId = (Long) userIdObj;
            }
        } catch (NumberFormatException | ClassCastException e) {
            redirectAttributes.addFlashAttribute("error", "An authentication error occurred. Please log in again.");
            return "redirect:/login";
        }

        redirectAttributes.addFlashAttribute("message", "Your investment application has been submitted successfully!");

        return "redirect:/investor/startup/" + startupId;
    }
}