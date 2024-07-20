package com.uniquedeveloper.banking;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
        
        if(d_money<0) {
        	request.setAttribute("depositErrorMessage", "Invalid Input: Deposit amount cannot be negative.");
            request.getRequestDispatcher("home.jsp").forward(request, response);
            return;
        }
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");
            PreparedStatement pst_u = con.prepareStatement(
                    "UPDATE user_details SET initial_balance = initial_balance + ? WHERE account_password = ? AND account_number = ?");
            pst_u.setLong(1, d_money);
            pst_u.setString(2, account_password);
            pst_u.setString(3, account_number);
            
            int rowsupdated_s = pst_u.executeUpdate();
            
            if (rowsupdated_s > 0) {
                Timestamp currentTimestamp = new Timestamp(new Date().getTime());
                PreparedStatement pst_t = con.prepareStatement(
                    "INSERT INTO transactions (account_number, user_name, amount, transaction_type, status, receiver_phone_number, transaction_date) VALUES (?, ?, ?, ?, ?, ?, ?);"
                );
                pst_t.setString(1, account_number);
                pst_t.setString(2, user_name);
                pst_t.setLong(3, d_money);
                pst_t.setString(4, "deposit");
                pst_t.setString(5, "completed");
                pst_t.setString(6, "");
                pst_t.setTimestamp(7, currentTimestamp);
                
                int rowsinserted_t = pst_t.executeUpdate();
                
                if (rowsinserted_t > 0) {
                    response.sendRedirect("home.jsp");
                } else {
                    request.setAttribute("depositErrorMessage", "Transaction failed.");
                    request.getRequestDispatcher("home.jsp").forward(request, response);
                }
                pst_t.close();
            } else {
                request.setAttribute("depositErrorMessage", "Invalid account password.");
                request.getRequestDispatcher("home.jsp").forward(request, response);
            }
            
            pst_u.close();
            con.close();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database access error", e);
        }
    }
}
