<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <title>CBI - Dashboard</title>
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
            align-items: center;
        }
        .side-header {
            display: flex;
            justify-content: space-evenly;
            align-items: center; 
            height: auto;
        }
        .logout-button {
            background-color: red;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            text-decoration: none; 
            display: inline-block; 
            margin-left:20px;
        }
        .logout-button:hover {
            background-color: darkred; 
        }
        .balance-section, .deposit-section, .withdraw-section, .transaction-section, .transaction-history {
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
            display: flex;
            flex-direction: column;
            align-items: center;
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
            background-color: #000000;
            color: white;
            border: none;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color:  #6f7470;
        }
        .error-message {
            color: red;
            text-align:center;
        }
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
        .form-container {
            display: flex;
            justify-content: space-between;
        }
        .form {
            width: 48%;
        }
        button{
        	width:300px;
        	padding:10px;
        	background-color: #000000;
            color: white;
            border-radius:5px;
            border: none;
            cursor: pointer;
        }
        .transaction-history{
        	display:flex;
        	align-items:center;
        	justify-content:center;
        	flex-direction:column;
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.4.0/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.13/jspdf.plugin.autotable.min.js"></script>
    <script>
        function generatePDF() {
            var { jsPDF } = window.jspdf;
            var doc = new jsPDF();

            var userName = "<%= session.getAttribute("u_name") %>";
            var columns = ["Transaction ID", "Transaction Amount", "Transaction Type", "Status", "Receiver's Phone Number", "Transaction Date"];
            var rows = [];

            <% 
                String user_name = (String) session.getAttribute("u_name");
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");
                    PreparedStatement pst = con.prepareStatement("SELECT transaction_id, user_name, amount, transaction_type, status, receiver_phone_number, transaction_date FROM transactions WHERE user_name=?");
                    pst.setString(1, user_name);
                    
                    ResultSet rs = pst.executeQuery();
                    
                    while (rs.next()) {
            %>
            rows.push(["<%= rs.getString("transaction_id") %>", "<%= rs.getLong("amount") %>", "<%= rs.getString("transaction_type") %>", "<%= rs.getString("status") %>", "<%= rs.getString("receiver_phone_number") %>", "<%= rs.getTimestamp("transaction_date") %>"]);
            <% 
                    }
                    
                    rs.close();
                    pst.close();
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>

            doc.text("Account Holder: " + userName, 14, 16);
            doc.autoTable({
                head: [columns],
                body: rows,
                startY: 20,
            });

            doc.save(userName +" Transaction_History.pdf");
        }

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
            String username = (String) session.getAttribute("u_name");
            if (username != null) {
                out.println("<h2>Welcome, " + username + "</h2>");
            } else {
                out.println("Username not found");
            }
        %>
        <div class="side-header">
            <p>Time: <span id="current-time"></span></p>
            <a class="logout-button" href="logout">Logout</a>
        </div>
    </div>
    
    <div class="form-container">
        <div class="form balance-section">
            <h2>Balance Check</h2>
            <form action="balance" method="post">
                <label>Check your Balance</label>
                <input type="password" placeholder="Enter your Account Password" name="account_password"/>
                <input type="submit" value="View Balance"/>
            </form>
            <%
                String initial_balance = (String) request.getAttribute("initial_balance");
            	String status=(String) request.getAttribute("status");
            	if ("success".equals(status)) {
                    out.println("<p style='text-align:center;font-size:20px;font-weight:bold;'>Your balance is ₹" + initial_balance + "</p>");
                } else if ("failed".equals(status)) {
                    out.println("<p style='text-align:center;color:red;font-size:20px;font-weight:bold;'>Invalid password, please try again.</p>");
                }
            %>
        </div>
        
        <div class="form deposit-section">
            <h2>Deposit Money</h2>
            <form action="deposit_money" method="post">
                <label>Enter the amount you want to deposit</label><br/>
                <input type="text" name="d_money"/><br/><br/>
                <label>Enter your Account Password</label><br/>
                <input type="password" name="account_password"/><br/><br/>
                <input type="submit" value="Deposit"/>
            </form>
            <% 
                String depositErrorMessage = (String) request.getAttribute("depositErrorMessage");
                if (depositErrorMessage != null) {
            %>
            <p class="error-message"><%= depositErrorMessage %></p>
            <% } %>
        </div>
    </div>

    <div class="form-container">
        <div class="form withdraw-section">
            <h2>Withdraw Money</h2>
            <form action ="withdraw_money" method="post">
                <label>Enter the amount you want to withdraw</label><br/>
                <input type="text" name="w_money"/><br/><br/>
                <label>Enter your Account Password</label><br/>
                <input type="password" name="account_password"/><br/><br/>
                <input type="submit" value="Withdraw"/>
            </form>
        </div>
        
        <div class="form transaction-section">
            <h2>Transaction</h2>
            <form action="transaction" method="post">
                <label>Enter Receiver's Phone Number</label><br/>
                <input type="text" name="receiver_phone_number"/><br/><br/>
                <label>Enter the Amount</label><br/>
                <input type="text" name="t_money"/><br/><br/>
                <label>Enter your Account Password</label><br/>
                <input type="password" name="account_password"/><br/><br/>
                <input type="submit" value="Send"/>
            </form>
        </div>
    </div>
    
    <div class="transaction-history">
        <h2>Transaction History</h2>
        <table>
            <thead>
                <tr>
                    <th>Transaction ID</th>
                    <th>Transaction Amount</th>
                    <th>Transaction Type</th>
                    <th>Status</th>
                    <th>Receiver's Phone Number</th>
                    <th>Transaction Date</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");
                        PreparedStatement pst = con.prepareStatement("SELECT transaction_id, user_name, amount, transaction_type, status, receiver_phone_number, transaction_date FROM transactions WHERE user_name=?");
                        pst.setString(1, user_name);
                        ResultSet rs = pst.executeQuery();
                        
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("transaction_id") %></td>
                    <td><%= rs.getLong("amount") %></td>
                    <td><%= rs.getString("transaction_type") %></td>
                    <td><%= rs.getString("status") %></td>
                    <td><%= rs.getString("receiver_phone_number") %></td>
                    <td><%= rs.getTimestamp("transaction_date") %></td>
                </tr>
                <%
                        }
                        
                        rs.close();
                        pst.close();
                        con.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </tbody>
        </table><br>
        <button onclick="generatePDF()">Generate PDF</button>
    </div>
    
    
</body>
</html>
