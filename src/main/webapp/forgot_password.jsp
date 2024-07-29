<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot Password</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=DM+Sans:ital,opsz,wght@0,9..40,100..1000;1,9..40,100..1000&display=swap");
        body {
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: "DM Sans", sans-serif;
            background-color: #f0f0f0;
        }
        .container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            width: 500px;
            padding: 20px;    
        }
        .container h2 {
            font-weight: 700;
            margin: 0;
            text-align: center;
        }
        .otp_div {
            margin: 15px;
        }
        .otp_div form {
            display: flex;
            align-items: center;
            flex-direction: column;
            justify-content: center;
            width: 100%;
        }
        .otp_div form label {
            text-align: left;
            font-weight: 500;
            font-size: 20px;
            width: 80%;
            margin-bottom: 5px;
        }
        .otp_div form input[type="email"],
        .otp_div form input[type="text"] {
            padding: 10px;
            border-radius: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
            font-weight: 600;
            width: 80%;
            margin: 10px 0;
        }
        .otp_div form input[type="submit"] {
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
            width: 40%;
            margin: 10px 0;
        }
        .otp_div form input[type="submit"]:hover {
            background-color: white;
            border: 2px solid black;
            color: black;
            box-shadow: 0px 5px 0px 0px #000000;
        }
        .status {
            color: #d9534f;
            margin-top: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Forgot Password</h2>
        <div class="otp_div">
            <form action="send_otp" method="post">
                <label for="user_email">Enter your email</label>
                <input type="email" id="user_email" name="user_email" autocomplete="off" required/>
                <input type="submit" value="Get OTP"/>
            </form>
        </div>
        <div class="otp_div">
            <form action="send_otp" method="post">
                <label for="input_otp">Enter OTP</label>
                <input type="text" id="input_otp" name="input_otp" autocomplete="off" required/>
                <input type="submit" value="Validate"/>
            </form>
        </div>
        <div class="status">
            <% String status = (String) request.getAttribute("status"); %>
            <%= status != null ? status : "" %>
        </div>
    </div>
</body>
</html>
