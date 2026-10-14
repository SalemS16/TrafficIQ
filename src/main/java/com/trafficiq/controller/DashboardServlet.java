package com.trafficiq.controller;

import com.trafficiq.dao.JunctionDAO;
import com.trafficiq.dao.SignalDAO;
import com.trafficiq.model.Junction;
import com.trafficiq.model.Signal;
import com.trafficiq.service.SimulationManager;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Junction> junctions = new JunctionDAO().getAllJunctions();
        int totalJunctions = junctions == null ? 0 : junctions.size();
        int totalSignals = 0;
        SignalDAO signalDAO = new SignalDAO();
        SimulationManager manager = SimulationManager.getInstance();

        if (junctions != null) {
            for (Junction junction : junctions) {
                List<Signal> signals = signalDAO.getSignalsByJunction(junction.getJunctionId());
                if (signals != null) totalSignals += signals.size();
                manager.getSimulation(junction.getJunctionId());
            }
        }

        List<Map<String, Object>> rows = TrafficDashboardData.loadSignalRows();
        long congested = rows.stream().filter(r -> Boolean.TRUE.equals(r.get("congested"))).count();
        long emergencies = rows.stream().filter(r -> Boolean.TRUE.equals(r.get("emergency"))).count();

        request.setAttribute("totalJunctions", totalJunctions);
        request.setAttribute("totalSignals", totalSignals);
        request.setAttribute("congestedCount", congested);
        request.setAttribute("emergencyCount", emergencies);
        request.setAttribute("junctionList", junctions);
        request.getRequestDispatcher("/dashboard/dashboard.jsp").forward(request, response);
    }
}
