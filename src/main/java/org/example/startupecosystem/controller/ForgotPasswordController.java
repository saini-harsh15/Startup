package org.example.startupecosystem.controller;

import org.example.startupecosystem.entity.PasswordResetToken;
import org.example.startupecosystem.entity.Startup;
import org.example.startupecosystem.repository.PasswordResetTokenRepository;
import org.example.startupecosystem.repository.StartupRepository;
import org.example.startupecosystem.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

@Controller
public class ForgotPasswordController {

    @Autowired
    private PasswordResetTokenRepository tokenRepo;

    @Autowired
    private StartupRepository startupRepository;

    @Autowired
    private EmailService emailService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // ================= FORGOT PASSWORD PAGE =================
    @GetMapping("/forgot-password")
    public String forgotPasswordPage() {
        return "forget-password";
    }

    // ================= FORGOT PASSWORD =================
    @PostMapping("/forgot-password")
    public String sendResetLink(@RequestParam String email, Model model) {

        Optional<Startup> startupOpt = startupRepository.findByEmail(email);

        // Security best practice: same message either way
        if (startupOpt.isEmpty()) {
            model.addAttribute(
                    "message",
                    "If the email exists, a reset link has been sent."
            );
            return "forget-password";
        }

        // Optionally delete any existing tokens for this email to keep only one active
        // tokenRepo.deleteAllByEmail(email); // if implemented

        String token = UUID.randomUUID().toString();

        PasswordResetToken resetToken = new PasswordResetToken();
        resetToken.setToken(token);
        resetToken.setEmail(email);
        resetToken.setExpiryTime(LocalDateTime.now().plusMinutes(15));

        tokenRepo.save(resetToken);

        String link = "http://localhost:8080/reset-password?token=" + token;

        try {
            emailService.sendPasswordResetEmail(email, link);
            System.out.println("RESET LINK => " + link); // Also log for local testing
        } catch (Exception e) {
            // Do not reveal email errors to the user; log for troubleshooting
            System.out.println("[ForgotPassword] Failed to send reset email: " + e.getMessage());
        }

        model.addAttribute(
                "message",
                "If the email exists, a reset link has been sent."
        );
        return "forget-password";
    }

    // ================= RESET PAGE =================
    @GetMapping("/reset-password")
    public String resetPasswordPage(@RequestParam String token, Model model) {
        Optional<PasswordResetToken> tokenOpt = tokenRepo.findByToken(token);
        if (tokenOpt.isEmpty()) {
            model.addAttribute("error", "Invalid or expired reset link");
            return "reset-password";
        }
        PasswordResetToken resetToken = tokenOpt.get();
        if (resetToken.getExpiryTime().isBefore(LocalDateTime.now())) {
            model.addAttribute("error", "Reset link has expired");
            return "reset-password";
        }
        model.addAttribute("token", token);
        return "reset-password";
    }

    // ================= RESET SUBMIT =================
    @PostMapping("/reset-password")
    public String handleReset(
            @RequestParam String token,
            @RequestParam String password,
            @RequestParam String confirmPassword,
            Model model) {

        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "Passwords do not match");
            model.addAttribute("token", token);
            return "reset-password";
        }

        PasswordResetToken resetToken = tokenRepo.findByToken(token)
                .orElseThrow(() -> new RuntimeException("Invalid reset token"));

        if (resetToken.getExpiryTime().isBefore(LocalDateTime.now())) {
            model.addAttribute("error", "Reset link has expired");
            return "reset-password";
        }

        Startup startup = startupRepository
                .findByEmail(resetToken.getEmail())
                .orElseThrow(() -> new RuntimeException("Account not found"));

        startup.setPassword(passwordEncoder.encode(password));
        startupRepository.save(startup);

        tokenRepo.delete(resetToken);

        return "redirect:/login";
    }

    private void sendPasswordResetEmailSafe(String toEmail, String link) throws Exception {
        String subject = "Reset your password – Startup Ecosystem";
        String body = "<p>We received a request to reset your password.</p>" +
                "<p>Click the link below to set a new password. This link expires in 15 minutes.</p>" +
                "<p><a href='" + link + "'>Reset Password</a></p>" +
                "<p>If you didn't request this, you can ignore this email.</p>";
        emailServiceSendHtml(toEmail, subject, body);
        System.out.println("RESET LINK => " + link); // Still log for local testing
    }

    private void emailServiceSendHtml(String to, String subject, String html) throws Exception {
        // Reuse EmailService's JavaMailSender via a simple adapter method without changing EmailService API
        // Ideally EmailService should have a dedicated method, but to avoid broader changes we send directly.
        // We'll extend EmailService in-place with a generic sendHtml method if available.
        emailService.getClass(); // no-op to avoid unused warning
        // Since EmailService currently only supports contact email, we’ll add a new method there.
        throw new UnsupportedOperationException("Email sender not wired. Please implement in EmailService.");
    }
}
