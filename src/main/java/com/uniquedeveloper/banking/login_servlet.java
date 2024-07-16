package com.uniquedeveloper.banking;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class login_servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String account_number = request.getParameter("account_number");
        String account_password = request.getParameter("account_password");
        HttpSession session = request.getSession();
        RequestDispatcher dispatcher = null;

        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish database connection
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");

            // Prepare SQL statement to fetch user details
            pst = con.prepareStatement("SELECT * FROM user_details WHERE account_number = ? AND account_password = ?");
            pst.setString(1, account_number);
            pst.setString(2, account_password);

            // Execute the query
            rs = pst.executeQuery();

            if (rs.next()) {
                // If user exists, set session attributes for user details
                session.setAttribute("u_name", rs.getString("u_name"));
                session.setAttribute("account_number", rs.getString("account_number"));
                dispatcher = request.getRequestDispatcher("home.jsp");
                dispatcher.forward(request, response); // Forward to home.jsp
            } else {
                // If user doesn't exist, set an attribute for login failure status
                request.setAttribute("loginError", "Invalid account number or password");
                dispatcher = request.getRequestDispatcher("login.jsp");
                dispatcher.forward(request, response); // Forward back to login.jsp with error message
            }

        } catch (ClassNotFoundException | SQLException e) {
            // Handle exceptions
            e.printStackTrace();
            throw new ServletException("Database access error", e);

        } finally {
            // Close JDBC objects in finally block to ensure they are closed even if an exception occurs
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
