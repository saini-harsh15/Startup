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
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");

            helper.setTo(teamEmail);
            helper.setFrom(FROM_EMAIL);          // Verified sender
            helper.setReplyTo(senderEmail);      // Reply goes to user
            helper.setSubject("New Contact Form Submission – " + senderName);
            helper.setText(htmlBody, true);

            mailSender.send(mimeMessage);
        }
    }
}
