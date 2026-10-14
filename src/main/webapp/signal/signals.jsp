<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.trafficiq.model.Signal" %>

<%
    List<Signal> signalList = (List<Signal>) request.getAttribute("signalList");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Signal Management</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

</head>

<body class="bg-light">

<div class="container mt-5">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <h2>🚦 Signal Management</h2>

        <a href="showAddSignal" class="btn btn-primary">
            + Add Signal
        </a>

    </div>

    <table class="table table-bordered table-hover shadow">

        <thead class="table-dark">

        <tr>

            <th>ID</th>
            <th>Junction</th>
            <th>Direction</th>
            <th>Green Time</th>
            <th>Yellow Time</th>
            <th>Red Time</th>
            <th>Status</th>
            <th>Action</th>

        </tr>

        </thead>

        <tbody>

        <%
            if (signalList != null && !signalList.isEmpty()) {

                for (Signal signal : signalList) {
        %>

        <tr>

            <td><%= signal.getSignalId() %></td>

            <td><%= signal.getJunctionName() %></td>

            <td><%= signal.getDirection() %></td>

            <td><%= signal.getGreenTime() %></td>

            <td><%= signal.getYellowTime() %></td>

            <td><%= signal.getRedTime() %></td>

            <td><%= signal.getStatus() %></td>

            <td>

                <a href="editSignal?id=<%=signal.getSignalId()%>"
                   class="btn btn-warning btn-sm">
                    Edit
                </a>

                <a href="deleteSignal?id=<%=signal.getSignalId()%>"
                   class="btn btn-danger btn-sm"
                   onclick="return confirm('Delete this signal?')">
                    Delete
                </a>

            </td>

        </tr>

        <%
                }

            } else {
        %>

        <tr>

            <td colspan="8" class="text-center">

                No Signals Found

            </td>

        </tr>

        <%
            }
        %>

        </tbody>

    </table>

    <a href="dashboard"
       class="btn btn-secondary">
        Back to Dashboard
    </a>

</div>

</body>
</html>
