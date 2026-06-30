package com.trafficiq.controller;

import com.trafficiq.dao.UserDAO;
import com.trafficiq.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String username =
                request.getParameter("username");

        String password =
                request.getParameter("password");

        UserDAO userDAO =
                new UserDAO();

        User user =
                userDAO.login(username, password);

        if(user != null) {

            HttpSession session =
                    request.getSession();

            session.setAttribute(
                    "loggedUser",
                    user);

            response.sendRedirect(
                    "dashboard.jsp");

        } else {

            response.getWriter().println(
                    "Invalid Username or Password");

        }
    }
}
