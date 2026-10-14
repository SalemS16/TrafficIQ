package com.trafficiq.controller;

import com.trafficiq.dao.JunctionDAO;
import com.trafficiq.model.Junction;
import com.trafficiq.model.Signal;
import com.trafficiq.model.TrafficState;
import com.trafficiq.service.SimulationManager;
import com.trafficiq.service.SimulationManager.JunctionSimulation;
import java.util.*;

final class TrafficDashboardData {
    private TrafficDashboardData() {}

    static List<Map<String, Object>> loadSignalRows() {
        List<Map<String, Object>> rows = new ArrayList<>();
        List<Junction> junctions = new JunctionDAO().getAllJunctions();
        SimulationManager manager = SimulationManager.getInstance();
        if (junctions == null) return rows;

        for (Junction junction : junctions) {
            JunctionSimulation simulation = manager.getSimulation(junction.getJunctionId());
            List<Signal> signals = simulation.getSignals();
            Map<Integer, TrafficState> states = simulation.getTrafficStates();
            if (signals == null) continue;

            for (Signal signal : signals) {
                TrafficState state = states == null ? null : states.get(signal.getSignalId());
                int queue = state == null ? 0 : Math.max(0, state.getVehicleCount());
                int wait = state == null ? 0 : Math.max(0, state.getWaitingTime());

                Map<String, Object> row = new HashMap<>();
                row.put("junctionId", junction.getJunctionId());
                row.put("junctionName", junction.getJunctionName());
                row.put("signalId", signal.getSignalId());
                row.put("direction", signal.getDirection());
                row.put("vehicleCount", queue);
                row.put("waitingTime", wait);
                row.put("congestionLevel", classify(queue));
                row.put("congested", queue >= 41);
                row.put("emergency", simulation.isEmergencyActive()
                        && simulation.getEmergencySignalId() == signal.getSignalId());
                rows.add(row);
            }
        }
        return rows;
    }

    static String classify(int queue) {
        if (queue <= 9) return "Very Low";
        if (queue <= 15) return "Low";
        if (queue <= 25) return "Medium";
        if (queue <= 40) return "High";
        return "Congested";
    }
}

