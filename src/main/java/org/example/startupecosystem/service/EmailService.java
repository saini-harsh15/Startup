package org.example.startupecosystem.service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    // Team / admin emails
    private static final String[] TEAM_EMAILS = {
            "harshsaini2462@gmail.com",
            "ashutoshgola91@gmail.com",
            "ryash0353@gmail.com"
    };

    // Verified sender email (important for Gmail deliverability)
    private static final String FROM_EMAIL = "Startup Ecosystem <startupecosystemtracker@gmail.com>";

    public void sendContactFormEmail(String senderName,
                                     String senderEmail,
                                     String message) throws MessagingException {

        String htmlBody = String.format(
                "<!DOCTYPE html>" +
                        "<html>" +
                        "<body style='margin:0; padding:0; background-color:#f4f6f8; font-family:Arial, Helvetica, sans-serif;'>" +

                        "<table width='100%%' cellpadding='0' cellspacing='0' style='padding:30px 0;'>" +
                        "  <tr>" +
                        "    <td align='center'>" +

                        "      <table width='600' cellpadding='0' cellspacing='0' " +
                        "             style='background:#ffffff; border-radius:8px; box-shadow:0 4px 12px rgba(0,0,0,0.08); overflow:hidden;'>" +

                        "        <!-- Header -->" +
                        "        <tr>" +
                        "          <td style='background:#28a745; padding:20px; color:#ffffff;'>" +
                        "            <h2 style='margin:0; font-size:20px;'>New Contact Form Submission</h2>" +
                        "            <p style='margin:6px 0 0; font-size:14px; opacity:0.95;'>Startup Ecosystem</p>" +
                        "          </td>" +
                        "        </tr>" +

                        "        <!-- Body -->" +
                        "        <tr>" +
                        "          <td style='padding:24px;'>" +
                        "            <p style='margin-top:0; font-size:14px; color:#333;'>" +
                        "              You’ve received a new message from your website contact form." +
                        "            </p>" +

                        "            <table width='100%%' cellpadding='0' cellspacing='0' style='margin-top:16px;'>" +

                        "              <tr>" +
                        "                <td style='padding:10px 0; font-size:14px; width:120px;'><strong>Name:</strong></td>" +
                        "                <td style='padding:10px 0; font-size:14px; color:#555;'>%s</td>" +
                        "              </tr>" +

                        "              <tr>" +
                        "                <td style='padding:10px 0; font-size:14px;'><strong>Email:</strong></td>" +
                        "                <td style='padding:10px 0; font-size:14px;'>" +
                        "                  <a href='mailto:%s' style='color:#28a745; text-decoration:none;'>%s</a>" +
                        "                </td>" +
                        "              </tr>" +

                        "            </table>" +

                        "            <div style='margin-top:20px;'>" +
                        "              <p style='margin-bottom:8px; font-size:14px;'><strong>Message:</strong></p>" +
                        "              <div style='background:#f7f7f7; border:1px solid #ddd; padding:14px; " +
                        "                          border-radius:6px; font-size:14px; color:#333; white-space:pre-line;'>" +
                        "                %s" +
                        "              </div>" +
                        "            </div>" +

                        "          </td>" +
                        "        </tr>" +

                        "        <!-- Footer -->" +
                        "        <tr>" +
                        "          <td style='background:#fafafa; padding:16px; text-align:center; " +
                        "                     font-size:12px; color:#888;'>" +
                        "            This is an automated message from <strong>Startup Ecosystem</strong>.<br>" +
                        "            Please do not reply directly to this email." +
                        "          </td>" +
                        "        </tr>" +

                        "      </table>" +

                        "    </td>" +
                        "  </tr>" +
                        "</table>" +

                        "</body>" +
                        "</html>",
                senderName,
                senderEmail, senderEmail,
                message
        );

        for (String teamEmail : TEAM_EMAILS) {
            sendHtml(teamEmail, "New Contact Form Submission – " + senderName, htmlBody, senderEmail);
        }
    }

    public void sendHtml(String to, String subject, String html) throws MessagingException {
        sendHtml(to, subject, html, null);
    }

    // Core generic HTML sender used by both contact and reset emails
    public void sendHtml(String to, String subject, String html, String replyTo) throws MessagingException {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
        helper.setTo(to);
        helper.setFrom(FROM_EMAIL);
        if (replyTo != null && !replyTo.isBlank()) {
            helper.setReplyTo(replyTo);
        }
        helper.setSubject(subject);
        helper.setText(html, true);
        mailSender.send(mimeMessage);
    }

    // ==================== RESET PASSWORD EMAIL ====================
    public String buildResetPasswordEmail(String resetLink) {
        String safeUrl = resetLink == null ? "" : resetLink;
        // Modern, mobile-friendly table layout with inline styles (email-client safe)
        return "<!DOCTYPE html>" +
                "<html lang='en'>" +
                "<head>" +
                "  <meta charset='UTF-8'>" +
                "  <meta http-equiv='X-UA-Compatible' content='IE=edge'>" +
                "  <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "  <title>Reset your password</title>" +
                "  <style>" +
                "    @media (prefers-color-scheme: dark) { .card { background:#1f2937 !important; color:#e5e7eb !important; } }" +
                "  </style>" +
                "</head>" +
                "<body style='margin:0; padding:0; background-color:#f4f6f8;'>" +
                "  <div style='display:none; font-size:1px; color:#f4f6f8; line-height:1px; max-height:0; max-width:0; opacity:0; overflow:hidden;'>" +
                "    Use this link to reset your Startup Ecosystem password. Link expires in 15 minutes." +
                "  </div>" +
                "  <table role='presentation' width='100%' cellpadding='0' cellspacing='0' style='background:#f4f6f8; padding:24px 0;'>" +
                "    <tr>" +
                "      <td align='center'>" +
                "        <table role='presentation' width='600' cellpadding='0' cellspacing='0' style='width:600px; max-width:95%; background:#ffffff; border-radius:12px; box-shadow:0 6px 18px rgba(0,0,0,0.08); overflow:hidden;' class='card'>" +
                "          <tr>" +
                "            <td style='background:#28a745; padding:20px 24px; color:#ffffff;'>" +
                "              <h1 style='margin:0; font-family:Arial,Helvetica,sans-serif; font-size:20px;'>Startup Ecosystem</h1>" +
                "              <p style='margin:6px 0 0; font-size:13px; opacity:0.95; font-family:Arial,Helvetica,sans-serif;'>Password reset request</p>" +
                "            </td>" +
                "          </tr>" +
                "          <tr>" +
                "            <td style='padding:26px; font-family:Arial,Helvetica,sans-serif; color:#333;'>" +
                "              <p style='margin:0 0 12px; font-size:15px;'>We received a request to reset your password.</p>" +
                "              <p style='margin:0 0 20px; font-size:14px; color:#555;'>Click the button below to set a new password. This link expires in <strong>15 minutes</strong>.</p>" +
                "              <table role='presentation' cellpadding='0' cellspacing='0' style='margin:0 0 16px;'>" +
                "                <tr>" +
                "                  <td align='center' style='border-radius:8px;' bgcolor='#28a745'>" +
                "                    <a href='" + safeUrl + "' style='display:inline-block; padding:12px 22px; color:#ffffff; background:#28a745; text-decoration:none; font-size:15px; border-radius:8px; font-weight:bold; font-family:Arial,Helvetica,sans-serif;'>Reset Password</a>" +
                "                  </td>" +
                "                </tr>" +
                "              </table>" +
                "              <p style='margin:0 0 10px; font-size:13px; color:#777;'>If the button doesn't work, copy and paste this link into your browser:</p>" +
                "              <p style='margin:0 0 18px; font-size:13px; word-break:break-all;'><a href='" + safeUrl + "' style='color:#28a745; text-decoration:none;'>" + safeUrl + "</a></p>" +
                "              <p style='margin:0; font-size:12px; color:#888;'>If you didn’t request this, you can safely ignore this email.</p>" +
                "            </td>" +
                "          </tr>" +
                "          <tr>" +
                "            <td style='background:#fafafa; padding:16px 24px; text-align:center; font-size:12px; color:#888; font-family:Arial,Helvetica,sans-serif;'>" +
                "              © " + java.time.Year.now() + " Startup Ecosystem • This email was sent automatically." +
                "            </td>" +
                "          </tr>" +
                "        </table>" +
                "      </td>" +
                "    </tr>" +
                "  </table>" +
                "</body>" +
                "</html>";
    }

    public void sendPasswordResetEmail(String to, String resetLink) throws MessagingException {
        String subject = "Reset your password – Startup Ecosystem";
        String html = buildResetPasswordEmail(resetLink);
        sendHtml(to, subject, html);
    }
}
