<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Logout</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
    <h2>Logging Out...</h2>
    <%
        // Invalidate the session to clear all attributes
        session.invalidate();

        // Redirect to login.jsp
        response.sendRedirect("login.jsp");
    %>
</div>
</body>
</html>