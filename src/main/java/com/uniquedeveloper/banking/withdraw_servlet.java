package com.uniquedeveloper.banking;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root",
                    "keshav610");
            PreparedStatement pst = con.prepareStatement(
                    "UPDATE user_details SET initial_balance = initial_balance - ? WHERE account_password = ?");
            pst.setLong(1, w_money);
            pst.setString(2, account_password);

            int rowsUpdated = pst.executeUpdate();
            if (rowsUpdated > 0) {
                // Update successful
                response.sendRedirect("home.jsp");
            } else {
                // No rows updated, handle as per your application's logic
                request.setAttribute("status", "failed");
                request.getRequestDispatcher("home.jsp").forward(request, response);
            }

            pst.close();
            con.close();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database access error", e);
        }
	}

}