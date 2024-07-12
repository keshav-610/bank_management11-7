<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.IOException" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Delete a User Account</title>
<style>
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }
    table th, table td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: center;
    }
    table th {
        background-color: #f2f2f2;
        color: #333;
    }
</style>
</head>
<body>
    <h2>Delete a User Account</h2>
    <form action="" method="post">
        <label>Enter the account number</label>
        <input type="text" name="user_acc_no"/>
        <input type="submit" value="Get"/>
    </form>

    <%
    String user_acc_no = request.getParameter("user_acc_no");
    if (user_acc_no != null && !user_acc_no.isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");
            PreparedStatement pst = con.prepareStatement("SELECT * FROM user_details WHERE account_number = ?");
            pst.setString(1, user_acc_no);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                %>
                <table>
                    <tr>
                        <th>User ID</th>
                        <th>Name</th>
                        <th>Address</th>
                        <th>Phone Number</th>
                        <th>Email</th>
                        <th>Account Type</th>
                        <th>Date of Birth</th>
                        <th>Account Number</th>
                    </tr>
                    <tr>
                        <td><%= rs.getString("user_id") %></td>
                        <td><%= rs.getString("u_name") %></td>
                        <td><%= rs.getString("address") %></td>
                        <td><%= rs.getString("phone_number") %></td>
                        <td><%= rs.getString("email") %></td>
                        <td><%= rs.getString("account_type") %></td>
                        <td><%= rs.getDate("date_of_birth") %></td>
                        <td><%= rs.getString("account_number") %></td>
                    </tr>
                </table><br>
                <form action="admin_delete_user" method="post">
                    <input type="hidden" name="user_acc_no" value="<%= user_acc_no %>"/>
                    <input type="submit" value="Delete Account"/>
                </form>
                <%
            } else {
                out.println("<br>No account found with the provided account number.");
            }
            rs.close();
            pst.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error occurred: " + e.getMessage());
        }
    }
    %>
</body>
</html>
