package com.trafficiq.controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/congestion")
public class CongestionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Map<String, Object>> rows = TrafficDashboardData.loadSignalRows();
        long count = rows.stream().filter(r -> Boolean.TRUE.equals(r.get("congested"))).count();
        request.setAttribute("signalRows", rows);
        request.setAttribute("congestedCount", count);
        request.getRequestDispatcher("/dashboard/congestion.jsp").forward(request, response);
    }
}
