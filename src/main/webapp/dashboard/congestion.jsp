<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map" %>
<%
List<Map<String,Object>> rows = (List<Map<String,Object>>) request.getAttribute("signalRows");
Object count = request.getAttribute("congestedCount");
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>TrafficIQ - Congestion Panel</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>body{background:#f4f6f9}.panel{border:0;border-radius:16px;box-shadow:0 4px 15px #00000014}.table thead th{background:#212529;color:white;white-space:nowrap}</style>
</head><body>
<nav class="navbar navbar-dark bg-dark"><div class="container-fluid px-4"><span class="navbar-brand">🚦 TrafficIQ</span><a class="btn btn-outline-light" href="<%=request.getContextPath()%>/dashboard">Back to Dashboard</a></div></nav>
<main class="container-fluid px-3 px-md-4 my-4">
<div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4"><div><h1 class="fw-bold">Congestion Panel</h1><p class="text-muted">Current waiting queue for each signal.</p></div><div class="card panel"><div class="card-body text-center"><div class="small text-muted">Signals with 41+ vehicles</div><div class="fs-2 fw-bold"><%=count==null?0:count%></div></div></div></div>
<div class="card panel"><div class="card-body"><div class="table-responsive"><table class="table table-hover align-middle">
<thead><tr><th>Junction</th><th>Signal</th><th>Direction</th><th>Waiting vehicles</th><th>Waiting time</th><th>Level</th><th>Action</th></tr></thead><tbody>
<% if(rows!=null&&!rows.isEmpty()){for(Map<String,Object> row:rows){String level=String.valueOf(row.get("congestionLevel"));String badge="text-bg-success";if("Low".equals(level))badge="text-bg-info";else if("Medium".equals(level))badge="text-bg-secondary";else if("High".equals(level))badge="text-bg-warning";else if("Congested".equals(level))badge="text-bg-danger"; %>
<tr><td><strong><%=row.get("junctionName")%></strong></td><td>#<%=row.get("signalId")%></td><td><%=row.get("direction")%></td><td><%=row.get("vehicleCount")%></td><td><%=row.get("waitingTime")%> s</td><td><span class="badge <%=badge%>"><%=level%></span></td><td><a class="btn btn-sm btn-success" href="<%=request.getContextPath()%>/simulation?junctionId=<%=row.get("junctionId")%>">Open Simulation</a></td></tr>
<%}}else{%><tr><td colspan="7" class="text-center text-muted py-5">No signal data available.</td></tr><%}%>
</tbody></table></div></div></div>
<div class="card panel mt-4"><div class="card-body"><h5 class="fw-bold">Congestion levels</h5><div class="d-flex flex-wrap gap-2"><span class="badge text-bg-success">Very Low: 0–9</span><span class="badge text-bg-info">Low: 10–15</span><span class="badge text-bg-secondary">Medium: 16–25</span><span class="badge text-bg-warning">High: 26–40</span><span class="badge text-bg-danger">Congested: 41+</span></div></div></div>
</main></body></html>
