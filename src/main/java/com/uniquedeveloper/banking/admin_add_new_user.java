package com.uniquedeveloper.banking;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;
import java.util.Random;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/admin_add_new_user")
public class admin_add_new_user extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String u_name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone_number = request.getParameter("phone");
        String email = request.getParameter("email");
        String account_type = request.getParameter("account_type");
        double initial_balance = Double.parseDouble(request.getParameter("iamount"));
        String date_of_birth = request.getParameter("dob");
        String proof = request.getParameter("id_proof");

        RequestDispatcher dispatcher = null;

        if (phone_number.length() != 10) {
            request.setAttribute("status", "invalid_phone");
            dispatcher = request.getRequestDispatcher("admin_home.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (proof.length() != 12) {
            request.setAttribute("status", "invalid_id_proof");
            dispatcher = request.getRequestDispatcher("admin_home.jsp");
            dispatcher.forward(request, response);
            return;
        }

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date dob = sdf.parse(date_of_birth);
            if (!isAgeValid(dob)) {
                request.setAttribute("status", "invalid_age");
                dispatcher = request.getRequestDispatcher("admin_home.jsp");
                dispatcher.forward(request, response);
                return;
            }
        } catch (ParseException e) {
            e.printStackTrace();
            request.setAttribute("status", "invalid_date");
            dispatcher = request.getRequestDispatcher("admin_home.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (initial_balance <= 1000) {
            request.setAttribute("status", "initial_balance_error");
            dispatcher = request.getRequestDispatcher("admin_home.jsp");
            dispatcher.forward(request, response);
            return;
        }

        String account_number = generate_account_number();
        String temporary_password = generate_account_password();

        String fixedSalt = "$2a$10$eImiTXuWVxfM37uY4JANjQ";
        String hashed_password = BCrypt.hashpw(temporary_password, fixedSalt);

        Connection con1 = null;
        PreparedStatement pst = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");

            String sql = "INSERT INTO user_details (u_name, address, phone_number, email, account_type, initial_balance, date_of_birth, proof, password, account_number) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            pst = con1.prepareStatement(sql);

            pst.setString(1, u_name);
            pst.setString(2, address);
            pst.setString(3, phone_number);
            pst.setString(4, email);
            pst.setString(5, account_type);
            pst.setDouble(6, initial_balance);
            pst.setString(7, date_of_birth);
            pst.setString(8, proof);
            pst.setString(9, hashed_password);
            pst.setString(10, account_number);

            int rowcount = pst.executeUpdate();
            dispatcher = request.getRequestDispatcher("admin_home.jsp");
            if (rowcount > 0) {
                request.setAttribute("status", "success");

                sendEmail(email, account_number, temporary_password);
            } else {
                request.setAttribute("status", "failed");
            }
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("status", "exception: " + e.getMessage());
            dispatcher = request.getRequestDispatcher("admin_home.jsp");
            dispatcher.forward(request, response);
        } finally {
            if (pst != null) {
                try {
                    pst.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (con1 != null) {
                try {
                    con1.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private boolean isAgeValid(Date dob) {
        long ageInMillis = System.currentTimeMillis() - dob.getTime();
        Date age = new Date(ageInMillis);
        return age.getYear() - 70 >= 18;
    }

    private String generate_account_number() {
        return "user" + new Random().nextInt(999999999);
    }

    private String generate_account_password() {
        return String.valueOf(new Random().nextInt(999999));
    }

    private void sendEmail(String toAddress, String accountNumber, String accountPassword) {
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
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toAddress));
            message.setSubject("Your Account Details");
            message.setText("Dear User,\n\n" +
                            "Your account has been successfully registered.\n\n" +
                            "Account Number: " + accountNumber + "\n" +
                            "Temporary Password: " + accountPassword + "\n\n" +
                            "Please don't enter your temporary password for login purpose."+"\n"+
                            "Please activate your account by setting new pin,\n\n" +
                            "Best Regards,\nBank Management");

            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
