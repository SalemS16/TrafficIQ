<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="com.trafficiq.model.Junction" %>
<%@ page import="com.trafficiq.model.Signal" %>

<%
    Junction junction =
            (Junction) request.getAttribute("junction");

    List<Signal> existingSignals =
            (List<Signal>) request.getAttribute("existingSignals");
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Add Signal - TrafficIQ</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

</head>


<body class="bg-light">


<!-- NAVBAR -->

<nav class="navbar navbar-dark bg-dark">

    <div class="container-fluid px-4">

        <span class="navbar-brand mb-0 h1">

            🚦 TrafficIQ

        </span>


        <a href="logout"
           class="btn btn-outline-light">

            Logout

        </a>

    </div>

</nav>



<div class="container mt-5">


    <div class="card shadow border-0">


        <div class="card-header bg-success text-white">

            <h3 class="mb-0">

                🚦 Add Signal

            </h3>

        </div>



        <div class="card-body">


            <!-- CURRENT JUNCTION -->

            <h5 class="mb-4">

                Junction:

                <strong>

                    <%= junction.getJunctionName() %>

                </strong>

            </h5>



            <form action="addSignal"
                  method="post">


                <!-- JUNCTION ID -->

                <input type="hidden"
                       name="junctionId"
                       value="<%= junction.getJunctionId() %>">


                <!-- DIRECTION -->

                <div class="mb-3">

                    <label class="form-label">

                        Direction

                    </label>


                    <select name="direction"
                            class="form-select"
                            required>


                        <option value="">

                            -- Select Direction --

                        </option>


<%
    String[] directions = {

            "NORTH",
            "SOUTH",
            "EAST",
            "WEST",
            "NORTH EAST",
            "NORTH WEST",
            "SOUTH EAST",
            "SOUTH WEST"

    };


    for (String direction : directions) {

        boolean alreadyExists = false;


        if (existingSignals != null) {

            for (Signal signal : existingSignals) {

                if (direction.equalsIgnoreCase(
                        signal.getDirection()
                )) {

                    alreadyExists = true;

                    break;
                }
            }
        }


        if (!alreadyExists) {
%>

                        <option value="<%= direction %>">

                            <%= direction %>

                        </option>

<%
        }
    }
%>


                    </select>

                </div>



                <!-- GREEN TIME -->

                <div class="mb-3">

                    <label class="form-label">

                        Default Green Time (Seconds)

                    </label>


                    <input type="number"
                           name="greenTime"
                           class="form-control"
                           value="30"
                           min="5"
                           required>

                </div>



                <!-- YELLOW TIME -->

                <div class="mb-3">

                    <label class="form-label">

                        Yellow Time (Seconds)

                    </label>


                    <input type="number"
                           name="yellowTime"
                           class="form-control"
                           value="5"
                           min="3"
                           required>

                </div>



                <!-- RED TIME -->

                <div class="mb-4">

                    <label class="form-label">

                        Default Red Time (Seconds)

                    </label>


                    <input type="number"
                           name="redTime"
                           class="form-control"
                           value="30"
                           min="5"
                           required>

                </div>



                <!-- STATUS -->

                <div class="mb-4">

                    <label class="form-label">

                        Status

                    </label>


                    <select name="status"
                            class="form-select">

                        <option value="ACTIVE">

                            ACTIVE

                        </option>

                        <option value="INACTIVE">

                            INACTIVE

                        </option>

                    </select>

                </div>



                <!-- ACTION BUTTONS -->

                <button type="submit"
                        class="btn btn-success">

                    Save Signal

                </button>


                <a href="junctionSignals?junctionId=<%= junction.getJunctionId() %>"
                   class="btn btn-secondary">

                    ← Back to Signals

                </a>


            </form>

        </div>

    </div>


</div>


</body>

</html>