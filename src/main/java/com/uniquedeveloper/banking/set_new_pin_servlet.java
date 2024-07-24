package com.uniquedeveloper.banking;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/set_new_pin")
public class set_new_pin_servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accountNumber = request.getParameter("account_number");
        String tempPassword = request.getParameter("temp_password");
        String newPin = request.getParameter("pin_password");

        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");

            if (newPin != null && !newPin.isEmpty()) {
                String pinSalt = "$2a$10$eImiTXuWVxfM37uY4JANjQ";
                String hashedNewPin = BCrypt.hashpw(newPin, pinSalt);
                String sql = "UPDATE user_details SET account_password = ?, password = NULL WHERE account_number = ?";
                pst = con.prepareStatement(sql);
                pst.setString(1, hashedNewPin);
                pst.setString(2, accountNumber);
                int rowsUpdated = pst.executeUpdate();

                if (rowsUpdated > 0) {
                    request.setAttribute("message", "PIN updated successfully.");
                } else {
                    request.setAttribute("message", "Failed to update PIN. Please try again.");
                }
            } else if (tempPassword != null && !tempPassword.isEmpty() && accountNumber != null && !accountNumber.isEmpty()) {
                String sql = "SELECT password FROM user_details WHERE account_number = ?";
                pst = con.prepareStatement(sql);
                pst.setString(1, accountNumber);
                rs = pst.executeQuery();

                if (rs.next()) {
                    String dbPasswordHash = rs.getString("password");

                    if (BCrypt.checkpw(tempPassword, dbPasswordHash)) {
                        request.setAttribute("showNewPinForm", "block");
                        request.setAttribute("accountNumber", accountNumber);
                        request.setAttribute("message", "Temporary password is valid. Please enter a new PIN.");
                    } else {
                        request.setAttribute("message", "Invalid temporary password.");
                    }
                } else {
                    request.setAttribute("message", "Invalid account number.");
                }
            }
            
            request.getRequestDispatcher("set_new_pin.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("set_new_pin.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
