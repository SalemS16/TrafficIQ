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

    <title>
        <%= junction.getJunctionName() %> - TrafficIQ
    </title>

    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet">

    <style>

        .junction-header {
            background: white;
            border-radius: 12px;
            padding: 25px;
        }

        .signal-count {
            font-size: 14px;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

    </style>

</head>


<body class="bg-light">


<!-- NAVBAR -->

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



<div class="container mt-5">


    <!-- BACK -->

    <div class="mb-3">

        <a href="<%= request.getContextPath() %>/junctions"
           class="text-decoration-none">

            ← Back to Junctions

        </a>

    </div>



    <!-- JUNCTION HEADER -->

    <div class="junction-header shadow-sm mb-4">


        <div class="d-flex justify-content-between
                    align-items-start flex-wrap gap-3">


            <!-- JUNCTION DETAILS -->

            <div>

                <h2 class="mb-1">

                    🚦 <%= junction.getJunctionName() %>

                </h2>


                <p class="text-muted mb-2">

                    📍 <%= junction.getArea() %>

                </p>


                <%
                    if ("ACTIVE".equalsIgnoreCase(
                            junction.getStatus())) {
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

            <h3 class="mb-0">

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

    <div class="card shadow-sm border-0">


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


</div>


</body>

</html>
