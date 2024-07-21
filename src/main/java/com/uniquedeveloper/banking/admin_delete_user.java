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

@WebServlet("/admin_delete_user")
public class admin_delete_user extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user_acc_no = request.getParameter("user_acc_no");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");

            PreparedStatement checkBalanceStmt = con.prepareStatement("SELECT initial_balance FROM user_details WHERE account_number = ?");
            checkBalanceStmt.setString(1, user_acc_no);
            ResultSet rs = checkBalanceStmt.executeQuery();

            if (rs.next()) {
                int balance = rs.getInt("initial_balance");

                if (balance == 0) {
                    PreparedStatement deleteTransactionsStmt = con.prepareStatement("DELETE FROM transactions WHERE account_number = ?");
                    deleteTransactionsStmt.setString(1, user_acc_no);
                    deleteTransactionsStmt.executeUpdate();
                    deleteTransactionsStmt.close();

                    PreparedStatement deleteStmt = con.prepareStatement("DELETE FROM user_details WHERE account_number = ?");
                    deleteStmt.setString(1, user_acc_no);
                    int rowsDeleted = deleteStmt.executeUpdate();
                    if (rowsDeleted > 0) {
                        response.sendRedirect("admin_home.jsp");
                    } else {
                        response.getWriter().write("Failed to delete user account.");
                    }
                    deleteStmt.close();
                } else {
                    response.getWriter().write("Cannot delete account. Please withdraw all money before deleting the account.");
                }
            } else {
                response.getWriter().write("Account not found.");
            }
            checkBalanceStmt.close();
            rs.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error occurred: " + e.getMessage());
        }
    }
}
