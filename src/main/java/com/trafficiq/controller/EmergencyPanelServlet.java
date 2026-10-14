package com.trafficiq.controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/emergencies")
public class EmergencyPanelServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Map<String, Object>> active = TrafficDashboardData.loadSignalRows().stream()
                .filter(r -> Boolean.TRUE.equals(r.get("emergency")))
                .collect(Collectors.toList());
        request.setAttribute("emergencyRows", active);
        request.setAttribute("emergencyCount", active.size());
        request.getRequestDispatcher("/dashboard/emergencies.jsp").forward(request, response);
    }
}
