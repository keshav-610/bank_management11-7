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
 * Servlet implementation class withdraw_servlet
 */
@WebServlet("/withdraw_money")
public class withdraw_servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        long w_money = Long.parseLong(request.getParameter("w_money"));
        String account_password = request.getParameter("account_password");
        HttpSession session = request.getSession();
        
        String account_number = (String) session.getAttribute("account_number");
        String user_name = (String) session.getAttribute("u_name");

        Connection con = null;
        PreparedStatement pst_check_balance = null;
        PreparedStatement pst_u = null;
        PreparedStatement pst_t = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");

            pst_check_balance = con.prepareStatement("SELECT initial_balance, account_password FROM user_details WHERE account_number = ?");
            pst_check_balance.setString(1, account_number);
            rs = pst_check_balance.executeQuery();
            
            if (rs.next()) {
                String dbHashedPassword = rs.getString("account_password");
                double current_balance = rs.getDouble("initial_balance");

                if (BCrypt.checkpw(account_password, dbHashedPassword)) {
                    if (current_balance < w_money) {
                        response.sendRedirect("home.jsp?error=Insufficient%20balance");
                        return;
                    }

                    pst_u = con.prepareStatement("UPDATE user_details SET initial_balance = initial_balance - ? WHERE account_number = ?");
                    pst_u.setLong(1, w_money);
                    pst_u.setString(2, account_number);

                    Timestamp currentTimestamp = new Timestamp(new Date().getTime());
                    pst_t = con.prepareStatement("INSERT INTO transactions (account_number, user_name, amount, transaction_type, status, receiver_phone_number, transaction_date) VALUES (?, ?, ?, ?, ?, ?, ?)");
                    pst_t.setString(1, account_number);
                    pst_t.setString(2, user_name);
                    pst_t.setLong(3, w_money);
                    pst_t.setString(4, "withdraw");
                    pst_t.setString(5, "completed");
                    pst_t.setString(6, "");
                    pst_t.setTimestamp(7, currentTimestamp);

                    int rowsUpdated = pst_u.executeUpdate();
                    int rowsInserted = pst_t.executeUpdate();

                    if (rowsUpdated > 0 && rowsInserted > 0) {
                        response.sendRedirect("home.jsp");
                    } else {
                        response.sendRedirect("home.jsp?error=Transaction%20failed");
                    }
                } else {
                    response.sendRedirect("home.jsp?error=Invalid%20password");
                }
            } else {
                response.sendRedirect("home.jsp?error=Invalid%20account%20number");
            }
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp?error=Database%20error");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pst_check_balance != null) pst_check_balance.close();
                if (pst_u != null) pst_u.close();
                if (pst_t != null) pst_t.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
