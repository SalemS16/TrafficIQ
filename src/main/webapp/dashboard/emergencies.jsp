<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map" %>
<%
List<Map<String,Object>> rows = (List<Map<String,Object>>) request.getAttribute("emergencyRows");
Object count = request.getAttribute("emergencyCount");
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>TrafficIQ - Emergency Panel</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>body{background:#f4f6f9}.panel{border:0;border-radius:16px;box-shadow:0 4px 15px #00000014}.table thead th{background:#212529;color:white;white-space:nowrap}</style>
</head><body>
<nav class="navbar navbar-dark bg-dark"><div class="container-fluid px-4"><span class="navbar-brand">🚦 TrafficIQ</span><a class="btn btn-outline-light" href="<%=request.getContextPath()%>/dashboard">Back to Dashboard</a></div></nav>
<main class="container-fluid px-3 px-md-4 my-4">
<div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4"><div><h1 class="fw-bold">Emergency Panel</h1><p class="text-muted">Currently active emergency priority requests.</p></div><div class="card panel"><div class="card-body text-center"><div class="small text-muted">Active emergencies</div><div class="fs-2 fw-bold"><%=count==null?0:count%></div></div></div></div>
<div class="card panel"><div class="card-body"><div class="table-responsive"><table class="table table-hover align-middle">
<thead><tr><th>Junction</th><th>Signal</th><th>Direction</th><th>Action</th></tr></thead><tbody>
<% if(rows!=null&&!rows.isEmpty()){for(Map<String,Object> row:rows){%>
<tr><td><strong><%=row.get("junctionName")%></strong></td><td>#<%=row.get("signalId")%></td><td><%=row.get("direction")%></td><td><a class="btn btn-sm btn-success" href="<%=request.getContextPath()%>/simulation?junctionId=<%=row.get("junctionId")%>">Open Simulation</a></td></tr>
<%}}else{%><tr><td colspan="4" class="text-center text-muted py-5">No active emergency requests right now.</td></tr><%}%>
</tbody></table></div></div></div>
</main></body></html>
