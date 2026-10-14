<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="com.trafficiq.model.Junction" %>
<%@ page import="com.trafficiq.model.Signal" %>

<%
    Junction junction =
            (Junction) request.getAttribute("junction");

    List<Signal> signalList =
            (List<Signal>) request.getAttribute("signalList");
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>
        <%= junction.getJunctionName() %> - TrafficIQ
    </title>

    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet">

    <style>
        body { background:#f3f5f9; color:#172033; font-family:"Segoe UI",Arial,sans-serif; }
        .tiq-navbar { min-height:76px; padding:15px 5%; background:#101318; color:#fff; display:flex; align-items:center; justify-content:space-between; gap:18px; flex-wrap:wrap; box-shadow:0 4px 18px rgba(0,0,0,.12); }
        .tiq-brand { display:flex; align-items:center; gap:12px; color:#fff; font-size:23px; font-weight:750; letter-spacing:-.6px; text-decoration:none; }
        .tiq-brand-icon { width:42px; height:42px; display:flex; align-items:center; justify-content:center; border-radius:12px; background:#252a33; font-size:22px; }
        .tiq-brand span { color:#b8c0cc; }
        .tiq-nav-actions { display:flex; align-items:center; gap:10px; flex-wrap:wrap; }
        .tiq-nav-btn { min-height:42px; padding:11px 17px; display:inline-flex; align-items:center; justify-content:center; gap:8px; border:1px solid #414753; border-radius:9px; background:#111827; color:#fff; text-decoration:none; font:inherit; font-size:13px; font-weight:650; cursor:pointer; transition:background .2s,transform .2s,box-shadow .2s; }
        .tiq-nav-btn:hover { background:#000; color:#fff; transform:translateY(-1px); box-shadow:0 5px 12px rgba(0,0,0,.16); }
        .junction-main { width:min(1500px,94%); margin:30px auto 50px; }
        .junction-header { background:#fff; border:1px solid #e6eaf0; border-radius:16px; padding:25px; box-shadow:0 4px 15px rgba(0,0,0,.07); }
        .signal-count { font-size:13px; padding:8px 12px; border-radius:9px; }
        .action-buttons { display:flex; gap:8px; flex-wrap:wrap; }
        .section-title { font-weight:750; letter-spacing:-.5px; }
        .signal-card { overflow:hidden; border:0; border-radius:16px; box-shadow:0 4px 15px rgba(0,0,0,.07); }
        .table thead th { background:#212529; color:white; white-space:nowrap; }
        .table td { vertical-align:middle; }
        .junction-status { font-size:12px; font-weight:700; padding:6px 10px; border-radius:8px; }
        .junction-footer { padding:22px 10px 0; color:#94a3b8; text-align:center; font-size:12px; }
        @media(max-width:600px) { .tiq-navbar { padding:14px 4%; } .tiq-brand { font-size:20px; } .junction-main { width:94%; margin-top:22px; } .junction-header { padding:19px; } }
    </style>

</head>


<body class="bg-light">


<!-- NAVBAR -->

<nav class="tiq-navbar">
    <a class="tiq-brand" href="<%= request.getContextPath() %>/dashboard">
        <span class="tiq-brand-icon" aria-hidden="true">&#128678;</span>
        <span style="color:#fff">Traffic<span>IQ</span></span>
    </a>
    <div class="tiq-nav-actions">
        <a class="tiq-nav-btn" href="<%= request.getContextPath() %>/junctions">&#8592; Back to Junctions</a>
    </div>
</nav>



<main class="junction-main">


    <!-- JUNCTION HEADER -->

    <div class="junction-header mb-4">


        <div class="d-flex justify-content-between
                    align-items-start flex-wrap gap-3">


            <!-- JUNCTION DETAILS -->

            <div>

                <h2 class="section-title mb-1">

                    🚦 <%= junction.getJunctionName() %>

                </h2>


                <p class="text-muted mb-2">

                    📍 <%= junction.getArea() %>

                </p>


                <%
                    if ("ACTIVE".equalsIgnoreCase(
                            junction.getStatus())) {
                %>

                    <span class="badge bg-success junction-status">

                        ACTIVE

                    </span>

                <%
                    } else {
                %>

                    <span class="badge bg-secondary junction-status">

                        INACTIVE

                    </span>

                <%
                    }
                %>

            </div>



            <!-- JUNCTION ACTIONS -->

            <div class="action-buttons">


                <a href="<%= request.getContextPath() %>/editJunction?id=<%= junction.getJunctionId() %>"
                   class="btn btn-warning">

                    ✏ Edit Junction

                </a>


                <a href="<%= request.getContextPath() %>/showAddSignal?junctionId=<%= junction.getJunctionId() %>"
                   class="btn btn-primary">

                    + Add Signal

                </a>


                <a href="<%= request.getContextPath() %>/deleteJunction?id=<%= junction.getJunctionId() %>"
                   class="btn btn-danger"
                   onclick="return confirm(
                       'Are you sure you want to delete this junction and all its related signals?'
                   );">

                    🗑 Delete Junction

                </a>


            </div>


        </div>

    </div>



    <!-- SIGNAL SECTION HEADER -->

    <div class="d-flex justify-content-between
                align-items-center mb-3">


        <div>

            <h3 class="section-title mb-0">

                🚦 Signals

            </h3>

            <small class="text-muted">

                Manage traffic signals for this junction

            </small>

        </div>


        <div>

            <span class="badge bg-dark signal-count">

                <%
                    int signalCount =
                            signalList != null
                                    ? signalList.size()
                                    : 0;
                %>

                <%= signalCount %> Signal<%= signalCount != 1 ? "s" : "" %>

            </span>

        </div>


    </div>



    <!-- SIGNAL TABLE -->

    <div class="card signal-card">


        <div class="card-body p-0">


            <div class="table-responsive">


                <table class="table table-hover mb-0 align-middle">


                    <thead class="table-dark">

                    <tr>

                        <th class="ps-3">

                            Direction

                        </th>


                        <th>

                            Green

                        </th>


                        <th>

                            Yellow

                        </th>


                        <th>

                            Red

                        </th>


                        <th>

                            Status

                        </th>


                        <th>

                            Actions

                        </th>

                    </tr>

                    </thead>



                    <tbody>


<%
    if (signalList != null && !signalList.isEmpty()) {

        for (Signal signal : signalList) {
%>


                    <tr>


                        <!-- DIRECTION -->

                        <td class="ps-3">

                            <strong>

                                <%= signal.getDirection() %>

                            </strong>

                        </td>



                        <!-- GREEN -->

                        <td>

                            <span class="badge bg-success">

                                🟢 <%= signal.getGreenTime() %>s

                            </span>

                        </td>



                        <!-- YELLOW -->

                        <td>

                            <span class="badge bg-warning text-dark">

                                🟡 <%= signal.getYellowTime() %>s

                            </span>

                        </td>



                        <!-- RED -->

                        <td>

                            <span class="badge bg-danger">

                                🔴 <%= signal.getRedTime() %>s

                            </span>

                        </td>



                        <!-- STATUS -->

                        <td>

<%
    if (signal.isActive()) {
%>

                            <span class="badge bg-success">

                                ACTIVE

                            </span>

<%
    } else {
%>

                            <span class="badge bg-secondary">

                                INACTIVE

                            </span>

<%
    }
%>

                        </td>



                        <!-- ACTIONS -->

                        <td>


                            <a href="<%= request.getContextPath() %>/editSignal?id=<%= signal.getSignalId() %>&junctionId=<%= junction.getJunctionId() %>"
                               class="btn btn-warning btn-sm">

                                ✏ Edit

                            </a>


                            <a href="<%= request.getContextPath() %>/deleteSignal?id=<%= signal.getSignalId() %>&junctionId=<%= junction.getJunctionId() %>"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm(
                                   'Are you sure you want to delete this signal?'
                               );">

                                🗑 Delete

                            </a>


                        </td>


                    </tr>


<%
        }

    } else {
%>


                    <tr>

                        <td colspan="6"
                            class="text-center p-5">


                            <h5 class="mb-2">

                                No Signals Added Yet

                            </h5>


                            <p class="text-muted">

                                Add traffic signals to
                                <strong>

                                    <%= junction.getJunctionName() %>

                                </strong>
                                to configure this junction.

                            </p>


                            <a href="<%= request.getContextPath() %>/showAddSignal?junctionId=<%= junction.getJunctionId() %>"
                               class="btn btn-primary">

                                + Add First Signal

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

    </div>


    <div class="junction-footer">TrafficIQ &bull; Smart Traffic Signal Optimization</div>
</main>

</body>

</html>
