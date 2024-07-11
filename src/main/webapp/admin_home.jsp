<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Home</title>
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
</body>
</html>
