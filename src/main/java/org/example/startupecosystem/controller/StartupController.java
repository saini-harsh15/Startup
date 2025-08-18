package org.example.startupecosystem.controller;

import jakarta.servlet.http.HttpSession;
import org.example.startupecosystem.entity.Startup;
import org.example.startupecosystem.repository.StartupRepository;
import org.example.startupecosystem.service.StartupService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

@Controller
@RequestMapping("/startup")
public class StartupController {

    @Autowired
    private StartupRepository startupRepository;

    @Autowired
    private StartupService startupService;

    @GetMapping("/dashboard/{id}")
    public String showStartupDashboard(@PathVariable("id") Long id, Model model, HttpSession session) {
        if (session.getAttribute("loggedInUserId") == null || !"Startup".equals(session.getAttribute("loggedInRole"))) {
            return "redirect:/login";
        }

        Optional<Startup> startupOptional = startupRepository.findById(id);
        if (startupOptional.isPresent()) {
            model.addAttribute("startup", startupOptional.get());

            // --- New Code: Add dynamic values to the model ---
            // For now, these are placeholder values. In a real application, you would fetch them from the DB.
            model.addAttribute("totalInvestments", 0);
            model.addAttribute("totalMessages", 0);
            model.addAttribute("profileViews", 0);
            // --- End of New Code ---

            return "startupDashboard";
        } else {
            return "redirect:/";
        }
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