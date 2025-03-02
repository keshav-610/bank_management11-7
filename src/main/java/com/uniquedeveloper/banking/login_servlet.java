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
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/login")
public class login_servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String account_password = request.getParameter("account_password");
        HttpSession session = request.getSession();
        RequestDispatcher dispatcher = null;

        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");

            pst = con.prepareStatement("SELECT * FROM user_details WHERE email = ?");
            pst.setString(1, email);

            rs = pst.executeQuery();

            if (rs.next()) {
                String storedHashedPassword = rs.getString("account_password");

                if (BCrypt.checkpw(account_password, storedHashedPassword)) {
                    session.setAttribute("u_name", rs.getString("u_name"));
                    session.setAttribute("account_number", rs.getString("account_number")); 
                    dispatcher = request.getRequestDispatcher("home.jsp");
                    dispatcher.forward(request, response);
                } else {
                    request.setAttribute("loginError", "Invalid email or password");
                    dispatcher = request.getRequestDispatcher("login.jsp");
                    dispatcher.forward(request, response);
                }
            } else {
                request.setAttribute("loginError", "Invalid email or password");
                dispatcher = request.getRequestDispatcher("login.jsp");
                dispatcher.forward(request, response);
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database access error", e);
        } finally {
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

