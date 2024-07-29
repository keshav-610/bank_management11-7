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
            autocomplete: off; 
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
    <h2>Login</h2>
</div>

<div class="container">

    <section>
        <h2>Account Login</h2>
        <form action="login" method="post">
            <label for="email">Enter Email</label>
            <input
                type="text"
                id="email"
                name="email"
                placeholder="Enter your Email"
                autocomplete="off"
                required
            />

            <label for="account_password">Enter your Account Password</label>
            <input
                type="password"
                id="account_password"
                name="account_password"
                placeholder="Enter your Account password"
                autocomplete="off"
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
    <a href="forgot_password.jsp">Forgot Password</a>
</div>
<br><br>

<a href="set_new_pin.jsp">Set New Pin</a>
</body>
</html>
