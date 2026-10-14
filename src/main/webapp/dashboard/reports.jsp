<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.trafficiq.model.Junction" %>
<%
    List<Map<String, Object>> reportRows =
            (List<Map<String, Object>>) request.getAttribute("reportRows");
    List<Junction> junctions =
            (List<Junction>) request.getAttribute("junctions");
    Integer selectedJunctionId = (Integer) request.getAttribute("selectedJunctionId");
    String context = request.getContextPath();
    long totalSignals = ((Number) request.getAttribute("totalSignals")).longValue();
    long veryLowCount = ((Number) request.getAttribute("veryLowCount")).longValue();
    long lowCount = ((Number) request.getAttribute("lowCount")).longValue();
    long mediumCount = ((Number) request.getAttribute("mediumCount")).longValue();
    long highCount = ((Number) request.getAttribute("highCount")).longValue();
    long congestedCount = ((Number) request.getAttribute("congestedCount")).longValue();
    long maxBar = Math.max(1, Math.max(Math.max(veryLowCount, lowCount),
            Math.max(Math.max(mediumCount, highCount), congestedCount)));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>TrafficIQ | Reports</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background:#f4f6f9; color:#212529; }
        .topbar { background:#212529; }
        .panel { border:0; border-radius:16px; box-shadow:0 4px 15px rgba(0,0,0,.07); }
        .metric { font-size:30px; font-weight:750; }
        .muted-label { color:#6c757d; font-size:13px; font-weight:650; text-transform:uppercase; letter-spacing:.4px; }
        .bar-row { display:grid; grid-template-columns:110px 1fr 34px; gap:12px; align-items:center; margin:14px 0; }
        .bar-track { height:13px; background:#e9ecef; border-radius:20px; overflow:hidden; }
        .bar-fill { height:100%; border-radius:20px; background:#0d6efd; }
        .table thead th { background:#212529; color:white; white-space:nowrap; }
        .table td { vertical-align:middle; }
        .level { display:inline-block; border-radius:20px; padding:5px 10px; font-size:12px; font-weight:700; }
        .level-very-low { background:#d1e7dd; color:#146c43; }
        .level-low { background:#cff4fc; color:#055160; }
        .level-medium { background:#fff3cd; color:#664d03; }
        .level-high { background:#ffe5d0; color:#984c00; }
        .level-congested { background:#f8d7da; color:#842029; }
    </style>
</head>
<body>
<nav class="navbar navbar-dark topbar">
    <div class="container-fluid px-4">
        <a class="navbar-brand" href="<%= context %>/dashboard">🚦 TrafficIQ</a>
        <a class="btn btn-outline-light btn-sm" href="<%= context %>/dashboard">← Dashboard</a>
    </div>
</nav>

<main class="container py-4">
    <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-4">
        <div>
            <h1 class="fw-bold mb-1">Traffic Reports</h1>
            <p class="text-muted mb-0">Live simulation snapshot · Generated <%= request.getAttribute("snapshotTime") %></p>
        </div>
        <a class="btn btn-success" href="<%= context %>/reports?format=csv<%= selectedJunctionId == null ? "" : "&junctionId=" + selectedJunctionId %>">⬇ Export CSV</a>
    </div>

    <div class="alert alert-info">
        <strong>Report scope:</strong> This page reports the current in-memory simulation state. It is not a historical daily/weekly/monthly report; historical trends require storing snapshots or events in the database.
    </div>

    <form class="panel bg-white p-3 mb-4" method="get" action="<%= context %>/reports">
        <div class="row g-3 align-items-end">
            <div class="col-md-6">
                <label for="junctionId" class="form-label fw-semibold">Filter by junction</label>
                <select class="form-select" id="junctionId" name="junctionId">
                    <option value="">All junctions</option>
                    <% if (junctions != null) { for (Junction junction : junctions) { %>
                        <option value="<%= junction.getJunctionId() %>"
                            <%= selectedJunctionId != null && selectedJunctionId == junction.getJunctionId() ? "selected" : "" %>>
                            <%= junction.getJunctionName() %>
                        </option>
                    <% } } %>
                </select>
            </div>
            <div class="col-md-auto"><button class="btn btn-primary" type="submit">Apply Filter</button></div>
            <div class="col-md-auto"><a class="btn btn-outline-secondary" href="<%= context %>/reports">Reset</a></div>
        </div>
    </form>

    <div class="row g-3 mb-4">
        <div class="col-6 col-lg-3"><div class="panel bg-white p-3 h-100"><div class="muted-label">Signals in report</div><div class="metric"><%= totalSignals %></div></div></div>
        <div class="col-6 col-lg-3"><div class="panel bg-white p-3 h-100"><div class="muted-label">Vehicles queued now</div><div class="metric"><%= request.getAttribute("totalQueue") %></div></div></div>
        <div class="col-6 col-lg-3"><div class="panel bg-white p-3 h-100"><div class="muted-label">Average waiting time</div><div class="metric"><%= request.getAttribute("averageWait") %><small class="fs-6"> sec</small></div></div></div>
        <div class="col-6 col-lg-3"><div class="panel bg-white p-3 h-100"><div class="muted-label">Maximum waiting time</div><div class="metric"><%= request.getAttribute("maxWait") %><small class="fs-6"> sec</small></div></div></div>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-lg-7">
            <div class="panel bg-white p-4 h-100">
                <h5 class="fw-bold mb-3">Signals by congestion level</h5>
                <div class="bar-row"><span>Very Low</span><div class="bar-track"><div class="bar-fill" style="width:<%= (veryLowCount * 100 / maxBar) %>%"></div></div><strong><%= veryLowCount %></strong></div>
                <div class="bar-row"><span>Low</span><div class="bar-track"><div class="bar-fill" style="width:<%= (lowCount * 100 / maxBar) %>%"></div></div><strong><%= lowCount %></strong></div>
                <div class="bar-row"><span>Medium</span><div class="bar-track"><div class="bar-fill" style="width:<%= (mediumCount * 100 / maxBar) %>%"></div></div><strong><%= mediumCount %></strong></div>
                <div class="bar-row"><span>High</span><div class="bar-track"><div class="bar-fill" style="width:<%= (highCount * 100 / maxBar) %>%"></div></div><strong><%= highCount %></strong></div>
                <div class="bar-row"><span>Congested</span><div class="bar-track"><div class="bar-fill" style="width:<%= (congestedCount * 100 / maxBar) %>%"></div></div><strong><%= congestedCount %></strong></div>
                <small class="text-muted">Queue thresholds: 0–9 Very Low, 10–15 Low, 16–25 Medium, 26–40 High, 41+ Congested.</small>
            </div>
        </div>
        <div class="col-lg-5">
            <div class="panel bg-white p-4 h-100">
                <h5 class="fw-bold mb-3">Operational summary</h5>
                <div class="d-flex justify-content-between py-2 border-bottom"><span>Active emergency signals</span><strong><%= request.getAttribute("emergencyCount") %></strong></div>
                <div class="d-flex justify-content-between py-2 border-bottom"><span>High + congested signals</span><strong><%= highCount + congestedCount %></strong></div>
                <div class="d-flex justify-content-between py-2"><span>Signals without queue</span><strong><%= reportRows == null ? 0 : reportRows.stream().filter(r -> ((Number) r.get("vehicleCount")).intValue() == 0).count() %></strong></div>
            </div>
        </div>
    </div>

    <section class="panel bg-white p-3">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 p-2">
            <h5 class="fw-bold mb-0">Signal-level details</h5>
            <span class="text-muted small">Current values only</span>
        </div>
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead><tr><th>Junction</th><th>Signal</th><th>Direction</th><th>Queued vehicles</th><th>Waiting (sec)</th><th>Congestion</th><th>Emergency</th><th>Action</th></tr></thead>
                <tbody>
                <% if (reportRows != null && !reportRows.isEmpty()) {
                    for (Map<String, Object> row : reportRows) {
                        String level = String.valueOf(row.get("congestionLevel"));
                        String levelClass = "level-" + level.toLowerCase().replace(" ", "-");
                %>
                    <tr>
                        <td><%= row.get("junctionName") %></td>
                        <td>#<%= row.get("signalId") %></td>
                        <td><%= row.get("direction") %></td>
                        <td><strong><%= row.get("vehicleCount") %></strong></td>
                        <td><%= row.get("waitingTime") %></td>
                        <td><span class="level <%= levelClass %>"><%= level %></span></td>
                        <td><%= Boolean.TRUE.equals(row.get("emergency")) ? "🚨 Active" : "—" %></td>
                        <td><a class="btn btn-sm btn-outline-primary" href="<%= context %>/simulation?junctionId=<%= row.get("junctionId") %>">Open simulation</a></td>
                    </tr>
                <% } } else { %>
                    <tr><td colspan="8" class="text-center text-muted py-5">No signals found for this filter.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</main>
</body>
</html>
