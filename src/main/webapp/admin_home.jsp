<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.IOException" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Date" %>
<%@ page import="javax.servlet.ServletException" %>
<%@ page import="javax.servlet.annotation.WebServlet" %>
<%@ page import="javax.servlet.http.HttpServlet" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Home</title>
<style>
 body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column; 
            align-items: center; 
            min-height: 100vh; 
        }
        
        .header {
            text-align: center;
            margin-bottom: 20px;
        }
        
        .container {
            background-color: #ffffff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); 
            width: 100%;
            margin-top: 20px;
        }
        
        .container form {
            display: flex;
            flex-direction: column;
        }
        
        .container label {
            margin-bottom: 10px;
        }
        
        .container input[type="text"],
        .container input[type="password"],
        .container input[type="email"],
        .container input[type="date"],
        .container select,
        .container input[type="submit"] {
            padding: 10px;
            margin-bottom: 15px; 
            border: 1px solid #ccc;
            border-radius: 5px;
            width: calc(100% - 22px); 
            font-family: "DM Sans", sans-serif;
            font-optical-sizing: auto;
            font-weight: 600;
            font-style: normal;
        }
        
        .container input[type="submit"] {
            background-color: rgb(0, 0, 0);
            color: #fff;
            border: none;
            cursor: pointer;
            font-weight: bold;
            transition: 0.2s ease;
            border: 2px solid white;
            font-size:15px;
            padding:10px;
            border-radius:5px;
        }
        
        .container input[type="submit"]:hover {
            background-color: white;
            border: 2px solid black;
            color: black;
            box-shadow: 0px 5px 0px 0px #000000;
        }
        
        .add_new_user, .edit_delete {
            margin-top: 20px;
        }
        
        .edit_delete button {
            margin-top: 10px;
        }
        
        .db-details {
            margin-top: 30px;
        }
        
        .db-details table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .db-details th, .db-details td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        .db-details th {
            background-color: #f2f2f2;
        }
        
        .edit-delete {
    		display: flex;
    		justify-content: space-around;
    		margin-top: 20px;
    		width:100%;
		}
		.editanddelete{
			background-color: rgb(0, 0, 0);
            color: #fff;
            border: none;
            cursor: pointer;
            font-weight: bold;
            transition: 0.2s ease;
            border: 2px solid white;
            font-size:15px;
            padding:10px;
            border-radius:5px;	
            text-decoration:none;
		}
		.editanddelete:hover{
			background-color: white;
            border: 2px solid black;
            color: black;
            box-shadow: 0px 5px 0px 0px #000000;
		}
</style>
</head>
<body>
<h2>Welcome Admin</h2>
<%
    String username = (String) session.getAttribute("username");
    if (username != null) {
        out.println("Welcome, " + username + "!");
    } else {
        out.println("Username not found in session.");
    }
%>
<hr>
<div class="add_new_user">
<div class="container">
<h2>Add new user</h2>
  <% String status = (String) request.getAttribute("status"); %>
    <% if (status != null) { %>
        <% if (status.equals("invalid_phone")) { %>
            <p style="color: red; text-align:center; font-weight:bold;">Invalid phone number. It should be 10 digits long.</p>
        <% } else if (status.equals("invalid_id_proof")) { %>
            <p style="color: red; text-align:center; font-weight:bold;">Invalid ID proof. It should be 12 characters long.</p>
        <% } else if (status.equals("invalid_age")) { %>
            <p style="color: red; text-align:center; font-weight:bold;">User must be at least 18 years old to create an account.</p>
        <% } else if (status.equals("initial_balance_error")) { %>
            <p style="color: red; text-align:center; font-weight:bold;">Initial balance must be greater than 1000.</p>
        <% } else if (status.equals("success")) { %>
            <p style="color: green; text-align:center; font-weight:bold;">User added successfully.</p>
        <% } else if (status.startsWith("exception")) { %>
            <p style="color: red; text-align:center; font-weight:bold;">An error occurred: <%= status.substring(10) %></p>
        <% } else { %>
            <p style="color: red; text-align:center; font-weight:bold;">Failed to add user. Please try again.</p>
        <% } %>
    <% } %>
    <form action="admin_add_new_user" method="post">
        <div>
            <label for="name">Name</label>
            <input type="text" id="name" name="name" placeholder="Enter your name" autocomplete="off" required/><br>
        </div>

        <div>
            <label for="address">Address</label>
            <input type="text" id="address" name="address" placeholder="Enter your address" autocomplete="off" required/><br>
        </div>

        <div>
            <label for="phone">Phone Number</label>
            <input type="text" id="phone" name="phone" placeholder="Enter your phone number" autocomplete="off" required/>
        </div>

        <div>
            <label for="email">E-mail</label>
            <input type="email" id="email" name="email" placeholder="Enter your email" autocomplete="off" required/>
        </div>

        <div>
            <label for="account_type">Account Type</label>
            <select id="account_type" name="account_type" required>
                <option value="current">Current</option>
                <option value="savings">Savings</option>
            </select>
        </div>

        <div>
            <label for="iamount">Initial Amount</label>
            <input type="text" id="iamount" name="iamount" placeholder="Enter your initial amount" autocomplete="off" required/>
        </div>

        <div>
            <label for="dob">Date of Birth</label>
            <input type="date" id="dob" name="dob" autocomplete="off" required/>
        </div>

        <div>
            <label for="id_proof">Id Proof</label>
            <input type="text" id="id_proof" name="id_proof" placeholder="Enter your AADHAR number" autocomplete="off" required/>
        </div>
        
        <input type="submit" value="Register"/>
    </form>
</div>

<div class="edit-delete">
    <div class="edit">
        <a href="admin_edit_customer.jsp" class="editanddelete">Edit User Details</a>
    </div>
    <div class="delete">
        <a href="admin_delete_customer.jsp" class="editanddelete">Delete an Account</a>
    </div>
</div>

<h2>List of Users</h2>
<div class="db-details">
<form method="post">
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
    <%
    try {
         Class.forName("com.mysql.cj.jdbc.Driver");
         Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");
         PreparedStatement pst = con.prepareStatement("SELECT user_id, u_name, address, phone_number, email, account_type, date_of_birth, account_number FROM user_details ORDER BY user_id ASC;");
         ResultSet rs = pst.executeQuery();
         
         while (rs.next()) {
             %>
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
             <% 
         }
         rs.close();
         pst.close();
         con.close();
         
    } catch(Exception e) {
        e.printStackTrace();
    }
    %>
</table>
</form>
</div>
</div>
</body>
</html>
