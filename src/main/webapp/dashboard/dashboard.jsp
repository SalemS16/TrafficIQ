<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="com.trafficiq.dao.JunctionDAO" %>
<%@ page import="com.trafficiq.dao.SignalDAO" %>
<%@ page import="com.trafficiq.model.Junction" %>
<%@ page import="com.trafficiq.model.Signal" %>

<%
    JunctionDAO junctionDAO = new JunctionDAO();
    SignalDAO signalDAO = new SignalDAO();

    List<Junction> junctionList =
            (List<Junction>) request.getAttribute("junctionList");
    if (junctionList == null) {
        junctionList = junctionDAO.getAllJunctions();
    }

    Number congestedValue = (Number) request.getAttribute("congestedCount");
    Number emergencyValue = (Number) request.getAttribute("emergencyCount");
    int congestedCount = congestedValue == null ? 0 : congestedValue.intValue();
    int emergencyCount = emergencyValue == null ? 0 : emergencyValue.intValue();
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>TrafficIQ Dashboard</title>

    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet">

    <style>

        body {
            background: #f4f6f9;
        }


        /* =========================
           DASHBOARD HEADER
        ========================= */

        .dashboard-title {
            font-weight: 700;
            margin-bottom: 30px;
        }


        /* =========================
           OVERVIEW CARDS
        ========================= */

        .overview-card {

            border: none;

            border-radius: 16px;

            box-shadow:
                    0 4px 15px rgba(0, 0, 0, 0.08);

            transition:
                    transform 0.2s ease,
                    box-shadow 0.2s ease;

            height: 100%;
        }

        .overview-card:hover {

            transform: translateY(-4px);

            box-shadow:
                    0 8px 25px rgba(0, 0, 0, 0.12);
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


        /* =========================
           SECTION TITLE
        ========================= */

        .section-title {

            font-weight: 700;

            margin-top: 45px;

            margin-bottom: 20px;
        }


        /* =========================
           JUNCTION STATUS
        ========================= */

        .junction-card {

            border: none;

            border-radius: 16px;

            overflow: hidden;

            box-shadow:
                    0 4px 15px rgba(0, 0, 0, 0.08);
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


        /* =========================
           MANAGEMENT CARDS
        ========================= */

        .management-card {

            border: none;

            border-radius: 18px;

            height: 100%;

            box-shadow:
                    0 4px 15px rgba(0, 0, 0, 0.08);

            transition:
                    transform 0.2s ease,
                    box-shadow 0.2s ease;
        }


        .management-card:hover {

            transform: translateY(-5px);

            box-shadow:
                    0 10px 28px rgba(0, 0, 0, 0.13);
        }


        .management-icon {

            font-size: 42px;

            margin-bottom: 15px;
        }


        .management-card h4 {

            font-weight: 700;
        }


        /* =========================
           EMPTY STATE
        ========================= */

        .empty-state {

            padding: 40px;

            text-align: center;

            color: #6c757d;
        }

    </style>

</head>


<body>


<!-- =========================
     NAVBAR
========================= -->

<nav class="navbar navbar-dark bg-dark">

    <div class="container-fluid px-4">

        <span class="navbar-brand mb-0 h1">

            🚦 TrafficIQ

        </span>


        <a href="<%= request.getContextPath() %>/logout"
           class="btn btn-outline-light">

            Logout

        </a>

    </div>

</nav>



<div class="container mt-4 mb-5">


    <!-- =========================
         DASHBOARD TITLE
    ========================= -->

    <h1 class="dashboard-title">

        Dashboard

    </h1>



    <!-- =========================
         SYSTEM OVERVIEW
    ========================= -->

    <div class="row g-4">


        <!-- TOTAL JUNCTIONS -->

        <div class="col-md-4">

            <div class="card overview-card text-center">

                <div class="card-body py-4">

                    <div class="overview-icon">

                        🛣️

                    </div>


                    <div class="overview-title">

                        Junctions

                    </div>


                    <div class="overview-value text-primary">

                        <%= request.getAttribute("totalJunctions") %>

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

                        <div class="text-muted small mt-2">View congested signals →</div>

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

                        <div class="overview-value text-success" style="font-size: 30px;">
                            <%= emergencyCount == 0 ? "NONE" : emergencyCount %>
                        </div>

                        <div class="text-muted small mt-2">View emergency signals →</div>

                    </div>

                </div>

            </a>

        </div>

    </div>



    <!-- =========================
         JUNCTION STATUS
    ========================= -->

    <h3 class="section-title">

        Junction Status

    </h3>


    <div class="card junction-card">


        <div class="table-responsive">

            <table class="table table-hover junction-table">


                <thead>

                <tr>

                    <th>
                        Junction
                    </th>


                    <th>
                        Signals
                    </th>


                    <th>
                        Status
                    </th>


                    <th class="text-end">
                        Actions
                    </th>

                </tr>

                </thead>


                <tbody>


<%
    if (junctionList != null && !junctionList.isEmpty()) {

        for (Junction junction : junctionList) {

            List<Signal> signals =
                    signalDAO.getSignalsByJunction(
                            junction.getJunctionId()
                    );

            int signalCount =
                    signals != null
                            ? signals.size()
                            : 0;
%>


                <tr>


                    <!-- JUNCTION NAME -->

                    <td>

                        <strong>

                            <%= junction.getJunctionName() %>

                        </strong>

                    </td>



                    <!-- SIGNAL COUNT -->

                    <td>

                        🚦 <%= signalCount %>

                    </td>



                    <!-- STATUS -->

                    <td>

                        <span class="status-normal">

                            🟢 Normal

                        </span>

                    </td>



                    <!-- ACTIONS -->

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

                    <td colspan="4"
                        class="empty-state">

                        No junctions available.

                        <br><br>

                        <a href="<%= request.getContextPath() %>/junctions"
                           class="btn btn-primary">

                            Add Your First Junction

                        </a>

                    </td>

                </tr>


<%
    }
%>


                </tbody>

            </table>

        </div>

    </div>



    <!-- =========================
         SYSTEM MANAGEMENT
    ========================= -->

    <h3 class="section-title">

        System Management

    </h3>


    <div class="row g-4">


        <!-- JUNCTION MANAGEMENT -->

        <div class="col-md-4">

            <div class="card management-card">

                <div class="card-body p-4">


                    <div class="management-icon">

                        🛣️

                    </div>


                    <h4>

                        Junction Management

                    </h4>


                    <p class="text-muted mt-3">

                        Create and manage junctions.
                        Add, edit and organize all signals
                        directly under their respective junction.

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


                    <div class="management-icon">

                        🚦

                    </div>


                    <h4>

                        Traffic Simulation

                    </h4>


                    <p class="text-muted mt-3">

                        Select a junction and simulate its
                        traffic signals, timing and traffic
                        conditions.

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
                        Review a live snapshot of signal queues, waiting times,
                        congestion levels and emergency activity. Export the current
                        report as CSV.
                    </p>
                    <a href="<%= request.getContextPath() %>/reports"
                       class="btn btn-dark mt-2">
                        View Reports →
                    </a>
                </div>
            </div>
        </div>


    </div>


</div>


</body>

</html>
