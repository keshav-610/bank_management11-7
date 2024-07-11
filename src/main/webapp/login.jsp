<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login Page</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap">
<style>
body {
    background-color: #f0fff0;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
    height: 100vh;
    margin: 0;
    font-family: "Poppins", sans-serif;
}
h2 {
    text-align: center;
    font-weight: 700;
    font-size: 5vh;
    margin-bottom: 20px;
}
.container {
    background-color: rgb(192, 228, 228);
    border-radius: 10px;
    box-shadow: 0 10px 20px rgb(141, 143, 144);
    padding: 10px;
    margin: 10px;
    width: 400px;
}
label {
    font-weight: 400;
    font-size: 2.5vh;
    display: block;
    margin: 10px 0;
}
input[type="text"],
input[type="password"] {
    width: 100%;
    padding: 10px;
    margin-bottom: 20px;
    border: 1px solid #ccc;
    border-radius: 5px;
    font-size: 16px;
}
input[type="submit"] {
    width: 100%;
    background-color: #4CAF50;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 16px;
}
input[type="submit"]:hover {
    background-color: #45a049;
}
p.error-message {
    color: red;
    font-size: 14px;
    margin-top: 10px;
}
</style>
</head>
<body>
<input type="hidden" id="status" value="<%=request.getAttribute("status")%>"/>
<div class="container">
    <section>
        <h2>Get Account ID</h2>
        <form action="get_account" method="post">
            <label for="phone_number">Phone Number</label>
            <input type="text" id="phone_number" name="phone_number" required/>
            
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required/>
            
            <input type="submit" value="Get"/>
        </form>
        <%-- Display retrieved account details --%>
        <%
        String accountNumber = (String) request.getAttribute("account_number");
        String accountPassword = (String) request.getAttribute("account_password");
        if (accountNumber != null && accountPassword != null) {
            out.println("<p>Account Number: " + accountNumber + "</p>");
            out.println("<p>Account Password: " + accountPassword + "</p>");
        }
        %>
    </section>

    <section>
        <h2>Account Login</h2>
        <form action="login" method="post">
            <label for="account_number">Enter Account Number</label>
            <input type="text" id="account_number" name="account_number" placeholder="Enter your Account Number" required/>
            
            <label for="account_password">Enter your Account Password</label>
            <input type="password" id="account_password" name="account_password" placeholder="Enter your Account password" required/>
            
            <input type="submit" value="Login" name="signin"/>
        </form>
    </section>
</div>
</body>
</html>
