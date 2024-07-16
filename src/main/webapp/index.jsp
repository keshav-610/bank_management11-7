<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Central Bank of India</title>
</head>
<style>
    @import url('https://fonts.googleapis.com/css2?family=DM+Sans:ital,opsz,wght@0,9..40,100..1000;1,9..40,100..1000&display=swap');

body{
    height: 90vh;
}
.container{
    display: flex;
    justify-content: space-around;
    align-items: center;
    height: 90vh;
}
.home{
    display: flex;
    justify-content: space-evenly;
    align-items: center;
    height: 60vh;
    flex-direction: column;
}
.buttons{
    display:flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
}
img{
    border-radius: 20px;
}
h1{
    font-family: "DM Sans", sans-serif;
    font-optical-sizing: auto;
    font-weight: 800;
    font-style: normal;
    font-size: 40px;
    margin-bottom: 5px;
}
h4{
    margin-top: 5px;
    font-family: "DM Sans", sans-serif;
    font-optical-sizing: auto;
    font-weight: 800;
    font-style: normal;
    font-size: 20px;
    text-align: center;
}
.header{
    display: flex;
    align-items: center;
    flex-direction: column;

}
button{
    background-color: black;
    border: 0 solid transparent;
    width: 220px;
    height: 70px;
    border-radius: 10px;
    margin: 20px;
    transition: 0.2s ease-out;
}
a{
    text-decoration: none;
    color: aliceblue;
    font-size: 20px;
    font-weight: 600;
}
button:hover{
    text-align: center;
    background-color: rgb(48, 46, 46);
}
</style>
<body>
    <div class="container">
        <div class="image">
            <img src="img/13068.jpg" alt="logo" height="570px">
        </div>
        <div class="home">
            <div class="header">
                <img src="img/logo.png" alt="logo" height="100">
                <h1>Welcome to Central Bank of India</h1>
                <h4>For the people's future</h4>
            </div>
            <div class="buttons">
                <button><a href="customer.jsp">Customer</a></button>
            <button><a href="admin.jsp">Admin</a></button>
            </div>
        </div>
        </div>
    </div>
</body>
</html>
