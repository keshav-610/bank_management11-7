<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>Sign up Page</title>
    <link rel="icon" type="image/x-icon" href="img/logo.png" />
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
        .form-container {
            background-color: #fff;
            padding: 20px 40px;
            width: 600px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        .form-container h2 {
            text-align: center;
            margin-bottom: 20px;
            color: rgb(114, 227, 167);
        }
        .form-container div {
            margin-bottom: 15px;
        }
        .form-container label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-container input,
        .form-container select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
            font-family: "DM Sans", sans-serif;
            font-optical-sizing: auto;
            font-weight: 600;
            font-style: normal;
        }
        .form-container input[type="submit"] {
            background-color: rgb(0, 0, 0);
            color: #fff;
            border: none;
            cursor: pointer;
            font-weight: bold;
            transition: 0.2s ease;
            border: 2px solid white;
        }
        .form-container input[type="submit"]:hover {
            background-color: white;
            border: 2px solid black;
            color: black;
            box-shadow: 0px 5px 0px 0px #000000;
        }
        .password-section {
            display: flex;
            justify-content: center;
            width: 100%;
            align-items: center;
            height: 100%;
            position: block;
        }
        i {
            font-size: 25px;
            cursor: pointer;
        }
        .passwordinputbox {
            margin-right: 10px;
            position: relative;
        }
        .hide_and_show {
            padding: 9px;
            border: 2px solid black;
            background-color: white;
            color: black;
            border-radius: 5px;
            font-family: "DM Sans", sans-serif;
            font-optical-sizing: auto;
            font-weight: 600;
            font-style: normal;
            cursor: pointer;
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bcryptjs/2.4.3/bcrypt.min.js"></script>
</head>
<body>
    <div class="navbar">
        <h2>Signup</h2>
        <h2><a href="login.jsp">Login</a></h2>
    </div>

    <div class="form-container">
        <form id="registrationForm" action="register" method="post">
            <div>
                <label for="name">Name</label>
                <input type="text" id="name" name="name" placeholder="Enter your name" autocomplete="off" required />
            </div>

            <div>
                <label for="address">Address</label>
                <input type="text" id="address" name="address" placeholder="Enter your address" autocomplete="off" required />
            </div>

            <div>
                <label for="phone">Phone Number</label>
                <input type="text" id="phone" name="phone" placeholder="Enter your phone number" autocomplete="off" required />
            </div>

            <div>
                <label for="email">E-mail</label>
                <input type="email" id="email" name="email" placeholder="Enter your email" autocomplete="off" required />
            </div>

            <div>
                <label for="account_type">Account Type</label>
                <select id="account_type" name="account_type" required>
                    <option value="current">Current</option>
                    <option value="savings">Savings</option>
                </select>
            </div>

            <div>
                <label for="iamount">Initial Amount</label>
                <input type="text" id="iamount" name="iamount" placeholder="Enter your initial amount" autocomplete="off" required />
            </div>
            <% if ("invalid_input".equals(request.getAttribute("status"))) { %>
            <div class="error-message">
                <p style="color: red; text-align: center; font-weight: bold"><%= request.getAttribute("message") %></p>
            </div>
            <% } %>

            <div>
                <label for="dob">Date of Birth</label>
                <input type="date" id="dob" name="dob" required />
            </div>

            <div>
                <label for="id_proof">ID Proof</label>
                <input type="text" id="id_proof" name="id_proof" placeholder="Enter your AADHAR number" autocomplete="off" required />
            </div>

            <div class="password-container">
                <label for="password">Password</label>
                <div class="password-section">
                    <input type="password" id="password" name="password" placeholder="Enter your password" class="passwordinputbox" autocomplete="off" required />
                    <button type="button" class="hide_and_show">Show</button>
                </div>
            </div>
            <script>
                document.querySelector(".hide_and_show").addEventListener('click', function() {
                    const password_input = document.getElementById('password');
                    const is_password = password_input.getAttribute('type') === 'password';
                    password_input.setAttribute('type', is_password ? 'text' : 'password');
                    this.textContent = is_password ? "Hide" : "Show";
                });

                document.getElementById('registrationForm').addEventListener('submit', function(event) {
                    event.preventDefault(); // Prevent form from submitting

                    const password = document.getElementById('password').value;

                    bcrypt.hash(password, 10, function(err, hash) {
                        if (err) {
                            console.error(err);
                            return;
                        }

                        // Set the value of the password input to the hashed password and change its type to hidden
                        const passwordInput = document.getElementById('password');
                        passwordInput.value = hash;
                        passwordInput.type = 'hidden';

                        document.getElementById('registrationForm').submit();
                    });
                });
            </script>

            <input type="submit" value="Register" />
        </form>
    </div>
</body>
</html>
