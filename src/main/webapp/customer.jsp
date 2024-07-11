<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<title>Sign up Page</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap');

body{
    background-color:#f0fff0;
    display: flex;
    align-items: center;
    flex-direction: column;
    justify-content: center;
}
h2{
    text-align: center;
    font-family: "Poppins", sans-serif;
    font-weight: 700;
    font-style: normal;
    font-size: 5vh;
}
.container{
    background-color: rgb(192, 228, 228);
    display: flex;
    justify-content: center;
    border-radius: 10px;
    box-shadow: 0 10px 20px rgb(141, 143, 144);
    align-items: center;
    height: 70vh;
    width:600px;
}
label{
    font-family: "Poppins", sans-serif;
    font-weight: 400;
    font-style: normal;
    font-size: 2.5vh;
    
}
input{
    width: 300px;
    margin: 10px;
    height: 30px;
}

</style>
</head>
<body>
<div><h2>Signup</h2> <h2><a href="login.jsp">Login</a></h2></div>

<div class="container">
    <form action="register" method="post">
        <div class="form-group">
            <label for="name">Name</label>
            <input type="text" id="name" name="name" placeholder="Enter your name" required/>
        </div>

        <div class="form-group">
            <label for="address">Address</label>
            <input type="text" id="address" name="address" placeholder="Enter your address" required/>
        </div>

        <div class="form-group">
            <label for="phone">Phone Number</label>
            <input type="text" id="phone" name="phone" placeholder="Enter your phone number" required/>
        </div>

        <div class="form-group">
            <label for="email">E-mail</label>
            <input type="email" id="email" name="email" placeholder="Enter your email" required/>
        </div>

        <div class="form-group">
            <label for="account_type">Account Type</label>
            <select id="account_type" name="account_type" required>
                <option value="current">Current</option>
                <option value="savings">Savings</option>
            </select>
        </div>

        <div class="form-group">
            <label for="iamount">Initial Amount</label>
            <input type="text" id="iamount" name="iamount" placeholder="Enter your initial amount" required/>
        </div>

        <div class="form-group">
            <label for="dob">Date of Birth</label>
            <input type="date" id="dob" name="dob" required/>
        </div>

        <div class="form-group">
            <label for="id_proof">Id Proof</label>
            <input type="text" id="id_proof" name="id_proof" placeholder="Enter your AADHAR number" required/>
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Enter your password" required/>
        </div>

        <input type="submit" value="Register"/>
    </form>
</div>
</body>
</html>