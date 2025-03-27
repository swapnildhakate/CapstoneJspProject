<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.dao.UserDAO, java.util.*" %>
<%
    // Restrict access to admin only
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    UserDAO userDAO = new UserDAO();
    List<Object[]> enrollments = userDAO.getAllEnrollments();
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Enrollments</title>
    <link rel="stylesheet" href="../style.css">
</head>
<body>
<div class="container">
    <h2>Enrollment Details</h2>
    <% if (enrollments.isEmpty()) { %>
    <p>No enrollments found.</p>
    <% } else { %>
    <table>
        <tr>
            <th>Username</th>
            <th>Email</th>
            <th>Batch Name</th>
            <th>Start Date</th>
            <th>End Date</th>
            <th>Time</th>
        </tr>
        <% for (Object[] enrollment : enrollments) { %>
        <tr>
            <td><%= enrollment[0] %></td> <!-- Username -->
            <td><%= enrollment[1] %></td> <!-- Email -->
            <td><%= enrollment[2] %></td> <!-- Batch Name -->
            <td><%= enrollment[3] %></td> <!-- Start Date -->
            <td><%= enrollment[4] %></td> <!-- End Date -->
            <td><%= enrollment[5] %></td> <!-- Time -->
        </tr>
        <% } %>
    </table>
    <% } %>
    <a href="dashboard.jsp">Back to Dashboard</a>
</div>
</body>
</html>