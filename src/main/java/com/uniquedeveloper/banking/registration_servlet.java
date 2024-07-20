package com.uniquedeveloper.banking;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Random;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/register")
public class registration_servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String u_name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone_number = request.getParameter("phone");
        String email = request.getParameter("email");
        String account_type = request.getParameter("account_type");
        double initial_balance = 0.0;
        String date_of_birth = request.getParameter("dob");
        String proof = request.getParameter("id_proof");
        String password = request.getParameter("password");
        
        String account_number = generateAccountNumber();
        String account_password = generateAccountPassword();

        RequestDispatcher dispatcher = null;
        Connection con1 = null;
        PreparedStatement pst = null;

        try {
            initial_balance = Double.parseDouble(request.getParameter("iamount"));
            if (initial_balance < 1000) {
                request.setAttribute("status", "invalid_input");
                request.setAttribute("message", "Initial Amount must be greater than ₹ 1000");
                dispatcher = request.getRequestDispatcher("customer.jsp");
                dispatcher.forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("status", "invalid_input");
            request.setAttribute("message", "Initial amount must be a valid number.");
            dispatcher = request.getRequestDispatcher("customer.jsp");
            dispatcher.forward(request, response);
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");

            String sql = "INSERT INTO user_details (u_name, address, phone_number, email, account_type, initial_balance, date_of_birth, proof, password, account_number, account_password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            pst = con1.prepareStatement(sql);

            pst.setString(1, u_name);
            pst.setString(2, address);
            pst.setString(3, phone_number);
            pst.setString(4, email);
            pst.setString(5, account_type);
            pst.setDouble(6, initial_balance);
            pst.setString(7, date_of_birth);
            pst.setString(8, proof);
            pst.setString(9, password); // This password is already hashed
            pst.setString(10, account_number);
            pst.setString(11, account_password);

            int rowcount = pst.executeUpdate();
            dispatcher = request.getRequestDispatcher("login.jsp");
            if (rowcount > 0) {
                request.setAttribute("status", "success");
            } else {
                request.setAttribute("status", "failed");
            }
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("status", "exception: " + e.getMessage());
            dispatcher = request.getRequestDispatcher("customer.jsp");
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

    private String generateAccountNumber() {
        return "user" + new Random().nextInt(999999999);
    }

    private String generateAccountPassword() {
        return String.valueOf(new Random().nextInt(999999));
    }
}
