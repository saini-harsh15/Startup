package org.example.startupecosystem.controller;

import jakarta.servlet.http.HttpSession;
import org.example.startupecosystem.dto.UserRegistrationDto;
import org.example.startupecosystem.service.LoginService;
import org.example.startupecosystem.service.SignupService;
import org.example.startupecosystem.service.VerificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class RoleSelectionController {

    @Autowired
    private VerificationService verificationService;

    @Autowired
    private SignupService signupService;

    @Autowired
    private LoginService loginService;

    @GetMapping("/")
    public String showRoleSelectionPage() {
        return "roleselection";
    }

    @GetMapping("/signup/startup")
    public String showStartupSignup(Model model) {
        model.addAttribute("userDto", new UserRegistrationDto());
        return "startup-signup";
    }

    @PostMapping("/completeStartupSignup")
    public String completeStartupSignup(@ModelAttribute("userDto") UserRegistrationDto userDto,
                                        RedirectAttributes redirectAttributes,
                                        HttpSession session) {

        try {

            Long userId = signupService.registerNewUser(
                    userDto.getEmail(),
                    userDto.getPassword(),
                    "Startup",                         // Hardcoded role
                    userDto.getCompanyName(),          // Name
                    userDto.getDescription(),
                    userDto.getIndustry(),
                    userDto.getRegistrationNumber(),
                    userDto.getGovernmentId(),
                    userDto.getFoundingDate(),
                    userDto.getFundingAsk(),
                    userDto.getEquityOffered(),
                    null,                              // Investor name not needed
                    null                               // Investment firm not needed
            );

            session.setAttribute("loggedInUserId", userId.toString());
            session.setAttribute("loggedInRole", "Startup");

            return "redirect:/startup/dashboard/" + userId;

        } catch (IllegalArgumentException e) {
        redirectAttributes.addFlashAttribute("error", e.getMessage());
        return "redirect:/signup/startup";
    } catch (Exception e) {
        e.printStackTrace();
        redirectAttributes.addFlashAttribute("error", "Something went wrong. Please try again.");
        return "redirect:/signup/startup";
    }

}

    @GetMapping("/signup/investor")
    public String showInvestorSignup(Model model) {
        model.addAttribute("userDto", new UserRegistrationDto());
        return "investor-signup";
    }
    @PostMapping("/completeInvestorSignup")
    public String completeInvestorSignup(@ModelAttribute("userDto") UserRegistrationDto userDto,
                                         RedirectAttributes redirectAttributes,
                                         HttpSession session) {

        try {

            Long userId = signupService.registerInvestor(userDto);

            session.setAttribute("loggedInUserId", userId.toString());
            session.setAttribute("loggedInRole", "Investor");

            return "redirect:/investor/dashboard/" + userId;

        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/signup/investor";
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Something went wrong. Please try again.");
            return "redirect:/signup/investor";
        }
    }

    @GetMapping("/check-email")
    @ResponseBody
    public String checkEmail(@RequestParam String email) {

        boolean exists = signupService.emailExists(email);

        return exists ? "EXISTS" : "AVAILABLE";
    }


    @GetMapping("/login")
    public String showLoginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email,
                        @RequestParam String password,
                        RedirectAttributes redirectAttributes,
                        HttpSession session) {

        String[] authResult = loginService.authenticate(email, password);

        if (authResult != null) {
            String role = authResult[0];
            String userId = authResult[1];

            session.setAttribute("loggedInUserId", userId);
            session.setAttribute("loggedInRole", role);
            redirectAttributes.addFlashAttribute("message", "Login successful! Welcome, " + role + "!");

            if ("Startup".equalsIgnoreCase(role)) {
                return "redirect:/startup/dashboard/" + userId;
            } else if ("Investor".equalsIgnoreCase(role)) {
                return "redirect:/investor/dashboard/" + userId;
            }
            return "redirect:/dashboard";
        } else {
            redirectAttributes.addFlashAttribute("message", "Invalid email or password. Please try again.");
            return "redirect:/login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        session.invalidate();
        redirectAttributes.addFlashAttribute("message", "You have been logged out successfully.");
        return "redirect:/";
    }
}