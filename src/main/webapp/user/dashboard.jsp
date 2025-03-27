<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% if (session.getAttribute("role") == null || !session.getAttribute("role").equals("user")) {
  response.sendRedirect("../login.jsp");
} %>
<!DOCTYPE html>
<html>
<head>
  <title>User Dashboard - Yamin's Zumba Studio</title>
  <link rel="stylesheet" href="../style.css">
</head>
<body class="user-dashboard">
<div class="container">
  <%
    String username = (String) session.getAttribute("username");
    if (username != null && !username.isEmpty()) {
      username = username.substring(0, 1).toUpperCase() + username.substring(1);
    }
  %>
  <h2>Welcome, <%= username %></h2>
  <a href="manageEnrollments.jsp">Manage Enrollments</a>
  <a href="../logout.jsp">Logout</a>
</div>
</body>
</html>