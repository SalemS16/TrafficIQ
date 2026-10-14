
        package com.trafficiq.controller;

import com.trafficiq.dao.UserDAO;
import com.trafficiq.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.util.Base64;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {

    private UserDAO userDAO;
    private static final SecureRandom RANDOM = new SecureRandom();

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return false;
        }

        Object value = session.getAttribute("loggedUser");

        if (!(value instanceof User)) {
            return false;
        }

        User user = (User) value;

        return user.getRole() != null
                && user.getRole().equalsIgnoreCase("ADMIN");
    }

    private String createCsrfToken() {
        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);

        return Base64.getUrlEncoder()
                .withoutPadding()
                .encodeToString(bytes);
    }

    private boolean validCsrfToken(
            HttpSession session, String submittedToken) {

        if (session == null || submittedToken == null) {
            return false;
        }

        String expectedToken =
                (String) session.getAttribute("adminUsersCsrf");

        if (expectedToken == null) {
            return false;
        }

        return MessageDigest.isEqual(
                expectedToken.getBytes(StandardCharsets.UTF_8),
                submittedToken.getBytes(StandardCharsets.UTF_8));
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Cache-Control", "no-store");

        if (!isAdmin(request)) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Admin access required.");
            return;
        }

        HttpSession session = request.getSession();

        String token =
                (String) session.getAttribute("adminUsersCsrf");

        if (token == null) {
            token = createCsrfToken();
            session.setAttribute("adminUsersCsrf", token);
        }

        request.setAttribute("csrfToken", token);

        // Transfer flash messages to the request and remove them
        // from the session so they appear only once.
        request.setAttribute(
                "adminError", session.getAttribute("adminError"));
        request.setAttribute(
                "adminSuccess", session.getAttribute("adminSuccess"));

        session.removeAttribute("adminError");
        session.removeAttribute("adminSuccess");

        try {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("users", users);

            request.getRequestDispatcher("/admin/users.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                    "Unable to load registered users.", e);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Cache-Control", "no-store");

        if (!isAdmin(request)) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Admin access required.");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (!validCsrfToken(
                session, request.getParameter("csrfToken"))) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Invalid or expired form token. Reload the page.");
            return;
        }

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.isBlank()) {
            setErrorAndRedirect(
                    request, response, "Username is required.");
            return;
        }

        username = username.trim();

        if (username.length() > 100) {
            setErrorAndRedirect(
                    request, response, "Username cannot exceed 100 characters.");
            return;
        }

        if (password == null || password.length() < 8) {
            setErrorAndRedirect(
                    request, response,
                    "Password must contain at least 8 characters.");
            return;
        }

        try {
            if (userDAO.usernameExists(username)) {
                setErrorAndRedirect(
                        request, response,
                        "That username already exists.");
                return;
            }

            // The DAO accepts OPERATOR only, never ADMIN.
            boolean created = userDAO.createUser(
                    username, password, "OPERATOR");

            if (created) {
                session.setAttribute(
                        "adminSuccess",
                        "Operator account created successfully.");
            } else {
                session.setAttribute(
                        "adminError",
                        "Unable to create the account. Check the submitted details.");
            }

            response.sendRedirect(
                    request.getContextPath() + "/admin/users");

        } catch (SQLException e) {
            // A unique database constraint should also protect usernames
            // against concurrent duplicate submissions.
            throw new ServletException(
                    "Unable to create the user account.", e);
        }
    }

    private void setErrorAndRedirect(
            HttpServletRequest request,
            HttpServletResponse response,
            String message) throws IOException {

        request.getSession().setAttribute("adminError", message);

        response.sendRedirect(
                request.getContextPath() + "/admin/users");
    }
}
