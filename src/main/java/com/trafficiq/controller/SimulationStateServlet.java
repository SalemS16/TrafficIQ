package com.trafficiq.controller;

import com.trafficiq.model.TrafficState;
import com.trafficiq.service.SimulationManager;
import com.trafficiq.service.SimulationManager.JunctionSimulation;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

@WebServlet("/simulationState")
public class SimulationStateServlet extends HttpServlet {

    private final SimulationManager simulationManager = SimulationManager.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String junctionIdParam = request.getParameter("junctionId");
        if (junctionIdParam == null || junctionIdParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        final int junctionId;
        try {
            junctionId = Integer.parseInt(junctionIdParam);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        JunctionSimulation simulation = simulationManager.getSimulation(junctionId);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");

        StringBuilder json = new StringBuilder();
        json.append("{");
        appendField(json, "globalRunning", String.valueOf(simulationManager.isGlobalRunning()), false);
        appendField(json, "paused", String.valueOf(simulation.isPaused()), true);
        appendStringField(json, "currentPhase", simulation.getCurrentPhase(), true);
        appendField(json, "phaseTimer", String.valueOf(simulation.getPhaseTimer()), true);
        appendField(json, "currentSignalId", String.valueOf(simulation.getCurrentSignalId()), true);
        appendField(json, "emergencyActive", String.valueOf(simulation.isEmergencyActive()), true);
        appendField(json, "emergencySignalId", String.valueOf(simulation.getEmergencySignalId()), true);
        appendField(json, "adaptiveGreenDuration", String.valueOf(simulation.getAdaptiveGreenDuration()), true);
        appendStringField(json, "trafficPeriod", SimulationManager.getTrafficPeriod(), true);
        json.append(",\"trafficStates\":");
        appendTrafficStates(json, simulation.getTrafficStates());
        json.append("}");

        response.getWriter().write(json.toString());
    }

    private void appendField(StringBuilder json, String key, String value, boolean comma) {
        if (comma) json.append(",");
        json.append("\"").append(key).append("\":").append(value);
    }

    private void appendStringField(StringBuilder json, String key, String value, boolean comma) {
        if (comma) json.append(",");
        json.append("\"").append(key).append("\":\"").append(escapeJson(value)).append("\"");
    }

    private void appendTrafficStates(StringBuilder json, Map<Integer, TrafficState> states) {
        json.append("{");
        boolean first = true;

        if (states != null) {
            for (Map.Entry<Integer, TrafficState> entry : states.entrySet()) {
                if (!first) json.append(",");
                first = false;

                TrafficState state = entry.getValue();
                json.append("\"").append(entry.getKey()).append("\":{");
                json.append("\"vehicleCount\":").append(state.getVehicleCount()).append(",");
                json.append("\"waitingTime\":").append(state.getWaitingTime()).append(",");
                json.append("\"vehiclesPassed\":").append(state.getVehiclesPassed());
                json.append("}");
            }
        }

        json.append("}");
    }

    private String escapeJson(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
