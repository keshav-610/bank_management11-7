package com.uniquedeveloper.banking;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/reset_new_pin")
public class reset_new_pin extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String newPin = request.getParameter("new_pin");
        String confirmNewPin = request.getParameter("confirm_new_pin");
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("user_email");

        if (newPin != null && confirmNewPin != null && newPin.equals(confirmNewPin)) {
            String hashedPin = BCrypt.hashpw(newPin, BCrypt.gensalt(10));

            Connection con = null;
            PreparedStatement pst = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");

                String updateQuery = "UPDATE user_details SET account_password = ?, password = NULL WHERE email = ?";
                pst = con.prepareStatement(updateQuery);
                pst.setString(1, hashedPin);
                pst.setString(2, userEmail);

                int rowCount = pst.executeUpdate();
                if (rowCount > 0) {
                    response.sendRedirect("login.jsp");
                    return; 
                } else {
                    request.setAttribute("status", "Failed to reset password. Please try again.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("status", "An error occurred: " + e.getMessage());
            } finally {
                try {
                    if (pst != null) pst.close();
                    if (con != null) con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            RequestDispatcher dispatcher = request.getRequestDispatcher("reset_new_pin.jsp");
            dispatcher.forward(request, response);
        } else {
            request.setAttribute("status", "New PIN and Confirm PIN do not match.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("reset_new_pin.jsp");
            dispatcher.forward(request, response);
        }
    }
}
