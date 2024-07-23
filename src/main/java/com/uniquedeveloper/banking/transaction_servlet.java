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

/**
 * Servlet implementation class transaction_servlet
 */
@WebServlet("/transaction")
public class transaction_servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String t_money_str = request.getParameter("t_money"); 
        String ph_no = request.getParameter("receiver_phone_number");
        String account_password = request.getParameter("account_password");
        
        if (t_money_str == null || t_money_str.isEmpty() || ph_no == null || ph_no.isEmpty() || account_password == null || account_password.isEmpty()) {
            request.setAttribute("status", "missing_parameters");
            request.getRequestDispatcher("home.jsp").forward(request, response);
            return;
        }
        
        long t_money;
        try {
            t_money = Long.parseLong(t_money_str);
        } catch (NumberFormatException e) {
            request.setAttribute("status", "invalid_amount");
            request.getRequestDispatcher("home.jsp").forward(request, response);
            return;
        }
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("u_name");
        String account_number = (String) session.getAttribute("account_number");

        Connection con = null;
        PreparedStatement pst_check_password = null;
        PreparedStatement pst_s = null;
        PreparedStatement pst_r = null;
        PreparedStatement pst_t = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");
            
            pst_check_password = con.prepareStatement("SELECT account_password FROM user_details WHERE account_number = ?");
            pst_check_password.setString(1, account_number);
            rs = pst_check_password.executeQuery();
            
            if (rs.next()) {
                String dbHashedPassword = rs.getString("account_password");
   
                if (BCrypt.checkpw(account_password, dbHashedPassword)) {
                    pst_s = con.prepareStatement("UPDATE user_details SET initial_balance = initial_balance - ? WHERE account_number = ?");
                    pst_s.setLong(1, t_money);
                    pst_s.setString(2, account_number);

                    pst_r = con.prepareStatement("UPDATE user_details SET initial_balance = initial_balance + ? WHERE phone_number = ?");
                    pst_r.setLong(1, t_money);
                    pst_r.setString(2, ph_no);
                    
                    Timestamp currentTimestamp = new Timestamp(new Date().getTime());

                    pst_t = con.prepareStatement("INSERT INTO transactions (account_number, user_name, amount, transaction_type, status, receiver_phone_number, transaction_date) VALUES (?, ?, ?, ?, ?, ?, ?)");
                    pst_t.setString(1, account_number);
                    pst_t.setString(2, username);
                    pst_t.setLong(3, t_money);
                    pst_t.setString(4, "transaction");
                    pst_t.setString(5, "completed");
                    pst_t.setString(6, ph_no);
                    pst_t.setTimestamp(7, currentTimestamp);
                    
                    int rowsUpdatedSender = pst_s.executeUpdate();
                    int rowsUpdatedReceiver = pst_r.executeUpdate();
                    int rowsInsertedTransaction = pst_t.executeUpdate();

                    if (rowsUpdatedSender > 0 && rowsUpdatedReceiver > 0 && rowsInsertedTransaction > 0) {
                        response.sendRedirect("home.jsp");
                    } else {
                        request.setAttribute("status", "transaction_failed");
                        request.getRequestDispatcher("home.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("status", "invalid_password");
                    request.getRequestDispatcher("home.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("status", "account_not_found");
                request.getRequestDispatcher("home.jsp").forward(request, response);
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp?error=Database%20error");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pst_check_password != null) pst_check_password.close();
                if (pst_s != null) pst_s.close();
                if (pst_r != null) pst_r.close();
                if (pst_t != null) pst_t.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
