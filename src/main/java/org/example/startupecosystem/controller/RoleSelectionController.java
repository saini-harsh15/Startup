package org.example.startupecosystem.controller;

import jakarta.servlet.http.HttpSession;
import org.example.startupecosystem.dto.UserRegistrationDto;
import org.example.startupecosystem.service.LoginService;
import org.example.startupecosystem.service.SignupService;
import org.example.startupecosystem.service.VerificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
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

    // This method now redirects to the signup page to maintain a proper flow.
    @PostMapping("/selectRole")
    public String selectRole(@RequestParam String role, HttpSession session) {
        session.setAttribute("selectedRole", role);
        return "redirect:/signup";
    }

    @GetMapping("/signup")
    public String showSignupPage(Model model, HttpSession session) {
        String role = (String) session.getAttribute("selectedRole");
        if (role == null) {
            // If no role is selected, redirect back to the role selection page.
            return "redirect:/";
        }
        // Add a new DTO object to the model for the form.
        model.addAttribute("userDto", new UserRegistrationDto());
        return "signup";
    }

    // A single endpoint to handle the complete signup and verification
    @PostMapping("/completeSignup")
    public String completeSignup(@ModelAttribute("userDto") UserRegistrationDto userDto,
                                 RedirectAttributes redirectAttributes,
                                 HttpSession session) {

        // Skip verification for now to allow all users to register
        boolean isVerified = true;

        // The following verification code is commented out to allow all users to register
        // If verification is needed in the future, uncomment this code
        /*
        if ("Startup".equalsIgnoreCase(userDto.getUserType())) {
            isVerified = verificationService.verifyCompany(
                    userDto.getCompanyName(),
                    userDto.getRegistrationNumber(),
                    userDto.getGovernmentId(),
                    userDto.getFoundingDate(),
                    userDto.getIndustry()
            );
        } else if ("Investor".equalsIgnoreCase(userDto.getUserType())) {
            isVerified = verificationService.verifyInvestor(
                    userDto.getInvestorName(),
                    userDto.getInvestmentFirm()
            );
        }
        */

        // Always proceed with registration since verification is bypassed
        if (isVerified) {
            try {
                Long userId = signupService.registerNewUser(
                        userDto.getEmail(),
                        userDto.getPassword(),
                        userDto.getUserType(),
                        userDto.getUserType().equals("Startup") ? userDto.getCompanyName() : userDto.getInvestorName(),
                        userDto.getDescription(),
                        userDto.getIndustry(),
                        userDto.getRegistrationNumber(),
                        userDto.getGovernmentId(),
                        userDto.getFoundingDate(),
                        userDto.getInvestorName(),
                        userDto.getInvestmentFirm()
                );

                // Store user info in session for authentication
                session.setAttribute("loggedInUserId", userId.toString());
                session.setAttribute("loggedInRole", userDto.getUserType());

                // On successful signup, redirect directly to the appropriate dashboard
                if ("Startup".equalsIgnoreCase(userDto.getUserType())) {
                    return "redirect:/startup/dashboard/" + userId;
                } else if ("Investor".equalsIgnoreCase(userDto.getUserType())) {
                    return "redirect:/investor/dashboard/" + userId;
                }

                // Fallback to general dashboard
                return "redirect:/dashboard";
            } catch (Exception e) {
                // Log the exception properly instead of printing the stack trace
                e.printStackTrace();
                redirectAttributes.addFlashAttribute("error", "An error occurred during registration. Please try again.");
                return "redirect:/signup"; // Redirect back to the single signup page
            }
        } else {
            // Verification failed, add an error message and return to the signup page
            redirectAttributes.addFlashAttribute("error", "The provided details could not be verified. Please check your information.");
            return "redirect:/signup";
        }
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