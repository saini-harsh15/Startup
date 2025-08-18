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

    @GetMapping("/dashboard")
    public String showInvestorDashboard(Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        Object userIdObj = session.getAttribute("loggedInUserId");
        if (userIdObj == null || !"Investor".equals(session.getAttribute("loggedInRole"))) {
            return "redirect:/login"; // Redirect to login if not authenticated or not an investor
        }

        // Get the investor object and add to the model
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
            // Should not happen if session is valid, but good practice to handle
            return "redirect:/";
        }

        List<Startup> startups = startupService.getAllStartups();
        model.addAttribute("startups", startups);
        return "investorDashboard";
    }

    @GetMapping("/dashboard/{id}")
    public String showInvestorDashboardById(@PathVariable Long id, Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        Object userIdObj = session.getAttribute("loggedInUserId");
        if (userIdObj == null || !"Investor".equals(session.getAttribute("loggedInRole"))) {
            return "redirect:/login"; // Redirect to login if not authenticated or not an investor
        }

        Optional<Investor> investorOptional = investorRepository.findById(id);
        if (investorOptional.isPresent()) {
            model.addAttribute("investor", investorOptional.get());
        } else {
            redirectAttributes.addFlashAttribute("error", "Investor profile not found.");
            return "redirect:/";
        }

        List<Startup> startups = startupService.getAllStartups();
        model.addAttribute("startups", startups);

        return "investorDashboard";
    }

    @GetMapping("/startup/{id}")
    public String showStartupProfile(@PathVariable("id") Long id, Model model, HttpSession session) {
        if (session.getAttribute("loggedInUserId") == null || !"Investor".equals(session.getAttribute("loggedInRole"))) {
            return "redirect:/login"; // Redirect to login if not authenticated or not an investor
        }

        Optional<Startup> startup = startupService.getStartupById(id);
        if (startup.isPresent()) {
            model.addAttribute("startup", startup.get());
            return "startupProfile";
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
            // Check if the object is a String and parse it
            if (userIdObj instanceof String) {
                userId = Long.parseLong((String) userIdObj);
            } else {
                // If the object is already a Long, cast it directly
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
}