<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.trafficiq.model.Junction" %>

<%
    Junction junction = (Junction) request.getAttribute("junction");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Junction</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>

<body>

<div class="container mt-5">

    <h2 class="text-center mb-4">
        🚦 Edit Junction
    </h2>

    <form action="updateJunction" method="post">

        <!-- Hidden ID -->
        <input type="hidden"
               name="junctionId"
               value="<%= junction.getJunctionId() %>">

        <!-- Junction Name -->
        <div class="mb-3">
            <label class="form-label">Junction Name</label>

            <input type="text"
                   name="junctionName"
                   class="form-control"
                   value="<%= junction.getJunctionName() %>"
                   required>
        </div>

        <!-- Area -->
        <div class="mb-3">
            <label class="form-label">Area</label>

            <input type="text"
                   name="area"
                   class="form-control"
                   value="<%= junction.getArea() %>"
                   required>
        </div>

        <!-- Total Lanes -->
        <div class="mb-3">
            <label class="form-label">Total Lanes</label>

            <input type="number"
                   name="totalLanes"
                   class="form-control"
                   value="<%= junction.getTotalLanes() %>"
                   required>
        </div>

        <!-- Status -->
        <div class="mb-3">
            <label class="form-label">Status</label>

            <select name="status" class="form-select">

                <option value="ACTIVE"
                    <%= junction.getStatus().equals("ACTIVE") ? "selected" : "" %>>
                    ACTIVE
                </option>

                <option value="INACTIVE"
                    <%= junction.getStatus().equals("INACTIVE") ? "selected" : "" %>>
                    INACTIVE
                </option>

            </select>

        </div>

        <!-- Buttons -->
        <button type="submit" class="btn btn-success">
            Update Junction
        </button>

        <a href="junctions" class="btn btn-secondary">
            Cancel
        </a>

    </form>

</div>

</body>
</html>