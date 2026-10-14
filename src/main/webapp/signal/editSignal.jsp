<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="com.trafficiq.model.Signal" %>
<%@ page import="com.trafficiq.model.Junction" %>

<%
    Signal signal =
            (Signal) request.getAttribute("signal");

    Junction junction =
            (Junction) request.getAttribute("junction");
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Edit Signal</title>

    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet">

</head>

<body class="bg-light">


<nav class="navbar navbar-dark bg-dark">

    <div class="container-fluid px-4">

        <span class="navbar-brand">

            🚦 TrafficIQ

        </span>

        <a href="junctionSignals?junctionId=<%= signal.getJunctionId() %>"
           class="btn btn-outline-light">

            Back to Signals

        </a>

    </div>

</nav>


<div class="container mt-5">

    <div class="card shadow">

        <div class="card-header bg-warning">

            <h3 class="mb-0">

                ✏ Edit Signal

            </h3>

        </div>


        <div class="card-body">


            <div class="alert alert-light border">

                <strong>Junction:</strong>

                <%= junction.getJunctionName() %>

            </div>


            <form action="updateSignal" method="post">


                <!-- Signal ID -->

                <input type="hidden"
                       name="signalId"
                       value="<%= signal.getSignalId() %>">


                <!-- Junction cannot be changed -->

                <input type="hidden"
                       name="junctionId"
                       value="<%= signal.getJunctionId() %>">


                <!-- Direction -->

                <div class="mb-3">

                    <label class="form-label">

                        Direction

                    </label>

                    <select name="direction"
                            class="form-select"
                            required>

                        <option value="NORTH"
                            <%= "NORTH".equals(signal.getDirection()) ? "selected" : "" %>>
                            NORTH
                        </option>

                        <option value="SOUTH"
                            <%= "SOUTH".equals(signal.getDirection()) ? "selected" : "" %>>
                            SOUTH
                        </option>

                        <option value="EAST"
                            <%= "EAST".equals(signal.getDirection()) ? "selected" : "" %>>
                            EAST
                        </option>

                        <option value="WEST"
                            <%= "WEST".equals(signal.getDirection()) ? "selected" : "" %>>
                            WEST
                        </option>

                    </select>

                </div>


                <!-- Green -->

                <div class="mb-3">

                    <label class="form-label">

                        Green Time (Seconds)

                    </label>

                    <input type="number"
                           name="greenTime"
                           class="form-control"
                           value="<%= signal.getGreenTime() %>"
                           min="1"
                           required>

                </div>


                <!-- Yellow -->

                <div class="mb-3">

                    <label class="form-label">

                        Yellow Time (Seconds)

                    </label>

                    <input type="number"
                           name="yellowTime"
                           class="form-control"
                           value="<%= signal.getYellowTime() %>"
                           min="1"
                           required>

                </div>


                <!-- Red -->

                <div class="mb-3">

                    <label class="form-label">

                        Red Time (Seconds)

                    </label>

                    <input type="number"
                           name="redTime"
                           class="form-control"
                           value="<%= signal.getRedTime() %>"
                           min="1"
                           required>

                </div>


                <!-- Status -->

                <div class="mb-4">

                    <label class="form-label">

                        Status

                    </label>

                    <select name="status"
                            class="form-select">

                        <option value="ACTIVE"
                            <%= "ACTIVE".equals(signal.getStatus()) ? "selected" : "" %>>

                            ACTIVE

                        </option>


                        <option value="INACTIVE"
                            <%= "INACTIVE".equals(signal.getStatus()) ? "selected" : "" %>>

                            INACTIVE

                        </option>

                    </select>

                </div>


                <button type="submit"
                        class="btn btn-success">

                    Update Signal

                </button>


                <a href="junctionSignals?junctionId=<%= signal.getJunctionId() %>"
                   class="btn btn-secondary">

                    Cancel

                </a>


            </form>

        </div>

    </div>

</div>

</body>

</html>