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

import org.mindrot.jbcrypt.BCrypt;

/**
 * Servlet implementation class get_account_details
 */
@WebServlet("/get_account")
public class get_account_details extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String phoneNumber = request.getParameter("phone_number");
        String password = request.getParameter("password");
        RequestDispatcher dispatcher = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");
            PreparedStatement pst = con.prepareStatement("SELECT account_number, account_password, password FROM user_details WHERE phone_number = ?");

            pst.setString(1, phoneNumber);

            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                String account_number = rs.getString("account_number");
                String account_password = rs.getString("account_password");
                String hashedPassword = rs.getString("password");

                if (BCrypt.checkpw(password, hashedPassword)) {
                    request.setAttribute("account_number", account_number);
                    request.setAttribute("account_password", account_password);
                    request.setAttribute("status", "success");
                } else {
                    request.setAttribute("status", "failed");
                }

                dispatcher = request.getRequestDispatcher("login.jsp");
            } else {
                request.setAttribute("status", "failed");
                dispatcher = request.getRequestDispatcher("login.jsp");
            }
            dispatcher.forward(request, response);

            rs.close();
            pst.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Database access error", e);
        }
    }
}
