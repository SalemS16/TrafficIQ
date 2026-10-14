<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%@ page import="com.trafficiq.model.Junction" %>
<%@ page import="com.trafficiq.model.Signal" %>
<%@ page import="com.trafficiq.model.TrafficState" %>


<%
    List<Junction> junctionList =
            (List<Junction>)
                    request.getAttribute(
                            "junctionList"
                    );


    List<Signal> signals =
            (List<Signal>)
                    request.getAttribute(
                            "signals"
                    );


    Map<Integer, TrafficState> trafficStates =
            (Map<Integer, TrafficState>)
                    request.getAttribute(
                            "trafficStates"
                    );


    Integer selectedJunctionId =
            (Integer)
                    request.getAttribute(
                            "selectedJunctionId"
                    );


    Boolean globalRunning =
            (Boolean)
                    request.getAttribute(
                            "globalRunning"
                    );


    Boolean junctionPaused =
            (Boolean)
                    request.getAttribute(
                            "junctionPaused"
                    );
%>


<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0"
    >

    <title>
        TrafficIQ - Traffic Simulation
    </title>


    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet"
    >


    <!-- Existing simulation stylesheet retained -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/simulation.css?v=12">
    <style>

        .tiq-navbar { min-height:76px; padding:15px 5%; background:#101318; color:#fff; display:flex; align-items:center; justify-content:space-between; gap:18px; flex-wrap:wrap; box-shadow:0 4px 18px rgba(0,0,0,.12); }
        .tiq-brand { display:flex; align-items:center; gap:12px; color:#fff; font-size:23px; font-weight:750; letter-spacing:-.6px; text-decoration:none; }
        .tiq-brand-icon { width:42px; height:42px; display:flex; align-items:center; justify-content:center; border-radius:12px; background:#252a33; font-size:22px; }
        .tiq-brand span { color:#b8c0cc; }
        .tiq-nav-actions { display:flex; align-items:center; gap:10px; flex-wrap:wrap; }
        .tiq-nav-btn { min-height:42px; padding:11px 17px; display:inline-flex; align-items:center; justify-content:center; gap:8px; border:1px solid #414753; border-radius:9px; background:#111827; color:#fff; text-decoration:none; font:inherit; font-size:13px; font-weight:650; cursor:pointer; transition:background .2s,transform .2s,box-shadow .2s; }
        .tiq-nav-btn:hover { background:#000; color:#fff; transform:translateY(-1px); box-shadow:0 5px 12px rgba(0,0,0,.16); }
        @media(max-width:600px) { .tiq-navbar { padding:14px 4%; } .tiq-brand { font-size:20px; } }

        body { font-family:"Segoe UI",Arial,sans-serif; }
        .simulation-page-title { font-weight:750; letter-spacing:-.6px; color:#111827; }
        .simulation-main { width:94%; max-width:1700px; margin:30px auto 48px; }
        @media(max-width:600px) { .simulation-main { width:94%; padding-left:0!important; padding-right:0!important; } }
    </style>

</head>


<body class="bg-light">


<!-- =====================================================
     NAVBAR
===================================================== -->

<nav class="tiq-navbar">
    <a class="tiq-brand" href="<%= request.getContextPath() %>/dashboard" style="color:#fff;text-decoration:none">
        <span class="tiq-brand-icon">&#128678;</span>
        <span style="color:#fff">Traffic<span>IQ</span></span>
    </a>
    <div class="tiq-nav-actions">
        <a href="<%= request.getContextPath() %>/dashboard" class="tiq-nav-btn">&#8592; Back to Dashboard</a>
    </div>
</nav>


<!-- =====================================================
     MAIN CONTAINER
===================================================== -->

<div class="container-fluid px-4 mt-4 simulation-main">


    <h2 class="mb-4 simulation-page-title">

        Traffic Simulation

    </h2>


    <!-- =================================================
         GLOBAL CONTROLS
    ================================================== -->

    <div class="card mb-4">

        <div class="card-body">

            <div
                    class="d-flex justify-content-between align-items-center flex-wrap gap-3"
            >


                <div>

                    <h5 class="mb-2">

                        Simulation Control

                    </h5>


                    <span
                            id="globalStatus"
                            class="badge bg-secondary"
                    >

                        STOPPED

                    </span>

                </div>


                <div class="d-flex gap-2">


                    <button
                            type="button"
                            id="startAllButton"
                            class="btn btn-success"
                    >

                        ▶ Start All

                    </button>


                    <button
                            type="button"
                            id="stopAllButton"
                            class="btn btn-danger"
                    >

                        ■ Stop All

                    </button>

                </div>

            </div>

        </div>

    </div>


    <!-- =================================================
         JUNCTION SELECTION
    ================================================== -->

    <div class="card mb-4">

        <div class="card-body">


            <form
                    method="get"
                    action="<%= request.getContextPath() %>/simulation"
            >


                <div class="row align-items-end g-3">


                    <div class="col-md-9">

                        <label class="form-label">

                            Select Junction

                        </label>


                        <select
                                name="junctionId"
                                class="form-select"
                                required
                        >


                            <option value="">

                                -- Select Junction --

                            </option>


                            <%
                                if (junctionList != null) {

                                    for (Junction junction :
                                            junctionList) {

                                        boolean selected =
                                                selectedJunctionId != null &&
                                                selectedJunctionId ==
                                                        junction.getJunctionId();
                            %>


                            <option
                                    value="<%= junction.getJunctionId() %>"
                                    <%= selected
                                            ? "selected"
                                            : "" %>
                            >

                                <%= junction.getJunctionName() %>

                            </option>


                            <%
                                    }
                                }
                            %>


                        </select>

                    </div>


                    <div class="col-md-3">

                        <button
                                type="submit"
                                class="btn btn-primary w-100"
                        >

                            Load Junction

                        </button>

                    </div>


                </div>

            </form>

        </div>

    </div>


    <%
        if (
                signals != null &&
                !signals.isEmpty()
        ) {
    %>


    <!-- =================================================
         SIMULATION CARD
    ================================================== -->

    <div class="card simulation-card mb-5">

        <div class="card-body">


            <!-- HEADER -->

            <div
                    class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4"
            >


                <div>

                    <h4 class="mb-2">

                        Junction Simulation

                    </h4>


                    <span
                            id="junctionStatus"
                            class="badge bg-secondary"
                    >

                        STOPPED

                    </span>

                </div>


                <!-- INDIVIDUAL PAUSE -->

                <div class="d-flex gap-2">


                    <button
                            type="button"
                            id="pauseJunctionButton"
                            class="btn btn-warning"
                    >

                        ⏸ Pause Junction

                    </button>


                    <button
                            type="button"
                            id="resumeJunctionButton"
                            class="btn btn-success"
                            style="display:none;"
                    >

                        ▶ Resume Junction

                    </button>

                </div>

            </div>


            <!-- =================================================
                 ADAPTIVE TIMING AND EMERGENCY PRIORITY
            ================================================== -->

            <div class="row g-3 mb-4">
                <div class="col-lg-5">
                    <div class="border rounded p-3 h-100">
                        <h5 class="mb-3">🚑 Emergency Vehicle Priority</h5>
                        <label for="emergencySignalSelect" class="form-label">Emergency approach</label>
                        <select id="emergencySignalSelect" class="form-select mb-2">
                            <option value="">Select emergency approach</option>
                        </select>
                        <div class="d-flex flex-wrap gap-2">
                            <button type="button" id="emergencyOnButton" class="btn btn-danger">
                                Activate Emergency
                            </button>
                            <button type="button" id="emergencyOffButton" class="btn btn-outline-secondary">
                                Clear Emergency
                            </button>
                        </div>
                        <div class="mt-3">Emergency status: <span id="emergencyStatus" class="badge bg-secondary">INACTIVE</span></div>
                        <div id="emergencyMessage" class="small mt-2" aria-live="polite"></div>
                    </div>
                </div>
                <div class="col-lg-7">
                    <div class="border rounded p-3 h-100">
                        <h5 class="mb-3">📊 Adaptive Signal Timing</h5>
                        <div class="row g-3">
                            <div class="col-sm-6">
                                <div class="text-muted small">Current green duration</div>
                                <strong id="adaptiveGreenDuration">0 s</strong>
                            </div>
                            <div class="col-sm-6">
                                <div class="text-muted small">Time-of-day traffic period</div>
                                <strong id="trafficPeriod">—</strong>
                            </div>
                        </div>
                        <p class="text-muted small mt-3 mb-0">
                            Green duration is adjusted by the backend using simulated queue length and waiting time.
                        </p>
                    </div>
                </div>
            </div>

            <!-- =================================================
                 JUNCTION AREA
            ================================================== -->

            <!-- Emergency alert shared by all approaches -->
            <div id="emergencyAlertBanner"
                 class="alert alert-danger d-none mb-3"
                 role="status"
                 aria-live="polite">
                <strong id="emergencyAlertTitle">EMERGENCY PRIORITY ACTIVE</strong>
                <div id="emergencyAlertMessage">Emergency vehicle approaching. Other approaches must remain stopped.</div>
            </div>

            <div class="junction-area">

                <!-- REAL-WORLD CLOCK -->
                <div class="simulation-clock-corner">
                    <small>Local Time</small>
                    <strong id="simulationClock">--:--:--</strong>
                </div>

                <!-- DYNAMIC ROADS -->

                <div id="dynamicRoads"></div>


                <!-- CENTER DIVIDER -->

                <div class="junction-divider"></div>


                <!-- CENTER JUNCTION -->

                <div class="junction-center">

                    <div class="junction-icon">

                        🚦

                    </div>


                    <span>

                        JUNCTION

                    </span>

                </div>


                <!-- =================================================
                     SIGNAL BOXES
                ================================================== -->

                <%

                    for (Signal signal : signals) {


                        TrafficState trafficState =
                                null;


                        if (trafficStates != null) {

                            trafficState =
                                    trafficStates.get(
                                            signal.getSignalId()
                                    );
                        }


                        int vehicleCount =
                                trafficState != null
                                        ? trafficState.getVehicleCount()
                                        : 10;


                        int waitingTime =
                                trafficState != null
                                        ? trafficState.getWaitingTime()
                                        : 0;


                        int vehiclesPassed =
                                trafficState != null
                                        ? trafficState.getVehiclesPassed()
                                        : 0;

                %>


                <div
                        class="direction-box radial-signal"
                        data-signal-id="<%= signal.getSignalId() %>"
                        data-direction="<%= signal.getDirection() %>"
                >


                    <!-- TRAFFIC LIGHT -->

                    <div
                            id="signal-<%= signal.getSignalId() %>"
                            class="traffic-light red"
                    >

                    </div>


                    <!-- DIRECTION -->

                    <h4>

                        <%= signal.getDirection() %>

                    </h4>


                    <!-- STATUS -->

                    <p>

                        Status:

                        <span
                                id="status-<%= signal.getSignalId() %>"
                        >

                            RED

                        </span>

                    </p>


                    <!-- TIMER (hidden during emergency priority) -->

                    <p class="signal-timer-row"
                       id="timer-row-<%= signal.getSignalId() %>">

                        Timer:

                        <span id="timer-<%= signal.getSignalId() %>">0</span>

                        s

                    </p>

                    <div class="emergency-lane-message d-none"
                         id="emergency-lane-message-<%= signal.getSignalId() %>"
                         aria-live="polite"></div>


                    <!-- TRAFFIC INFORMATION -->

                    <div class="traffic-info">


                        <div>

                            🚗 Vehicles:

                            <strong>

                                <%= vehicleCount %>

                            </strong>

                        </div>


                        <div>

                            ⏱ Waiting:

                            <strong>

                                <%= waitingTime %>s

                            </strong>

                        </div>


                        <div>

                            ✅ Passed:

                            <strong>

                                <%= vehiclesPassed %>

                            </strong>

                        </div>


                    </div>


                    <!-- SIGNAL DATA -->

                    <input
                            type="hidden"
                            class="signal-data"

                            data-id="<%= signal.getSignalId() %>"

                            data-direction="<%= signal.getDirection() %>"

                            data-green="<%= signal.getGreenTime() %>"

                            data-yellow="<%= signal.getYellowTime() %>"

                            data-red="<%= signal.getRedTime() %>"

                            data-order="<%= signal.getDisplayOrder() %>"
                    >


                </div>


                <%
                    }
                %>


            </div>


            <!-- =================================================
                 CURRENT PHASE
            ================================================== -->

            <div class="text-center mt-4">


                <h5>

                    Current Phase:

                    <span id="phase">

                        READY

                    </span>

                </h5>


            </div>


        </div>

    </div>


    <%
        }

        else {
    %>


    <div class="alert alert-info">

        Please select a junction to start the simulation.

    </div>


    <%
        }
    %>


</div>


<!-- =====================================================
     JAVASCRIPT VARIABLES
===================================================== -->

<script>

    const CURRENT_JUNCTION_ID =
        "<%= selectedJunctionId != null
                ? selectedJunctionId
                : "" %>";


    const CONTEXT_PATH =
        "<%= request.getContextPath() %>";


    const INITIAL_GLOBAL_RUNNING =
        <%= globalRunning != null &&
            globalRunning
                ? "true"
                : "false" %>;


    const INITIAL_JUNCTION_PAUSED =
        <%= junctionPaused != null &&
            junctionPaused
                ? "true"
                : "false" %>;

</script>


<!-- CACHE BUSTING -->

<script
        src="<%= request.getContextPath() %>/js/simulation.js?v=12"
></script>


</body>

</html>