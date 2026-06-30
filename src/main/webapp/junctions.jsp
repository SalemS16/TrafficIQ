<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.trafficiq.model.Junction" %>

<!DOCTYPE html>
<html>
<head>
    <head>
        <meta charset="UTF-8">
        <title>TrafficIQ - Junction Management</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
              rel="stylesheet">
    </head>
</head>
<body>

<div class="container mt-5">

    <h2 class="text-center mb-4">
        🚦 TrafficIQ - Junction Management
    </h2>

    <div class="text-end mb-3">
        <a href="addJunction.jsp" class="btn btn-primary">
            + Add Junction
        </a>
    </div>

    <table class="table table-bordered table-hover table-striped">

        <tr>
            <th>ID</th>
            <th>Junction Name</th>
            <th>Area</th>
            <th>Total Lanes</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>

        <%
            List<Junction> junctionList =
                    (List<Junction>) request.getAttribute("junctionList");

            if(junctionList != null){

                for(Junction junction : junctionList){
        %>

        <tr>
            <td><%= junction.getJunctionId() %></td>
            <td><%= junction.getJunctionName() %></td>
            <td><%= junction.getArea() %></td>
            <td><%= junction.getTotalLanes() %></td>
            <td>

            <% if(junction.getStatus().equals("ACTIVE")) { %>

                <span class="badge bg-success">
                    ACTIVE
                </span>

            <% } else { %>

                <span class="badge bg-danger">
                    INACTIVE
                </span>

            <% } %>

            </td>
            <td>

                <a href="editJunction?id=<%= junction.getJunctionId() %>"
                   class="btn btn-warning btn-sm">
                    Edit
                </a>

                <a href="deleteJunction?id=<%= junction.getJunctionId() %>"
                   class="btn btn-danger btn-sm"
                   onclick="return confirm('Are you sure you want to delete this junction?');">
                    Delete
                </a>

            </td>
        </tr>

        <%
                }
            }
        %>

    </table>

</div>

</body>

</body>
</html>