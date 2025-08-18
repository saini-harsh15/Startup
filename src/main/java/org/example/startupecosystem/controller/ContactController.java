package org.example.startupecosystem.controller;

import org.example.startupecosystem.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class ContactController {

    @Autowired
    private EmailService emailService;

    @GetMapping("/contact")
    public String showContactPage() {
        return "contactUs"; // Returns the contactUs.jsp page
    }

    @PostMapping("/contact")
    public String submitContactForm(
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String message,
            RedirectAttributes redirectAttributes) {

        try {
            emailService.sendContactFormEmail(name, email, message);
            redirectAttributes.addFlashAttribute("successMessage", "Your message has been sent successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "There was an error sending your message. Please try again later.");
        }

        return "redirect:/contact"; // Redirects back to the contact page
    }
}