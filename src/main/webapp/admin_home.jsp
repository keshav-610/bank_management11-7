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
        }</style>
</head>
<body>
<h2>Welcome Admin</h2>
<%
    // Retrieve the username from the session
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
    <form action="admin_add_new_user" method="post">
        <div>
            <label for="name">Name</label>
            <input type="text" id="name" name="name" placeholder="Enter your name" required/><br><br>
        </div>

        <div>
            <label for="address">Address</label>
            <input type="text" id="address" name="address" placeholder="Enter your address" required/><br><br>
        </div>

        <div>
            <label for="phone">Phone Number</label>
            <input type="text" id="phone" name="phone" placeholder="Enter your phone number" required/>
        </div>

        <div>
            <label for="email">E-mail</label>
            <input type="email" id="email" name="email" placeholder="Enter your email" required/>
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
            <input type="text" id="iamount" name="iamount" placeholder="Enter your initial amount" required/>
        </div>

        <div>
            <label for="dob">Date of Birth</label>
            <input type="date" id="dob" name="dob" required/>
        </div>

        <div>
            <label for="id_proof">Id Proof</label>
            <input type="text" id="id_proof" name="id_proof" placeholder="Enter your AADHAR number" required/>
        </div>

        <div>
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Enter your password" required/>
        </div>

        <input type="submit" value="Register"/>
    </form>
</div>
<hr>

<div class="edit,delete">
<div class="edit">
<button><a href="admin_edit_customer.jsp">Edit user details</a></button>
</div>
<div>
<button><a href="admin_delete_customer.jsp">Delete an account</a></button>
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
	try{
		 Class.forName("com.mysql.cj.jdbc.Driver");
         Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");
         PreparedStatement pst=con.prepareStatement("SELECT user_id, u_name, address, phone_number, email,account_type, date_of_birth, account_number FROM user_details ORDER BY user_id ASC;");
         ResultSet rs=pst.executeQuery();
         
         while(rs.next()){
        	 %>
        	 <tr>
        	 <td><%=rs.getString("user_id") %></td>
        	 <td><%=rs.getString("u_name") %></td>
        	 <td><%=rs.getString("address") %></td>
        	 <td><%=rs.getString("phone_number") %></td>
        	 <td><%=rs.getString("email") %></td>
        	 <td><%=rs.getString("account_type") %></td>
        	 <td><%=rs.getDate("date_of_birth") %></td>
        	 <td><%=rs.getString("account_number")%></td>
        	 </tr>
        	 <% 
        	 
         }
         rs.close();
         pst.close();
         con.close();
	}catch(Exception e){
		e.printStackTrace();
	}
	%>
</table>
</form>
</div>

</body>
</html>
