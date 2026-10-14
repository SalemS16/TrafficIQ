<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.util.List" %>
<%@ page import="com.trafficiq.model.Signal" %>
<% List<Signal> signalList=(List<Signal>)request.getAttribute("signalList"); %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Signal Management - TrafficIQ</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body{
            background:#f3f5f9;
            color:#172033;
            font-family:"Segoe UI",Arial,sans-serif}
            .tiq-navbar{
            min-height:76px;
            padding:15px 5%;
            background:#101318;
            color:#fff;
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:18px;
            flex-wrap:wrap;
            box-shadow:0 4px 18px rgba(0,0,0,.12)}
            .tiq-brand{
            display:flex;
            align-items:center;
            gap:12px;
            color:#fff;
            font-size:23px;
            font-weight:750;
            letter-spacing:-.6px;
            text-decoration:none}
            .tiq-brand-icon{
            width:42px;
            height:42px;
            display:flex;
            align-items:center;
            justify-content:center;
            border-radius:12px;
            background:#252a33;
            font-size:22px}
            .tiq-brand:hover{
            color:#fff}
            .tiq-brand-muted{
            color:#b8c0cc}
            .tiq-nav-btn{
            min-height:42px;
            padding:11px 17px;
            display:inline-flex;
            align-items:center;
            justify-content:center;
            border:1px solid #414753;
            border-radius:9px;
            background:#111827;
            color:#fff;
            text-decoration:none;
            font-size:13px;
            font-weight:650;
            transition:.2s}
            .tiq-nav-btn:hover{
            background:#000;
            color:#fff;
            transform:translateY(-1px)}
            .page-main{
            width:min(1200px,92%);
            margin:36px auto 55px}
            .form-card,.content-card{
            overflow:hidden;
            border:1px solid #e6eaf0;
            border-radius:16px;
            background:#fff;
            box-shadow:0 5px 20px rgba(15,23,42,.06)}
            .form-card-header{
            padding:20px 25px;
            background:#101318;
            color:#fff}
            .form-card-header h1{
            margin:0;
            font-size:26px;
            font-weight:750}
            .form-card-body{
            padding:25px}
            .form-label{
            font-size:14px;
            font-weight:650;
            color:#374151}
            .form-control,.form-select{
            min-height:46px;
            border:1px solid #d5dbe5;
            border-radius:9px;
            font-size:14px}
            .form-control:focus,.form-select:focus{
            border-color:#6b7280;
            box-shadow:0 0 0 3px rgba(17,24,39,.08)}
            .btn{
            border-radius:9px;
            padding:10px 16px;
            font-size:14px;
            font-weight:600}
            .table thead th{
            background:#212529;
            color:#fff;
            white-space:nowrap}
            .table td{
            vertical-align:middle}
            .page-footer{
            padding:22px 10px 0;
            color:#94a3b8;
            text-align:center;
            font-size:12px}
            @media(max-width:600px){
            .tiq-navbar{
            padding:14px 4%}
            .tiq-brand{
            font-size:20px}
            .page-main{
            width:94%;
            margin-top:22px}
            .form-card-body{
            padding:19px}
            }
        </style>
</head>
<body>
    <nav class="tiq-navbar">
        <a class="tiq-brand" href="<%= request.getContextPath() %>/dashboard">
            <span class="tiq-brand-icon" aria-hidden="true">&#128678;</span>
            <span style="color:#fff">Traffic<span class="tiq-brand-muted">IQ</span>
            </span>
    </a>
<a class="tiq-nav-btn" href="<%= request.getContextPath() %>/junctions">&#8592; Back to Junctions</a>
</nav>
<main class="page-main">
    <section class="content-card">
        <div class="form-card-body">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
                <div>
                    <h1 class="h3 fw-bold mb-1">Signal Management</h1>
                    <p class="text-secondary mb-0">Manage configured traffic signals.</p>
                </div>
            <a href="<%= request.getContextPath() %>/showAddSignal" class="btn btn-primary">+ Add Signal</a>
        </div>
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Junction</th>
                    <th>Direction</th>
                    <th>Green Time</th>
                    <th>Yellow Time</th>
                    <th>Red Time</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
        </thead>
    <tbody>
        <% if(signalList!=null&&!signalList.isEmpty()){for(Signal signal:signalList){ %>
        <tr>
            <td>
                <%= signal.getSignalId() %>
            </td>
        <td>
            <%= signal.getJunctionName() %>
        </td>
    <td>
        <%= signal.getDirection() %>
    </td>
<td>
    <span class="badge bg-success">
        <%= signal.getGreenTime() %>s</span>
    </td>
<td>
    <span class="badge bg-warning text-dark">
        <%= signal.getYellowTime() %>s</span>
    </td>
<td>
    <span class="badge bg-danger">
        <%= signal.getRedTime() %>s</span>
    </td>
<td>
    <%= signal.getStatus() %>
</td>
<td>
    <div class="d-flex gap-2">
        <a href="<%= request.getContextPath() %>/editSignal?id=<%= signal.getSignalId() %>" class="btn btn-warning btn-sm">Edit</a>
        <a href="<%= request.getContextPath() %>/deleteSignal?id=<%= signal.getSignalId() %>" class="btn btn-danger btn-sm" onclick="return confirm('Delete this signal?')">Delete</a>
    </div>
</td>
</tr>
<% }}else{ %>
<tr>
    <td colspan="8" class="text-center text-secondary py-5">No Signals Found</td>
</tr>
<% } %>
</tbody>
</table>
</div>
</div>
</section>
<footer class="page-footer">TrafficIQ &bull; Smart Traffic Signal Optimization</footer>
</main>
</body>
</html>
