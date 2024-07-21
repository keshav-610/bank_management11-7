package com.uniquedeveloper.banking;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class admin_add_new_user
 */
@WebServlet("/admin_add_new_user")
public class admin_add_new_user extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String u_name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone_number = request.getParameter("phone");
        String email = request.getParameter("email");
        String account_type = request.getParameter("account_type");
        double initial_balance = Double.parseDouble(request.getParameter("iamount"));
        String date_of_birth = request.getParameter("dob");
        String proof = request.getParameter("id_proof");
        String password = request.getParameter("password");

        RequestDispatcher dispatcher = null;

        if (phone_number.length() != 10) {
            request.setAttribute("status", "invalid_phone");
            dispatcher = request.getRequestDispatcher("admin_home.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (proof.length() != 12) {
            request.setAttribute("status", "invalid_id_proof");
            dispatcher = request.getRequestDispatcher("admin_home.jsp");
            dispatcher.forward(request, response);
            return;
        }

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date dob = sdf.parse(date_of_birth);
            if (!isAgeValid(dob)) {
                request.setAttribute("status", "invalid_age");
                dispatcher = request.getRequestDispatcher("admin_home.jsp");
                dispatcher.forward(request, response);
                return;
            }
        } catch (ParseException e) {
            e.printStackTrace();
            request.setAttribute("status", "invalid_date");
            dispatcher = request.getRequestDispatcher("admin_home.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (initial_balance <= 1000) {
            request.setAttribute("status", "initial_balance_error");
            dispatcher = request.getRequestDispatcher("admin_home.jsp");
            dispatcher.forward(request, response);
            return;
        }

        String account_number = generate_account_number();
        String account_password = generate_account_password();

        Connection con1 = null;
        PreparedStatement pst = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");

            String sql = "INSERT INTO user_details (u_name, address, phone_number, email, account_type, initial_balance, date_of_birth, proof, password, account_number, account_password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            pst = con1.prepareStatement(sql);

            pst.setString(1, u_name);
            pst.setString(2, address);
            pst.setString(3, phone_number);
            pst.setString(4, email);
            pst.setString(5, account_type);
            pst.setDouble(6, initial_balance);
            pst.setString(7, date_of_birth);
            pst.setString(8, proof);
            pst.setString(9, password);
            pst.setString(10, account_number);
            pst.setString(11, account_password);

            int rowcount = pst.executeUpdate();
            dispatcher = request.getRequestDispatcher("admin_home.jsp");
            if (rowcount > 0) {
                request.setAttribute("status", "success");
            } else {
                request.setAttribute("status", "failed");
            }
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("status", "exception: " + e.getMessage());
            dispatcher = request.getRequestDispatcher("admin_home.jsp");
            dispatcher.forward(request, response);
        } finally {
            if (pst != null) {
                try {
                    pst.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (con1 != null) {
                try {
                    con1.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private boolean isAgeValid(Date dob) {
        long ageInMillis = System.currentTimeMillis() - dob.getTime();
        Date age = new Date(ageInMillis);
        return age.getYear() - 70 >= 18; 
    }

    private String generate_account_number() {
        return "user" + new Random().nextInt(999999999);
    }

    private String generate_account_password() {
        return String.valueOf(new Random().nextInt(999999));
    }
}
