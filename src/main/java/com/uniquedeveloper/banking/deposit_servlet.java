package com.uniquedeveloper.banking;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/deposit_money")
public class deposit_servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long d_money = Long.parseLong(request.getParameter("d_money"));
        String account_password = request.getParameter("account_password");
        HttpSession session = request.getSession();
        String account_number = (String) session.getAttribute("account_number");
        String user_name = (String) session.getAttribute("u_name");
        
        if (d_money < 0) {
            request.setAttribute("depositErrorMessage", "Invalid Input: Deposit amount cannot be negative.");
            request.getRequestDispatcher("home.jsp").forward(request, response);
            return;
        }
        
        Connection con = null;
        PreparedStatement pst_u = null;
        PreparedStatement pst_t = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");

            pst_u = con.prepareStatement("SELECT account_password FROM user_details WHERE account_number = ?");
            pst_u.setString(1, account_number);
            rs = pst_u.executeQuery();

            if (rs.next()) {
                String dbHashedPassword = rs.getString("account_password");
                if (BCrypt.checkpw(account_password, dbHashedPassword)) {
                    // Update the balance
                    pst_u = con.prepareStatement(
                        "UPDATE user_details SET initial_balance = initial_balance + ? WHERE account_number = ?");
                    pst_u.setLong(1, d_money);
                    pst_u.setString(2, account_number);
                    
                    int rowsUpdated = pst_u.executeUpdate();
                    
                    if (rowsUpdated > 0) {
                        Timestamp currentTimestamp = new Timestamp(new Date().getTime());
                        pst_t = con.prepareStatement(
                            "INSERT INTO transactions (account_number, user_name, amount, transaction_type, status, receiver_phone_number, transaction_date) VALUES (?, ?, ?, ?, ?, ?, ?);"
                        );
                        pst_t.setString(1, account_number);
                        pst_t.setString(2, user_name);
                        pst_t.setLong(3, d_money);
                        pst_t.setString(4, "deposit");
                        pst_t.setString(5, "completed");
                        pst_t.setString(6, "");
                        pst_t.setTimestamp(7, currentTimestamp);
                        
                        int rowsInserted = pst_t.executeUpdate();
                        
                        if (rowsInserted > 0) {
                            response.sendRedirect("home.jsp");
                        } else {
                            request.setAttribute("depositErrorMessage", "Transaction failed.");
                            request.getRequestDispatcher("home.jsp").forward(request, response);
                        }
                    } else {
                        request.setAttribute("depositErrorMessage", "Failed to update balance.");
                        request.getRequestDispatcher("home.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("depositErrorMessage", "Invalid account password.");
                    request.getRequestDispatcher("home.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("depositErrorMessage", "Invalid account number.");
                request.getRequestDispatcher("home.jsp").forward(request, response);
            }
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database access error", e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pst_u != null) pst_u.close();
                if (pst_t != null) pst_t.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
