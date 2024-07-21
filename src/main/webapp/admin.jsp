<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login</title>
    <style>
        body {
			font-family: "DM Sans", sans-serif;
            font-optical-sizing: auto;
            font-weight: 600;
            font-style: normal;
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
            width: 300px; 
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
        .container input[type="submit"] {
        	font-family: "DM Sans", sans-serif;
            font-optical-sizing: auto;
            font-weight: 600;
            font-style: normal;
            padding: 10px;
            margin-bottom: 10px; 
            border: 1px solid #ccc;
            border-radius: 5px;
            width: calc(100% - 22px); 
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
            width:100%;
        }
        
        .container input[type="submit"]:hover {
            background-color: white;
            border: 2px solid black;
            color: black;
            box-shadow: 0px 5px 0px 0px #000000;
        }
        
        .error-message {
            color: red;
            margin-top: 10px; 
        }
    </style>
</head>
<body>
    <div class="header">
        <h2>Admin login</h2>
    </div>
    <div class="container">
        <form action="admin_login" method="post">
            <label>Username</label>
            <input type="text" name="admin_username" autocomplete="off"><br>
            <label>Password</label>
            <input type="password" name="admin_password" autocomplete="off"/><br><br>
            <input type="submit" value="Login"/>
        </form>
    </div>
    <% if (request.getAttribute("status") != null && request.getAttribute("status").equals("failed")) { %>
        <p class="error-message">Invalid username or password. Please try again.</p>
    <% } %>
</body>
</html>
