<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    }
    .header {
        display: flex;
        justify-content: space-between;
        background-color: #ffffff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        text-align: center;
        margin-top: 50px;
    }
    .side-header {
        display: flex;
        justify-content: space-evenly;
        align-items: center;
    }
    .logout-button {
        margin: 10px;
        padding: 10px 20px;
        background-color: #f44336;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }
    .logout-button:hover {
        background-color: #cc0000;
    }
    .balance-section, .deposit-section, .withdraw-section,. transaction-section {
        margin-top: 20px;
        padding: 20px;
        background-color: #ffffff;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    .balance-section h2, .deposit-section h2, .withdraw-section h2 {
        margin-bottom: 15px;
    }
    form {
        margin-top: 15px;
    }
    label {
        font-weight: bold;
        margin-bottom: 5px;
        display: block;
    }
    input[type="text"], input[type="password"], input[type="submit"] {
        padding: 10px;
        margin-bottom: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        width: 300px;
    }
    input[type="submit"] {
        background-color: #4CAF50;
        color: white;
        border: none;
        cursor: pointer;
    }
    input[type="submit"]:hover {
        background-color: #45a049;
    }
    .error-message {
        color: red;
    }
</style>
<script>
    function updateTime() {
        var now = new Date();
        var formattedTime = now.getFullYear() + '-' + 
                            ('0' + (now.getMonth() + 1)).slice(-2) + '-' + 
                            ('0' + now.getDate()).slice(-2) + ' ' + 
                            ('0' + now.getHours()).slice(-2) + ':' + 
                            ('0' + now.getMinutes()).slice(-2) + ':' + 
                            ('0' + now.getSeconds()).slice(-2);
        document.getElementById('current-time').innerText = formattedTime;
    }

    setInterval(updateTime, 1000);
</script>
</head>
<body onload="updateTime()">
<div class="header">
<% 
    String username = (String) session.getAttribute("name");
    if (username != null) {
        out.println("<h2>Welcome, " + username + "</h2>");
    } else {
        out.println("username not found");
    }
%>
<div class="side-header">
<p>Time: <span id="current-time"></span></p>
<button class="logout-button">Logout</button>
</div>
</div>
<div class="balance-section">
    <h2>Balance Check</h2>
    <form action="balance" method="post">
        <label>Check your Balance</label>
        <input type="password" placeholder="Enter your Account Password" name="account_password"/>
        <input type="submit" value="View Balance"/>
    </form>
    <% 
    String initial_balance = (String) request.getAttribute("initial_balance");
    if (initial_balance != null) {
        out.println("<p>Your balance is ₹" + initial_balance + "</p>");
    }
    %>
</div>
<hr>
<div class="deposit-section">
    <h2>Deposit Money</h2>
    <form action="deposit_money" method="post">
        <label>Enter the amount you want to deposit</label><br/>
        <input type="text" name="d_money"/><br/><br/>
        <label>Enter your Account Password</label><br/>
        <input type="password" name="account_password"/><br/><br/>
        <input type="submit" value="Deposit"/>
    </form>
</div>
<hr/>
<div class="withdraw-section">
    <h2>Withdraw Money</h2>
    <form action="withdraw_money" method="post">
        <label>Enter the amount you want to withdraw</label><br/>
        <input type="text" name="w_money"/><br/><br/>
        <label>Enter your Account Password</label><br/>
        <input type="password" name="account_password"/><br/><br/>
        <input type="submit" value="Withdraw"/>
    </form>
</div>
<hr/>
<div class="transaction-section">
<h2>Transaction</h2>
<form action="transaction" method="post">
    <label>Enter Receiver's Phone Number</label><br/>
    <input type="text" name="receiver_phone_number"/><br/><br/>
    <label>Enter Amount</label><br/>
    <input type="text" name="t_amount"/><br/><br/>
    <label>Enter Your Account Password</label><br/>
    <input type="password" name="account_password"/><br/><br/>
    <input type="submit" value="Make Transaction"/>
</form>

</div>


</body>
</html>
