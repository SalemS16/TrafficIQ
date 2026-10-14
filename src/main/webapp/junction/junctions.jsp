
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.trafficiq.model.Junction" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    List<Junction> junctionList =
            (List<Junction>) request.getAttribute("junctionList");

    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>TrafficIQ | Junction Management</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        :root {
            --black: #111318;
            --background: #f3f5f9;
            --text: #172033;
            --muted: #64748b;
            --border: #e2e8f0;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: var(--background);
            color: var(--text);
            font-family: "Segoe UI", Arial, sans-serif;
        }

        /* TRAFFICIQ HEADER */
        .tiq-navbar {
            min-height: 76px;
            padding: 15px 5%;
            background: #101318;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
            box-shadow: 0 4px 18px rgba(0, 0, 0, 0.12);
        }

        .tiq-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 23px;
            font-weight: 750;
            letter-spacing: -0.6px;
        }

        .tiq-brand-icon {
            width: 42px;
            height: 42px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            background: #252a33;
            font-size: 22px;
        }

        .tiq-brand span {
            color: #b8c0cc;
        }

        .tiq-nav-actions {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .tiq-btn {
            min-height: 42px;
            padding: 11px 17px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            border: 1px solid #414753;
            border-radius: 9px;
            background: #111827;
            color: #fff;
            text-decoration: none;
            font-family: inherit;
            font-size: 13px;
            font-weight: 650;
            cursor: pointer;
            transition: background 0.2s, transform 0.2s,
                        box-shadow 0.2s;
        }

        .tiq-btn:hover {
            background: #000;
            color: #fff;
            transform: translateY(-1px);
            box-shadow: 0 5px 12px rgba(0, 0, 0, 0.16);
        }

        /* PAGE LAYOUT */
        .page-container {
            width: min(1500px, 94%);
            margin: 34px auto 50px;
        }

        .page-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
            margin-bottom: 22px;
        }

        .eyebrow {
            margin-bottom: 7px;
            color: var(--muted);
            font-size: 12px;
            font-weight: 750;
            text-transform: uppercase;
            letter-spacing: 1.5px;
        }

        .page-heading h1 {
            margin: 0;
            color: #111827;
            font-size: clamp(25px, 3vw, 32px);
            font-weight: 750;
            letter-spacing: -0.8px;
        }

        .page-description {
            margin: 8px 0 0;
            color: var(--muted);
            font-size: 14px;
            line-height: 1.6;
        }

        .add-btn {
            min-height: 44px;
            padding: 12px 19px;
        }

        /* TABLE */
        .table-card {
            overflow: hidden;
            border: 1px solid #e5e9f0;
            border-radius: 14px;
            background: #fff;
            box-shadow: 0 5px 20px rgba(15, 23, 42, 0.04);
        }

        .table-responsive {
            width: 100%;
        }

        .junction-table {
            width: 100%;
            margin: 0;
            border-collapse: separate;
            border-spacing: 0;
            vertical-align: middle;
        }

        .junction-table thead th {
            padding: 17px 18px;
            background: #f8fafc;
            color: #475569;
            border-bottom: 1px solid var(--border);
            font-size: 12px;
            font-weight: 750;
            text-transform: uppercase;
            letter-spacing: 0.7px;
            white-space: nowrap;
        }

        .junction-table tbody td {
            padding: 17px 18px;
            border-bottom: 1px solid #edf0f5;
            color: #374151;
            font-size: 14px;
        }

        .junction-table tbody tr:last-child td {
            border-bottom: none;
        }

        .junction-table tbody tr {
            transition: background 0.2s;
        }

        .junction-table tbody tr:hover td {
            background: #f8fafc;
        }

        .junction-id {
            color: #64748b !important;
            font-weight: 650;
        }

        .junction-name {
            color: #111827 !important;
            font-weight: 700;
        }

        /* STATUS BADGES */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 7px 11px;
            border-radius: 7px;
            font-size: 11px;
            font-weight: 750;
            letter-spacing: 0.3px;
        }

        .status-active {
            background: #dcfce7;
            color: #166534;
        }

        .status-inactive {
            background: #fee2e2;
            color: #991b1b;
        }

        .status-dot {
            width: 7px;
            height: 7px;
            display: inline-block;
            border-radius: 50%;
            background: currentColor;
        }

        /* ORIGINAL ACTION COLORS */
        .action-buttons {
            display: flex;
            align-items: center;
            gap: 6px;
            flex-wrap: wrap;
        }

        .action-btn {
            min-height: 36px;
            padding: 8px 13px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 1px solid transparent;
            border-radius: 7px;
            color: #fff;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            white-space: nowrap;
            cursor: pointer;
            transition: filter 0.2s, transform 0.2s;
        }

        .action-btn:hover {
            filter: brightness(0.91);
            color: #fff;
            transform: translateY(-1px);
        }

        .action-manage {
            background: #0d6efd;
            border-color: #0d6efd;
        }

        .action-edit {
            background: #ffc107;
            border-color: #ffc107;
            color: #212529;
        }

        .action-edit:hover {
            color: #212529;
        }

        .action-delete {
            background: #dc3545;
            border-color: #dc3545;
        }

        /* EMPTY STATE */
        .empty-state {
            padding: 55px 20px !important;
            color: var(--muted) !important;
            text-align: center;
        }

        .empty-icon {
            margin-bottom: 12px;
            font-size: 34px;
        }

        .empty-state h3 {
            margin-bottom: 8px;
            color: #111827;
            font-size: 18px;
            font-weight: 700;
        }

        .empty-state p {
            margin-bottom: 20px;
            font-size: 13px;
        }

        .page-footer {
            padding-top: 22px;
            color: #94a3b8;
            text-align: center;
            font-size: 12px;
        }

        @media (max-width: 768px) {
            .tiq-navbar {
                padding: 14px 4%;
            }

            .tiq-brand {
                font-size: 20px;
            }

            .page-container {
                width: 94%;
                margin-top: 25px;
            }

            .page-heading {
                align-items: stretch;
            }

            .page-heading .add-btn {
                width: 100%;
            }

            .junction-table thead th,
            .junction-table tbody td {
                padding: 13px 12px;
            }
        }
    </style>
