package com.uniquedeveloper.banking;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String account_number = request.getParameter("account_number");
        String new_password = request.getParameter("newPassword");
        String confirm_password = request.getParameter("confirmPassword");

        if (new_password.equals(confirm_password)) {
            String jdbcURL = "jdbc:mysql://localhost:3306/bank_management";
            String dbUser = "root";
            String dbPassword = "keshav610";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

                String sql = "UPDATE user_details SET account_password = ? WHERE account_number = ?";
                PreparedStatement statement = connection.prepareStatement(sql);
                statement.setString(1, new_password);
                statement.setString(2, account_number);

                int rowsUpdated = statement.executeUpdate();
                if (rowsUpdated > 0) {
                    response.sendRedirect("login.jsp"); 
                } else {
                    response.getWriter().println("User not found.");
                }

                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().println("Database error: " + e.getMessage());
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                response.getWriter().println("Driver not found: " + e.getMessage());
            }
        } else {
            response.getWriter().println("Passwords do not match.");
        }
    }
}
