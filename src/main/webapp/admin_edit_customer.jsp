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
<title>Insert title here</title>
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
<h2>Edit an Account</h2>
<form method="post">
<label>Enter the account number</label>
<input type="text" name="user_acc_no"/>
<input type="submit" value="Get"/>
<%
String user_acc_no=(String) request.getParameter("user_acc_no");
try{
	Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");
    PreparedStatement pst=con.prepareStatement("SELECT * FROM user_details where account_number=?");
    pst.setString(1,user_acc_no);
    
    ResultSet rs=pst.executeQuery();
    while(rs.next()){
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
    	<td><%=rs.getString("user_id") %></td>
        	 <td><%=rs.getString("u_name") %></td>
        	 <td><%=rs.getString("address") %></td>
        	 <td><%=rs.getString("phone_number") %></td>
        	 <td><%=rs.getString("email") %></td>
        	 <td><%=rs.getString("account_type") %></td>
        	 <td><%=rs.getDate("date_of_birth") %></td>
        	 <td><%=rs.getString("account_number")%></td>
    	</tr>
    	</table><br>
    	<form action="admin_edit_user">
    	<label>Name</label>
    	<input type="text" name="new_name"/><br><br>
    	
    	<label>Address</label>
    	<input type="text" name="new_address"/><br><br>
    	
    	<label>Phone Number</label>
    	<input type="text" name="new_ph_no"><br><br>	
    	
    	<label>Email</label>
    	<input type="email" name="new_email"><br><br>	
    	
    	<label>Date of Birth</label>
    	<input type="date" name="new_dob"><br><br>	
    	
    	<input type="submit">
    	
    	
    	</form>
    	<% 
    }
    rs.close();
    pst.close();
    con.close();	
    }
catch(Exception e){
	e.printStackTrace();
}
%>
</form>
</body>
</html>