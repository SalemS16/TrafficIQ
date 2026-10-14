```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Objects" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>TrafficIQ | Login</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            font-family: Arial, Helvetica, sans-serif;
            background: linear-gradient(135deg, #0b1220, #132b45, #075985);
            color: #172033;
        }

        .login-container {
            width: 100%;
            max-width: 420px;
            padding: 38px;
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.28);
        }

        .brand {
            text-align: center;
            margin-bottom: 30px;
        }

        .brand-icon {
            width: 62px;
            height: 62px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px;
            border-radius: 16px;
            background: #e0f2fe;
            color: #0369a1;
            font-size: 30px;
        }

        .brand h1 {
            font-size: 29px;
            color: #0f172a;
            letter-spacing: -0.8px;
        }

        .brand h1 span {
            color: #0284c7;
        }

        .brand p {
            margin-top: 10px;
            color: #64748b;
            font-size: 14px;
            line-height: 1.5;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #334155;
            font-size: 14px;
            font-weight: 600;
        }

        .form-group input {
            width: 100%;
            padding: 13px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 9px;
            outline: none;
            font-size: 15px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-group input:focus {
            border-color: #0284c7;
            box-shadow: 0 0 0 3px rgba(2, 132, 199, 0.13);
        }

        .error-message {
            margin-bottom: 20px;
            padding: 12px;
            border: 1px solid #fecaca;
            border-radius: 8px;
            background: #fef2f2;
            color: #b91c1c;
            font-size: 14px;
            line-height: 1.5;
        }

        .login-button {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 9px;
            background: #0284c7;
            color: #ffffff;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s, transform 0.2s;
        }

        .login-button:hover {
            background: #0369a1;
            transform: translateY(-1px);
        }

        .security-note {
            margin-top: 24px;
            padding-top: 18px;
            border-top: 1px solid #e2e8f0;
            text-align: center;
            color: #64748b;
            font-size: 12px;
            line-height: 1.6;
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 28px 22px;
            }
        }
    </style>
</head>

<body>

<div class="login-container">

    <div class="brand">
        <div class="brand-icon" aria-hidden="true">&#128678;</div>

        <h1>Traffic<span>IQ</span></h1>

        <p>
            Smart Traffic Signal Optimization<br>
            Sign in to access your dashboard
        </p>
    </div>

    <%
        String errorMessage =
                (String) request.getAttribute("errorMessage");
    %>

    <% if (errorMessage != null && !errorMessage.isBlank()) { %>
        <div class="error-message" role="alert">
            <%= errorMessage.replace("&", "&amp;")
                             .replace("<", "&lt;")
                             .replace(">", "&gt;")
                             .replace("\"", "&quot;")
                             .replace("'", "&#39;") %>
        </div>
    <% } %>

    <form action="<%= request.getContextPath() %>/login"
          method="post">

        <div class="form-group">
            <label for="username">Username</label>

            <input
                type="text"
                id="username"
                name="username"
                placeholder="Enter your username"
                autocomplete="username"
                required>
        </div>

        <div class="form-group">
            <label for="password">Password</label>

            <input
                type="password"
                id="password"
                name="password"
                placeholder="Enter your password"
                autocomplete="current-password"
                required>
        </div>

        <button type="submit" class="login-button">
            Sign In
        </button>

    </form>

    <div class="security-note">
        Authorized users only.<br>
        Contact your administrator if you need an account.
    </div>

</div>

</body>
</html>
```