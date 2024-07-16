<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Login Page</title>
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
        }

        .navbar {
            width: 100%;
            background-color: #fff;
            padding: 10px 0;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: center;
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

        .container section {
            width: 100%;
            margin-bottom: 20px;
        }

        .container section h2 {
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
        }

        .container input[type="submit"] {
            background-color: rgb(0, 0, 0);
            color: #fff;
            border: none;
            border-radius: 5px;
            padding: 10px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        .container input[type="submit"]:hover {
            background-color: rgb(66, 70, 68);
        }

        .container p {
            font-weight: bold;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="navbar">
    <h2><a href="customer.jsp">Signup</a></h2>
    <h2>Login</h2>
</div>

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
        <% 
            String accountNumber = (String) request.getAttribute("account_number");
            String accountPassword = (String) request.getAttribute("account_password");
            if (accountNumber != null && accountPassword != null) {
        %>
            <p>Account Number: <%= accountNumber %></p>
            <p>Account Password: <%= accountPassword %></p>
        <% } %>
    </section>

    <section>
        <h2>Account Login</h2>
        <form action="login" method="post">
            <label for="account_number">Enter Account Number</label>
            <input
                    type="text"
                    id="account_number"
                    name="account_number"
                    placeholder="Enter your Account Number"
                    required
            />

            <label for="account_password">Enter your Account Password</label>
            <input
                    type="password"
                    id="account_password"
                    name="account_password"
                    placeholder="Enter your Account password"
                    required
            />

            <input type="submit" value="Login" name="signin"/>
        </form>
        <% 
            String loginError = (String) request.getAttribute("loginError");
            if (loginError != null) {
        %>
            <p style="color: red;"><%= loginError %></p>
        <% } %>
    </section>
</div>
</body>
</html>
