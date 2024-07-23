package com.uniquedeveloper.banking;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/balance")
public class balance_check extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String account_password = request.getParameter("account_password");
        HttpSession session = request.getSession();
        RequestDispatcher dispatcher = null;

        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");
            pst = con.prepareStatement("SELECT initial_balance, account_password FROM user_details WHERE account_number = ?");
            pst.setString(1, (String) session.getAttribute("account_number"));

            rs = pst.executeQuery();
            if (rs.next()) {
                String dbHashedPassword = rs.getString("account_password");            
                if (BCrypt.checkpw(account_password, dbHashedPassword)) {
                    String initial_balance = rs.getString("initial_balance");
                    request.setAttribute("initial_balance", initial_balance);
                    request.setAttribute("status", "success");
                } else {
                    request.setAttribute("status", "failed");
                }
                dispatcher = request.getRequestDispatcher("home.jsp");
            } else {
                request.setAttribute("status", "failed");
                dispatcher = request.getRequestDispatcher("home.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Database access error", e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        dispatcher.forward(request, response);
    }
}
