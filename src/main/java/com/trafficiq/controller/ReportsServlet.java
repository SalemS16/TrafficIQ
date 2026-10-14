package com.trafficiq.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/reports")
public class ReportsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Map<String, Object>> allRows = TrafficDashboardData.loadSignalRows();

        String junctionParam = request.getParameter("junctionId");
        Integer selectedJunctionId = null;
        if (junctionParam != null && !junctionParam.isBlank()) {
            try {
                selectedJunctionId = Integer.valueOf(junctionParam);
            } catch (NumberFormatException ignored) {
                selectedJunctionId = null;
            }
        }

        final Integer filterId = selectedJunctionId;
        List<Map<String, Object>> rows = allRows.stream()
                .filter(row -> filterId == null
                        || filterId.equals(((Number) row.get("junctionId")).intValue()))
                .collect(Collectors.toCollection(ArrayList::new));

        long veryLow = countLevel(rows, "Very Low");
        long low = countLevel(rows, "Low");
        long medium = countLevel(rows, "Medium");
        long high = countLevel(rows, "High");
        long congested = countLevel(rows, "Congested");
        long emergencies = rows.stream().filter(row -> Boolean.TRUE.equals(row.get("emergency"))).count();
        long totalQueue = rows.stream().mapToLong(row -> ((Number) row.get("vehicleCount")).longValue()).sum();
        double averageWait = rows.isEmpty() ? 0.0
                : rows.stream().mapToLong(row -> ((Number) row.get("waitingTime")).longValue()).average().orElse(0.0);
        int maxWait = rows.stream().mapToInt(row -> ((Number) row.get("waitingTime")).intValue()).max().orElse(0);

        if ("csv".equalsIgnoreCase(request.getParameter("format"))) {
            response.setContentType("text/csv;charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"trafficiq-live-report.csv\"");
            try (PrintWriter out = response.getWriter()) {
                out.println("Snapshot Time,Junction ID,Junction,Signal ID,Direction,Queued Vehicles,Waiting Time, Congestion Level,Emergency Active");
                String snapshotTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                for (Map<String, Object> row : rows) {
                    out.println(csv(snapshotTime) + ","
                            + csv(row.get("junctionId")) + ","
                            + csv(row.get("junctionName")) + ","
                            + csv(row.get("signalId")) + ","
                            + csv(row.get("direction")) + ","
                            + csv(row.get("vehicleCount")) + ","
                            + csv(row.get("waitingTime")) + ","
                            + csv(row.get("congestionLevel")) + ","
                            + csv(Boolean.TRUE.equals(row.get("emergency")) ? "Yes" : "No"));
                }
            }
            return;
        }

        request.setAttribute("reportRows", rows);
        request.setAttribute("junctions", new com.trafficiq.dao.JunctionDAO().getAllJunctions());
        request.setAttribute("selectedJunctionId", selectedJunctionId);
        request.setAttribute("snapshotTime", LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm:ss a")));
        request.setAttribute("totalSignals", rows.size());
        request.setAttribute("totalQueue", totalQueue);
        request.setAttribute("averageWait", Math.round(averageWait * 10.0) / 10.0);
        request.setAttribute("maxWait", maxWait);
        request.setAttribute("emergencyCount", emergencies);
        request.setAttribute("veryLowCount", veryLow);
        request.setAttribute("lowCount", low);
        request.setAttribute("mediumCount", medium);
        request.setAttribute("highCount", high);
        request.setAttribute("congestedCount", congested);
        request.getRequestDispatcher("/dashboard/reports.jsp").forward(request, response);
    }

    private static long countLevel(List<Map<String, Object>> rows, String level) {
        return rows.stream().filter(row -> level.equals(row.get("congestionLevel"))).count();
    }

    private static String csv(Object value) {
        String text = value == null ? "" : String.valueOf(value);
        return "\"" + text.replace("\"", "\"\"") + "\"";
    }
}
