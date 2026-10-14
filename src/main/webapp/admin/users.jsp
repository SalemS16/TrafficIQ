<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.trafficiq.model.User" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    User loggedUser = (User) session.getAttribute("loggedUser");

    if (loggedUser == null ||
            loggedUser.getRole() == null ||
            !"ADMIN".equalsIgnoreCase(loggedUser.getRole())) {

        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );
        return;
    }

    String contextPath = request.getContextPath();

    String csrfToken = (String) request.getAttribute("csrfToken");

    String errorMessage =
            (String) request.getAttribute("errorMessage");

    String successMessage =
            (String) request.getAttribute("successMessage");

    if (errorMessage == null) {
        errorMessage = (String) session.getAttribute("errorMessage");
        session.removeAttribute("errorMessage");
    }

    if (successMessage == null) {
        successMessage = (String) session.getAttribute("successMessage");
        session.removeAttribute("successMessage");
    }

    List<User> users =
            (List<User>) request.getAttribute("users");

    if (users == null) {
        users = (List<User>) request.getAttribute("userList");
    }

    if (users == null) {
        users = (List<User>) request.getAttribute("allUsers");
    }

    if (csrfToken == null) {
        csrfToken = "";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>TrafficIQ | User Management</title>

    <style>
        :root {
            --black: #111827;
            --black-hover: #000000;
            --background: #f3f5f9;
            --white: #ffffff;
            --text: #172033;
            --muted: #64748b;
            --border: #e2e8f0;
            --green: #15803d;
            --green-bg: #f0fdf4;
            --red: #b91c1c;
            --red-bg: #fef2f2;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background: var(--background);
            color: var(--text);
        }

        a {
            color: inherit;
        }

        .navbar {
            min-height: 76px;
            padding: 15px 5%;
            background: #101318;
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
            box-shadow: 0 4px 18px rgba(0, 0, 0, 0.12);
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 23px;
            font-weight: 750;
            letter-spacing: -0.6px;
        }

        .brand-icon {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #252a33;
            font-size: 22px;
        }

        .brand span {
            color: #b8c0cc;
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .page-container {
            width: min(1200px, 92%);
            margin: 36px auto 60px;
        }

        .page-heading {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
            margin-bottom: 28px;
        }

        .eyebrow {
            margin-bottom: 8px;
            color: var(--muted);
            font-size: 12px;
            font-weight: 750;
            text-transform: uppercase;
            letter-spacing: 1.5px;
        }

        h1 {
            margin: 0;
            font-size: clamp(26px, 4vw, 34px);
            letter-spacing: -1px;
        }

        .subtitle {
            margin: 10px 0 0;
            color: var(--muted);
            font-size: 14px;
            line-height: 1.7;
        }

        .btn {
            min-height: 42px;
            padding: 11px 17px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            border: 1px solid transparent;
            border-radius: 9px;
            background: var(--black);
            color: white;
            text-decoration: none;
            font: inherit;
            font-size: 13px;
            font-weight: 650;
            cursor: pointer;
            transition: background 0.2s, transform 0.2s,
                        box-shadow 0.2s;
        }

        .btn:hover {
            background: var(--black-hover);
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 5px 12px rgba(0, 0, 0, 0.16);
        }

        .btn:focus-visible,
        input:focus-visible {
            outline: 3px solid #a3a3a3;
            outline-offset: 3px;
        }

        .btn-outline {
            border-color: #4b5563;
            background: transparent;
            color: white;
        }

        .btn-outline:hover {
            background: #292d35;
        }

        .card {
            margin-bottom: 25px;
            overflow: hidden;
            border: 1px solid #e6eaf0;
            border-radius: 15px;
            background: var(--white);
            box-shadow: 0 5px 20px rgba(15, 23, 42, 0.035);
        }

        .card-header {
            padding: 22px 25px;
            border-bottom: 1px solid var(--border);
        }

        .card-header h2 {
            margin: 0;
            font-size: 18px;
            letter-spacing: -0.3px;
        }

        .card-header p {
            margin: 7px 0 0;
            color: var(--muted);
            font-size: 13px;
            line-height: 1.6;
        }

        .card-body {
            padding: 25px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 21px;
        }

        .form-group {
            min-width: 0;
        }

        .form-group label {
            display: block;
            margin-bottom: 9px;
            color: #374151;
            font-size: 13px;
            font-weight: 700;
        }

        .form-group input {
            width: 100%;
            min-height: 46px;
            padding: 12px 14px;
            border: 1px solid #d5dbe5;
            border-radius: 9px;
            background: white;
            color: var(--text);
            font: inherit;
            font-size: 14px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-group input:focus {
            border-color: #6b7280;
            box-shadow: 0 0 0 3px rgba(17, 24, 39, 0.08);
            outline: none;
        }

        .form-hint {
            margin-top: 8px;
            color: var(--muted);
            font-size: 12px;
            line-height: 1.5;
        }

        .form-footer {
            margin-top: 24px;
            padding-top: 21px;
            border-top: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            flex-wrap: wrap;
        }

        .form-footer p {
            margin: 0;
            color: var(--muted);
            font-size: 12px;
            line-height: 1.6;
        }

        .alert {
            margin-bottom: 22px;
            padding: 14px 16px;
            border-radius: 10px;
            font-size: 14px;
            line-height: 1.6;
        }

        .alert-success {
            border: 1px solid #bbf7d0;
            background: var(--green-bg);
            color: var(--green);
        }

        .alert-error {
            border: 1px solid #fecaca;
            background: var(--red-bg);
            color: var(--red);
        }

        .table-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            flex-wrap: wrap;
        }

        .count-badge {
            display: inline-flex;
            align-items: center;
            padding: 7px 11px;
            border: 1px solid var(--border);
            border-radius: 999px;
            background: #f8fafc;
            color: #475569;
            font-size: 12px;
            font-weight: 700;
        }

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        thead {
            background: #f8fafc;
        }

        th {
            padding: 15px 25px;
            border-bottom: 1px solid var(--border);
            color: #64748b;
            font-size: 11px;
            font-weight: 750;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            white-space: nowrap;
        }

        td {
            padding: 17px 25px;
            border-bottom: 1px solid #edf0f5;
            color: #374151;
            font-size: 13px;
            vertical-align: middle;
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        tbody tr:hover {
            background: #fafbfc;
        }

        .user-name {
            color: #111827;
            font-weight: 700;
        }

        .role-badge {
            display: inline-block;
            padding: 6px 10px;
            border: 1px solid #d1fae5;
            border-radius: 999px;
            background: #ecfdf5;
            color: #047857;
            font-size: 11px;
            font-weight: 750;
        }

        .empty-state {
            padding: 35px 20px;
            color: var(--muted);
            text-align: center;
            font-size: 14px;
        }

        .empty-icon {
            margin-bottom: 10px;
            font-size: 27px;
        }

        .footer {
            padding: 22px 10px 0;
            color: #94a3b8;
            text-align: center;
            font-size: 12px;
        }

        @media (max-width: 640px) {
            .navbar {
                padding: 15px 4%;
            }

            .brand {
                font-size: 20px;
            }

            .page-container {
                width: 92%;
                margin-top: 25px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .card-header,
            .card-body {
                padding: 19px;
            }

            th,
            td {
                padding: 14px 16px;
            }

            .form-footer {
                align-items: stretch;
                flex-direction: column;
            }

            .form-footer .btn {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<nav class="navbar">
    <div class="brand">
        <div class="brand-icon" aria-hidden="true">&#128678;</div>
        <div>Traffic<span>IQ</span></div>
    </div>

    <div class="nav-actions">
        <a class="btn btn-outline"
           href="<%= contextPath %>/dashboard">
            &#8592; Back to Dashboard
        </a>

    </div>
</nav>

<main class="page-container">

    <div class="page-heading">
        <div>
            <div class="eyebrow">Administration</div>
            <h1>User Management</h1>
            <p class="subtitle">
                Create operator accounts and review registered users.
                Account creation is restricted to administrators.
            </p>
        </div>
    </div>

    <% if (successMessage != null && !successMessage.isBlank()) { %>
        <div class="alert alert-success" role="status">
            <strong>Success:</strong>
            <%= escapeHtml(successMessage) %>
        </div>
    <% } %>

    <% if (errorMessage != null && !errorMessage.isBlank()) { %>
        <div class="alert alert-error" role="alert">
            <strong>Unable to complete the request:</strong>
            <%= escapeHtml(errorMessage) %>
        </div>
    <% } %>

    <section class="card">
        <div class="card-header">
            <h2>Create Operator Account</h2>
            <p>
                Enter the new operator's username and initial password.
                The account will be assigned the OPERATOR role.
            </p>
        </div>

        <div class="card-body">

            <form action="<%= contextPath %>/admin/users"
                  method="post"
                  autocomplete="off">

                <input type="hidden"
                       name="csrfToken"
                       value="<%= escapeHtml(csrfToken) %>">

                <div class="form-grid">

                    <div class="form-group">
                        <label for="username">Username</label>
                        <input
                            type="text"
                            id="username"
                            name="username"
                            placeholder="Enter a username"
                            minlength="3"
                            maxlength="50"
                            autocomplete="off"
                            required>
                        <div class="form-hint">
                            Choose a unique username for the operator.
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password">Initial Password</label>
                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Create an initial password"
                            minlength="8"
                            maxlength="72"
                            autocomplete="new-password"
                            required>
                        <div class="form-hint">
                            Use at least 8 characters. Share credentials securely.
                        </div>
                    </div>

                </div>

                <div class="form-footer">
                    <p>
                        Role assigned automatically:
                        <strong>OPERATOR</strong>
                    </p>

                    <button type="submit" class="btn">
                        + Create Operator
                    </button>
                </div>

            </form>

        </div>
    </section>

    <section class="card">

        <div class="card-header">
            <div class="table-header">
                <div>
                    <h2>Registered Users</h2>
                    <p>
                        Review the accounts currently available in TrafficIQ.
                    </p>
                </div>

                <% if (users != null) { %>
                    <span class="count-badge">
                        <%= users.size() %> account(s)
                    </span>
                <% } %>
            </div>
        </div>

        <div class="table-wrapper">

            <table>
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Account Type</th>
                    </tr>
                </thead>

                <tbody>

                <% if (users != null && !users.isEmpty()) { %>

                    <% for (User user : users) { %>

                        <tr>
                            <td>
                                <%= user.getUserId() %>
                            </td>

                            <td class="user-name">
                                <%= escapeHtml(user.getUsername()) %>
                            </td>

                            <td>
                                <%= escapeHtml(user.getRole()) %>
                            </td>

                            <td>
                                <% if ("ADMIN".equalsIgnoreCase(user.getRole())) { %>
                                    <span class="role-badge">Administrator</span>
                                <% } else { %>
                                    <span class="role-badge">Operator</span>
                                <% } %>
                            </td>
                        </tr>

                    <% } %>

                <% } else { %>

                    <tr>
                        <td colspan="4">
                            <div class="empty-state">
                                <div class="empty-icon">&#128100;</div>
                                <strong>No user records available</strong>
                                <p>
                                    If you expected existing accounts here,
                                    verify that AdminUsersServlet forwards the
                                    user list using the attribute name
                                    <code>users</code> or <code>userList</code>.
                                </p>
                            </div>
                        </td>
                    </tr>

                <% } %>

                </tbody>
            </table>

        </div>
    </section>

    <div class="footer">
        TrafficIQ &bull; Smart Traffic Signal Optimization
    </div>

</main>

</body>
</html>
