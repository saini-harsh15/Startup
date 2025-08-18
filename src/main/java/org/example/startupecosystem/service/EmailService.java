package org.example.startupecosystem.service;

import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    private static final String[] TEAM_EMAILS = {
            "harshsaini2462@gmail.com",
            "ashutoshgola91@gmail.com",
            "ryash0353@gmail.com"
    };

    public void sendContactFormEmail(String senderName, String senderEmail, String message) throws jakarta.mail.MessagingException {
        // Build the HTML body for a professional look
        String htmlBody = String.format(
                "<html>" +
                        "<body style='font-family: Arial, sans-serif;'>" +
                        "<h2>New Contact Form Submission</h2>" +
                        "<p>A new message has been submitted through the contact form on your website.</p>" +
                        "<hr style='border: 1px solid #ddd;'>" +
                        "<div style='background-color: #f7f7f7; padding: 15px; border-radius:5px;'>" +
                        "<p><strong>Sender Name:</strong> %s</p>" +
                        "<p><strong>Sender Email:</strong> %s</p>" +
                        "<p><strong>Message:</strong></p>" +
                        "<div style='border: 1px solid #ccc; padding: 10px; background-color: #fff; border-radius: 5px;'>" +
                        "<p>%s</p>" +
                        "</div>" +
                        "</div>" +
                        "<p style='color: #888; font-size: 12px; margin-top: 20px;'>This is an automated email. Please do not reply directly to this message.</p>" +
                        "</body>" +
                        "</html>",
                senderName, senderEmail, message
        );

        for (String teamEmail : TEAM_EMAILS) {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "utf-8");

            helper.setTo(teamEmail);
            helper.setFrom(senderEmail);
            helper.setSubject("New Contact Form Submission: " + senderName);
            helper.setText(htmlBody, true);

            mailSender.send(mimeMessage);
        }
    }
}