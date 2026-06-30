<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>TrafficIQ Login</title>
</head>
<body>

<h2>TrafficIQ Login</h2>

<form action="login" method="post">

    Username:
    <input type="text"
           name="username"
           required>

    <br><br>

    Password:
    <input type="password"
           name="password"
           required>

    <br><br>

    <button type="submit">
        Login
    </button>

</form>

</body>
</html>