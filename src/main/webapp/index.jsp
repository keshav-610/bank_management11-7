<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Central Bank of India</title>
</head>
<style>
body{
        background-color: rgb(191, 232, 219);
    }
    h2{
        text-align: center;
        font-family:system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
    }
    button{
        background-color: black;
        border: 0 solid transparent;
        width: 150px;
        height: 50px;
        border-radius: 10px;
        margin: 20px;
    }
    a{
        text-decoration: none;
        color: aliceblue;
        font-size: 15px;
    }
    .container{
        display: flex;
        justify-content: center;
        align-items: center;
        height: 80vh;
        flex-direction: column;
    }
    button:hover{
        text-align: center;
        background-color: rgb(48, 46, 46);
    }

    
</style>
<body>
<h2>Welcome to Central Bank of India</h2>
<div class="container">
    <button><a href="customer.jsp" style="margin-right:10px;">Customer</a></button>
    <button><a href="admin.jsp">Admin</a></button>
</div>
</body>
</html>
