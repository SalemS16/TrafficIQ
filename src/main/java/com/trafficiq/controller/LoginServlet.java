
package com.trafficiq.controller;

import com.trafficiq.dao.UserDAO;
import com.trafficiq.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Cache-Control", "no-store");

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            response.sendRedirect(
                    request.getContextPath() + "/dashboard");
            return;
        }

        request.getRequestDispatcher("/login.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.isBlank()
                || password == null || password.isEmpty()) {

            request.setAttribute(
                    "errorMessage",
                    "Please enter your username and password.");

            request.getRequestDispatcher("/login.jsp")
                    .forward(request, response);
            return;
        }

        User user = userDAO.login(username.trim(), password);

        if (user == null) {
            request.setAttribute(
                    "errorMessage",
                    "Invalid username or password.");

            request.getRequestDispatcher("/login.jsp")
                    .forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        request.changeSessionId();
        session.setAttribute("loggedUser", user);

        response.sendRedirect(
                request.getContextPath() + "/dashboard");
    }
}
