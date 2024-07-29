package com.uniquedeveloper.banking;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Properties;
import java.util.Random;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/send_otp")
public class send_otp extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user_email = request.getParameter("user_email");
        String input_otp = request.getParameter("input_otp");
        HttpSession session = request.getSession();
        RequestDispatcher dispatcher = null;

        if (user_email != null && input_otp == null) {
            // Generate OTP and hash it
            String otp = generateOTP();
            String fixedSalt = "$2a$10$eImiTXuWVxfM37uY4JANjQ";
            String hashedOtp = BCrypt.hashpw(otp, fixedSalt);

            session.setAttribute("hashed_otp", hashedOtp);
            session.setAttribute("user_email", user_email);

            Connection con = null;
            PreparedStatement pst = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");
                pst = con.prepareStatement("UPDATE user_details SET password = ? WHERE email = ?");
                pst.setString(1, hashedOtp);
                pst.setString(2, user_email);

                int rowcount = pst.executeUpdate();
                if (rowcount > 0) {
                    sendEmail(user_email, otp);
                    request.setAttribute("status", "OTP sent to your email.");
                    dispatcher = request.getRequestDispatcher("forgot_password.jsp");
                } else {
                    request.setAttribute("status", "Email not found.");
                    dispatcher = request.getRequestDispatcher("forgot_password.jsp");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("status", "An error occurred: " + e.getMessage());
                dispatcher = request.getRequestDispatcher("forgot_password.jsp");
            } finally {
                try {
                    if (pst != null) pst.close();
                    if (con != null) con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        } else if (input_otp != null) {
            String hashedOtp = (String) session.getAttribute("hashed_otp");
            if (BCrypt.checkpw(input_otp, hashedOtp)) {
                request.setAttribute("status", "OTP validated successfully. You can now reset your password.");
                response.sendRedirect("reset_new_pin.jsp");
                return; // Ensure no further processing is done
            } else {
                request.setAttribute("status", "Invalid OTP. Please try again.");
                dispatcher = request.getRequestDispatcher("forgot_password.jsp");
            }
        }

        if (dispatcher != null) {
            dispatcher.forward(request, response);
        }
    }

    private String generateOTP() {
        Random random = new Random();
        return String.format("%06d", random.nextInt(999999));
    }

    private void sendEmail(String email, String otp) {
        final String username = "kesavaprakash1610@gmail.com";
        final String password = "duyu mpdi lxuj myvk";
        final String smtpHost = "smtp.gmail.com";
        final String smtpPort = "587";

        Properties properties = new Properties();
        properties.put("mail.smtp.host", smtpHost);
        properties.put("mail.smtp.port", smtpPort);
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            message.setSubject("OTP to Change the Account Password");
            message.setText("Dear User,\n\nThe OTP is " + otp + ". Use this OTP to change the password.");

            Transport.send(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