</head>

<body>

<!-- TRAFFICIQ NAVBAR -->
<nav class="tiq-navbar">

    <div class="tiq-brand">
        <div class="tiq-brand-icon" aria-hidden="true">&#128678;</div>
        <div>Traffic<span>IQ</span></div>
    </div>

    <div class="tiq-nav-actions">
        <a class="tiq-btn"
           href="<%= contextPath %>/dashboard">
            &#8592; Back to Dashboard
        </a>
    </div>

</nav>

<main class="page-container">

    <!-- PAGE TITLE AND ADD JUNCTION -->
    <div class="page-heading">

        <div>
            <div class="eyebrow">Traffic Operations</div>

            <h1>Junction Management</h1>

            <p class="page-description">
                Manage traffic junctions, update their details,
                and control the signals assigned to each junction.
            </p>
        </div>

        <a href="<%= contextPath %>/showAddJunction"
           class="tiq-btn add-btn">
            + Add Junction
        </a>

    </div>

    <!-- JUNCTION TABLE -->
    <section class="table-card">

        <div class="table-responsive">

            <table class="table junction-table">

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
                    if (junctionList != null && !junctionList.isEmpty()) {

                        for (Junction junction : junctionList) {
                %>

                <tr>

                    <td class="junction-id">
                        <%= junction.getJunctionId() %>
                    </td>

                    <td class="junction-name">
                        <%= escapeHtml(junction.getJunctionName()) %>
                    </td>

                    <td>
                        <%= escapeHtml(junction.getArea()) %>
                    </td>

                    <td>
                        <% if ("ACTIVE".equalsIgnoreCase(junction.getStatus())) { %>
                            <span class="status-badge status-active">
                                <span class="status-dot"></span>
                                ACTIVE
                            </span>
                        <% } else { %>
                            <span class="status-badge status-inactive">
                                <span class="status-dot"></span>
                                INACTIVE
                            </span>
                        <% } %>
                    </td>

                    <td>
                        <div class="action-buttons">

                            <a href="<%= contextPath %>/junctionSignals?junctionId=<%= junction.getJunctionId() %>"
                               class="action-btn action-manage">
                                Manage Signals
                            </a>

                            <a href="<%= contextPath %>/editJunction?id=<%= junction.getJunctionId() %>"
                               class="action-btn action-edit">
                                Edit
                            </a>

                            <a href="<%= contextPath %>/deleteJunction?id=<%= junction.getJunctionId() %>"
                               class="action-btn action-delete"
                               onclick="return confirm('Are you sure you want to delete this junction?');">
                                Delete
                            </a>

                        </div>
                    </td>

                </tr>

                <%
                        }

                    } else {
                %>

                <tr>
                    <td colspan="5" class="empty-state">

                        <div class="empty-icon">&#128678;</div>

                        <h3>No junctions found</h3>

                        <p>
                            Add your first junction to start managing
                            traffic signals.
                        </p>

                        <a href="<%= contextPath %>/showAddJunction"
                           class="tiq-btn">
                            + Add First Junction
                        </a>

                    </td>
                </tr>

                <%
                    }
                %>

                </tbody>

            </table>

        </div>

    </section>

    <footer class="page-footer">
        TrafficIQ &bull; Smart Traffic Signal Optimization
    </footer>

</main>

</body>
</html>

