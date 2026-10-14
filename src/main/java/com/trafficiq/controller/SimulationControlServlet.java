package com.trafficiq.controller;

import com.trafficiq.service.SimulationManager;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/simulationControl")
public class SimulationControlServlet extends HttpServlet {

    private final SimulationManager simulationManager = SimulationManager.getInstance();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (action == null || action.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Missing action\"}");
            return;
        }

        try {
            if ("START_ALL".equalsIgnoreCase(action)) {
                simulationManager.startAll();
                writeSuccess(response, "START_ALL");
                return;
            }

            if ("STOP_ALL".equalsIgnoreCase(action)) {
                simulationManager.stopAll();
                writeSuccess(response, "STOP_ALL");
                return;
            }

            if ("PAUSE_JUNCTION".equalsIgnoreCase(action)
                    || "RESUME_JUNCTION".equalsIgnoreCase(action)
                    || "EMERGENCY_ON".equalsIgnoreCase(action)
                    || "EMERGENCY_OFF".equalsIgnoreCase(action)) {

                int junctionId = parseRequiredInt(request, response, "junctionId");
                if (junctionId == Integer.MIN_VALUE) return;

                switch (action.toUpperCase()) {
                    case "PAUSE_JUNCTION":
                        simulationManager.pauseJunction(junctionId);
                        writeSuccess(response, action.toUpperCase());
                        return;
                    case "RESUME_JUNCTION":
                        simulationManager.resumeJunction(junctionId);
                        writeSuccess(response, action.toUpperCase());
                        return;
                    case "EMERGENCY_ON":
                        int signalId = parseRequiredInt(request, response, "signalId");
                        if (signalId == Integer.MIN_VALUE) return;
                        simulationManager.requestEmergency(junctionId, signalId);
                        writeSuccess(response, "EMERGENCY_ON");
                        return;
                    case "EMERGENCY_OFF":
                        simulationManager.clearEmergency(junctionId);
                        writeSuccess(response, "EMERGENCY_OFF");
                        return;
                    default:
                        break;
                }
            }

            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Unknown action\"}");

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Invalid numeric parameter\"}");
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"" + escapeJson(e.getMessage()) + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"message\":\"Server error\"}");
        }
    }

    private int parseRequiredInt(HttpServletRequest request, HttpServletResponse response, String name)
            throws IOException {
        String value = request.getParameter(name);
        if (value == null || value.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Missing " + name + "\"}");
            return Integer.MIN_VALUE;
        }
        return Integer.parseInt(value);
    }

    private void writeSuccess(HttpServletResponse response, String action) throws IOException {
        response.getWriter().write("{\"success\":true,\"action\":\"" + action + "\"}");
    }

    private String escapeJson(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
