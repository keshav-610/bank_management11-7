<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login</title>
</head>
<body>
<h2>Admin login</h2>
<form action="admin_login" method="post">
    <label>Username</label>
    <input type="text" name="admin_username"><br><br>
    <label>Password</label>
    <input type="password" name="admin_password"/><br><br>
    <input type="submit" value="Login"/>
</form>
<%
    if (request.getAttribute("status") != null && request.getAttribute("status").equals("failed")) {
%>
    <p style="color:red;">Invalid username or password. Please try again.</p>
<%
    }
%>


</body>
</html>
