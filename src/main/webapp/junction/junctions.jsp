
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.trafficiq.model.Junction" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>TrafficIQ - Junction Management</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>

<body>

<div class="container mt-5">

    <h2 class="text-center mb-4">
        🚦 TrafficIQ - Junction Management
    </h2>

    <div class="text-end mb-3">
        <a href="<%= request.getContextPath() %>/showAddJunction"
           class="btn btn-primary">
            + Add Junction
        </a>
    </div>

    <table class="table table-bordered table-hover table-striped">

        <thead>
        <tr>
            <th>ID</th>
            <th>Junction Name</th>
            <th>Area</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>

        <tbody>

        <%
            List<Junction> junctionList =
                    (List<Junction>) request.getAttribute("junctionList");

            if (junctionList != null && !junctionList.isEmpty()) {

                for (Junction junction : junctionList) {
        %>

        <tr>

            <td><%= junction.getJunctionId() %></td>

            <td><%= junction.getJunctionName() %></td>

            <td><%= junction.getArea() %></td>

            <td>
                <% if ("ACTIVE".equals(junction.getStatus())) { %>
                    <span class="badge bg-success">ACTIVE</span>
                <% } else { %>
                    <span class="badge bg-danger">INACTIVE</span>
                <% } %>
            </td>

            <td>
                <a href="<%= request.getContextPath() %>/junctionSignals?junctionId=<%= junction.getJunctionId() %>"
                   class="btn btn-primary btn-sm">
                    Manage Signals
                </a>

                <a href="<%= request.getContextPath() %>/editJunction?id=<%= junction.getJunctionId() %>"
                   class="btn btn-warning btn-sm">
                    Edit
                </a>

                <a href="<%= request.getContextPath() %>/deleteJunction?id=<%= junction.getJunctionId() %>"
                   class="btn btn-danger btn-sm"
                   onclick="return confirm('Are you sure you want to delete this junction?');">
                    Delete
                </a>
            </td>

        </tr>

        <%
                }

            } else {
        %>

        <tr>
            <td colspan="5" class="text-center">
                No junctions found.
            </td>
        </tr>

        <%
            }
        %>

        </tbody>

    </table>

    <div class="text-center mt-3">
        <a href="<%= request.getContextPath() %>/dashboard"
           class="btn btn-secondary">
            Back to Dashboard
        </a>
    </div>

</div>

</body>
</html>
