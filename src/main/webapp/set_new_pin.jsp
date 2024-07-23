<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Set New Pin</title>
    <link rel="icon" type="image/x-icon" href="img/logo.png"/>

    <style>
        @import url("https://fonts.googleapis.com/css2?family=DM+Sans:ital,opsz,wght@0,9..40,100..1000;1,9..40,100..1000&display=swap");
        body {
            margin: 0;
            padding: 0;
            font-family: "DM Sans", sans-serif;
            font-optical-sizing: auto;
            font-weight: 500;
            font-style: normal;
            background-color: #f0f0f0;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }
        .navbar {
            width: 100%;
            background-color: #fff;
            padding: 10px 0;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-evenly;
            margin-bottom: 20px;
        }

        .navbar h2 {
            margin: 0 20px;
        }

        .navbar h2 a {
            color: rgb(176, 186, 181);
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .navbar h2 a:hover {
            color: rgb(13, 130, 234);
        }

        .container {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            background-color: #fff;
            padding: 20px 40px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 400px;
            margin: 0 auto;
        }

        .container h2 {
            text-align: center;
            color: black;
            margin-bottom: 20px;
        }

        .container form {
            display: flex;
            flex-direction: column;
        }

        .container label {
            margin-bottom: 5px;
            font-weight: bold;
        }

        .container input[type="text"],
        .container input[type="password"] {
            padding: 10px;
            border-radius: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
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
            font-size: 15px;
            padding: 10px;
            border-radius: 5px;
        }

        .container input[type="submit"]:hover {
            background-color: white;
            border: 2px solid black;
            color: black;
            box-shadow: 0px 5px 0px 0px #000000;
        }

        .container p {
            font-weight: bold;
            text-align: center;
        }

        .container .error {
            color: red;
            font-weight: bold;
            text-align: center;
        }
        
        a {
            text-decoration: none;
            color: grey;
            transition: 0.2s ease;
        }

        a:hover {
            color: black;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h2>Set New Pin</h2>
    </div>

    <div class="container">
        <h2>Temporary Password Validation</h2>
        <form method="post" action="">
            <label>Enter Your Account Number</label>
            <input type="text" name="account_number" placeholder="Enter your account number" autocomplete="off" required/><br>
            
            <label>Enter Your Temporary Password</label>
            <input type="password" name="temp_password" placeholder="Enter your temporary password" autocomplete="off" required/><br>
            
            <input type="submit" value="Validate"/>
        </form>
        
        <% 
            String account_number = request.getParameter("account_number");
            String temp_password = request.getParameter("temp_password");
            if (account_number != null && temp_password != null) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank_management", "root", "keshav610");
                    
                    PreparedStatement pst = con.prepareStatement("SELECT password FROM user_details WHERE account_number = ?");
                    pst.setString(1, account_number);
                    ResultSet rs = pst.executeQuery();
                    
                    if (rs.next()) {
                        String stored_hash = rs.getString("password");
                        if (stored_hash != null && BCrypt.checkpw(temp_password, stored_hash)) {
                            %>
                            <form action="set_new_pin" method="post">
                                <h2>Set a New Pin</h2>
                                <label>New Pin</label>
                                <input type="password" name="pin_password" placeholder="Enter new pin" required/>
                                <input type="hidden" name="account_number" value="<%= account_number %>"/>
                                <input type="submit" value="Set Pin"/>        
                            </form>
                            <%
                        } else {
                            %>
                            <p class="error">Temporary password is incorrect.</p>
                            <%
                        }
                    } else {
                        %>
                        <p class="error">Account number not found.</p>
                        <%
                    }
                    
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                %>
                <p class="error">Please enter both account number and temporary password.</p>
                <%
            }
        %>
    </div>
</body>
</html>
