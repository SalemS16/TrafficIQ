
package com.trafficiq.controller;

import com.trafficiq.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(
            ServletRequest servletRequest,
            ServletResponse servletResponse,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String contextPath = request.getContextPath();
        String path = request.getRequestURI().substring(contextPath.length());

        // Public entry and login resources.
        if (path.equals("/")
                || path.equals("/index.jsp")
                || path.equals("/login")
                || path.equals("/login.jsp")
                || path.equals("/favicon.ico")
                || path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.startsWith("/images/")
                || path.startsWith("/assets/")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        Object value = session == null
                ? null : session.getAttribute("loggedUser");

        if (!(value instanceof User)) {
            response.setHeader("Cache-Control", "no-store");
            response.sendRedirect(contextPath + "/login");
            return;
        }

        User user = (User) value;

        // Protect the entire admin area, including direct JSP requests.
        if (path.startsWith("/admin/")
                && (user.getRole() == null
                || !user.getRole().equalsIgnoreCase("ADMIN"))) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Admin access required.");
            return;
        }

        response.setHeader("Cache-Control", "no-store");
        chain.doFilter(request, response);
    }
}

