<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.trafficiq.dao.JunctionDAO" %>
<%@ page import="com.trafficiq.dao.SignalDAO" %>
<%@ page import="com.trafficiq.model.Junction" %>
<%@ page import="com.trafficiq.model.Signal" %>
<%@ page import="com.trafficiq.model.User" %>

<%
    JunctionDAO junctionDAO = new JunctionDAO();
    SignalDAO signalDAO = new SignalDAO();

    List<Junction> junctionList =
            (List<Junction>) request.getAttribute("junctionList");

    if (junctionList == null) {
        junctionList = junctionDAO.getAllJunctions();
    }

    Number congestedValue =
            (Number) request.getAttribute("congestedCount");

    Number emergencyValue =
            (Number) request.getAttribute("emergencyCount");

    int congestedCount =
            congestedValue == null ? 0 : congestedValue.intValue();

    int emergencyCount =
            emergencyValue == null ? 0 : emergencyValue.intValue();

    User loggedUser = (User) session.getAttribute("loggedUser");

    boolean isAdmin = loggedUser != null
            && loggedUser.getRole() != null
            && loggedUser.getRole().equalsIgnoreCase("ADMIN");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>TrafficIQ Dashboard</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <style>
        body {
            background: #f4f6f9;
        }

        .tiq-navbar { min-height:76px; padding:15px 5%; background:#101318; color:#fff; display:flex; align-items:center; justify-content:space-between; gap:18px; flex-wrap:wrap; box-shadow:0 4px 18px rgba(0,0,0,.12); }
        .tiq-brand { display:flex; align-items:center; gap:12px; color:#fff; font-size:23px; font-weight:750; letter-spacing:-.6px; text-decoration:none; }
        .tiq-brand-icon { width:42px; height:42px; display:flex; align-items:center; justify-content:center; border-radius:12px; background:#252a33; font-size:22px; }
        .tiq-brand span { color:#b8c0cc; }
        .tiq-nav-actions { display:flex; align-items:center; gap:10px; flex-wrap:wrap; }
        .tiq-nav-btn { min-height:42px; padding:11px 17px; display:inline-flex; align-items:center; justify-content:center; gap:8px; border:1px solid #414753; border-radius:9px; background:#111827; color:#fff; text-decoration:none; font:inherit; font-size:13px; font-weight:650; cursor:pointer; transition:background .2s,transform .2s,box-shadow .2s; }
        .tiq-nav-btn:hover { background:#000; color:#fff; transform:translateY(-1px); box-shadow:0 5px 12px rgba(0,0,0,.16); }
        @media(max-width:600px) { .tiq-navbar { padding:14px 4%; } .tiq-brand { font-size:20px; } }

        .dashboard-main { width:min(1500px,94%); margin:30px auto 50px!important; }
        .dashboard-title { font-size:clamp(27px,3vw,34px); letter-spacing:-.7px; }
        .dashboard-nav-user { color:#d1d5db; font-size:14px; }

        .dashboard-title {
            font-weight: 700;
            margin-bottom: 30px;
        }

        .overview-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            height: 100%;
        }

        .overview-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
        }

        .dashboard-card-link {
            display: block;
            height: 100%;
            color: inherit;
            text-decoration: none;
            border-radius: 16px;
        }

        .dashboard-card-link:focus-visible {
            outline: 3px solid #0d6efd;
            outline-offset: 4px;
        }

        .overview-icon {
            font-size: 30px;
            margin-bottom: 10px;
        }

        .overview-title {
            font-size: 15px;
            color: #6c757d;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .overview-value {
            font-size: 42px;
            font-weight: bold;
            margin-top: 10px;
        }

        .section-title {
            font-weight: 700;
            margin-top: 45px;
            margin-bottom: 20px;
        }

        .junction-card {
            border: none;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        }

        .junction-table {
            margin-bottom: 0;
        }

        .junction-table thead {
            background: #212529;
            color: white;
        }

        .junction-table th {
            padding: 16px;
        }

        .junction-table td {
            padding: 16px;
            vertical-align: middle;
        }

        .status-normal {
            display: inline-block;
            background: #d1e7dd;
            color: #146c43;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }

        .management-card {
            border: none;
            border-radius: 18px;
            height: 100%;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .management-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 28px rgba(0, 0, 0, 0.13);
        }

        .management-icon {
            font-size: 42px;
            margin-bottom: 15px;
        }

        .management-card h4 {
            font-weight: 700;
        }

        .empty-state {
            padding: 40px;
            text-align: center;
            color: #6c757d;
        }
    </style>
</head>

<body>

<nav class="tiq-navbar">
    <a class="tiq-brand" href="<%= request.getContextPath() %>/dashboard" style="color:#fff;text-decoration:none">
        <span class="tiq-brand-icon">&#128678;</span>
        <span style="color:#fff">Traffic<span>IQ</span></span>
    </a>
    <div class="tiq-nav-actions">
        <% if (loggedUser != null) { %>
            <span class="dashboard-nav-user">Welcome, <%= loggedUser.getUsername() %></span>
        <% } %>
        <form method="post" action="<%= request.getContextPath() %>/logout" class="m-0">
            <button type="submit" class="tiq-nav-btn">Logout &#8594;</button>
        </form>
    </div>
</nav>

<div class="container dashboard-main mt-4 mb-5">

    <h1 class="dashboard-title">Dashboard</h1>

    <!-- SYSTEM OVERVIEW -->
    <div class="row g-4">

        <!-- TOTAL JUNCTIONS -->
        <div class="col-md-4">
            <div class="card overview-card text-center">
                <div class="card-body py-4">
                    <div class="overview-icon">🛣️</div>
                    <div class="overview-title">Junctions</div>
                    <div class="overview-value text-primary">
                        <%= request.getAttribute("totalJunctions") == null
                                ? 0 : request.getAttribute("totalJunctions") %>
                    </div>
                </div>
            </div>
        </div>

        <!-- CONGESTED -->
        <div class="col-md-4">
            <a class="dashboard-card-link"
               href="<%= request.getContextPath() %>/congestion"
               aria-label="Open congestion panel">
                <div class="card overview-card text-center">
                    <div class="card-body py-4">
                        <div class="overview-icon">⚠️</div>
                        <div class="overview-title">Congested</div>
                        <div class="overview-value text-warning">
                            <%= congestedCount %>
                        </div>
                        <div class="text-muted small mt-2">
                            View congested signals →
                        </div>
                    </div>
                </div>
            </a>
        </div>

        <!-- EMERGENCY -->
        <div class="col-md-4">
            <a class="dashboard-card-link"
               href="<%= request.getContextPath() %>/emergencies"
               aria-label="Open emergency panel">
                <div class="card overview-card text-center">
                    <div class="card-body py-4">
                        <div class="overview-icon">🚨</div>
                        <div class="overview-title">Emergency</div>
                        <div class="overview-value text-success"
                             style="font-size: 30px;">
                            <%= emergencyCount == 0 ? "NONE" : emergencyCount %>
                        </div>
                        <div class="text-muted small mt-2">
                            View emergency signals →
                        </div>
                    </div>
                </div>
            </a>
        </div>

    </div>

    <!-- JUNCTION STATUS -->
    <h3 class="section-title">Junction Status</h3>

    <div class="card junction-card">
        <div class="table-responsive">
            <table class="table table-hover junction-table">
                <thead>
                <tr>
                    <th>Junction</th>
                    <th>Signals</th>
                    <th>Status</th>
                    <th class="text-end">Actions</th>
                </tr>
                </thead>

                <tbody>
                <%
                    if (junctionList != null && !junctionList.isEmpty()) {
                        for (Junction junction : junctionList) {
                            List<Signal> signals =
                                    signalDAO.getSignalsByJunction(
                                            junction.getJunctionId());

                            int signalCount =
                                    signals != null ? signals.size() : 0;
                %>
                    <tr>
                        <td>
                            <strong><%= junction.getJunctionName() %></strong>
                        </td>

                        <td>🚦 <%= signalCount %></td>

                        <td>
                            <span class="status-normal">🟢 Normal</span>
                        </td>

                        <td class="text-end">
                            <a href="<%= request.getContextPath() %>/junctions"
                               class="btn btn-sm btn-outline-primary">
                                Manage
                            </a>

                            <a href="<%= request.getContextPath() %>/simulation?junctionId=<%= junction.getJunctionId() %>"
                               class="btn btn-sm btn-success">
                                Simulate
                            </a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="4" class="empty-state">
                            No junctions available.
                            <br><br>
                            <a href="<%= request.getContextPath() %>/junctions"
                               class="btn btn-primary">
                                Add Your First Junction
                            </a>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- SYSTEM MANAGEMENT -->
    <h3 class="section-title">System Management</h3>

    <div class="row g-4">

        <!-- JUNCTION MANAGEMENT -->
        <div class="col-md-4">
            <div class="card management-card">
                <div class="card-body p-4">
                    <div class="management-icon">🛣️</div>
                    <h4>Junction Management</h4>
                    <p class="text-muted mt-3">
                        Create and manage junctions. Add, edit and organize
                        all signals directly under their respective junction.
                    </p>
                    <a href="<%= request.getContextPath() %>/junctions"
                       class="btn btn-primary mt-2">
                        Manage →
                    </a>
                </div>
            </div>
        </div>

        <!-- TRAFFIC SIMULATION -->
        <div class="col-md-4">
            <div class="card management-card">
                <div class="card-body p-4">
                    <div class="management-icon">🚦</div>
                    <h4>Traffic Simulation</h4>
                    <p class="text-muted mt-3">
                        Select a junction and simulate its traffic signals,
                        timing and traffic conditions.
                    </p>
                    <a href="<%= request.getContextPath() %>/simulation"
                       class="btn btn-success mt-2">
                        Simulate →
                    </a>
                </div>
            </div>
        </div>

        <!-- TRAFFIC REPORTS -->
        <div class="col-md-4">
            <div class="card management-card">
                <div class="card-body p-4">
                    <div class="management-icon">📊</div>
                    <h4>Traffic Reports</h4>
                    <p class="text-muted mt-3">
                        Review a live snapshot of signal queues, waiting
                        times, congestion levels and emergency activity.
                        Export the current report as CSV.
                    </p>
                    <a href="<%= request.getContextPath() %>/reports"
                       class="btn btn-dark mt-2">
                        View Reports →
                    </a>
                </div>
            </div>
        </div>

        <!-- ADMIN USER MANAGEMENT -->
        <% if (isAdmin) { %>
        <div class="col-md-4">
            <div class="card management-card">
                <div class="card-body p-4">
                    <div class="management-icon">👥</div>
                    <h4>User Management</h4>
                    <p class="text-muted mt-3">
                        Create Operator accounts and review registered users.
                        Only administrators can access this feature.
                    </p>
                    <a href="<%= request.getContextPath() %>/admin/users"
                       class="btn btn-primary mt-2">
                        Manage Users →
                    </a>
                </div>
            </div>
        </div>
        <% } %>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>