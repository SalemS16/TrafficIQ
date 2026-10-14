<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.trafficiq.model.Junction" %>

<%
    Junction junction =
            (Junction) request.getAttribute("junction");
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Edit Junction - TrafficIQ</title>

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


        <div class="card-header bg-warning">

            <h3 class="mb-0">

                ✏ Edit Junction

            </h3>

        </div>



        <div class="card-body">


            <form action="updateJunction"
                  method="post">


                <!-- JUNCTION ID -->

                <input type="hidden"
                       name="junctionId"
                       value="<%= junction.getJunctionId() %>">


                <!-- JUNCTION NAME -->

                <div class="mb-3">

                    <label class="form-label">

                        Junction Name

                    </label>

                    <input type="text"
                           name="junctionName"
                           class="form-control"
                           value="<%= junction.getJunctionName() %>"
                           required>

                </div>


                <!-- AREA -->

                <div class="mb-3">

                    <label class="form-label">

                        Area

                    </label>

                    <input type="text"
                           name="area"
                           class="form-control"
                           value="<%= junction.getArea() %>"
                           required>

                </div>


                <!-- STATUS -->

                <div class="mb-4">

                    <label class="form-label">

                        Status

                    </label>

                    <select name="status"
                            class="form-select">

                        <option value="ACTIVE"
                            <%= "ACTIVE".equalsIgnoreCase(
                                    junction.getStatus()
                            ) ? "selected" : "" %>>

                            ACTIVE

                        </option>


                        <option value="INACTIVE"
                            <%= "INACTIVE".equalsIgnoreCase(
                                    junction.getStatus()
                            ) ? "selected" : "" %>>

                            INACTIVE

                        </option>

                    </select>

                </div>


                <!-- ACTION BUTTONS -->

                <button type="submit"
                        class="btn btn-success">

                    Update Junction

                </button>


                <a href="junctions"
                   class="btn btn-secondary">

                    ← Back to Junctions

                </a>


            </form>

        </div>

    </div>


</div>


</body>

</html>