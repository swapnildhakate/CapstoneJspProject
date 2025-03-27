<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.dao.AdminDAO, com.project.dao.UserDAO, com.project.bean.Admin, com.project.bean.User" %>
<%
  String error = null;

  // Check if form is submitted
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    // Input validation
    if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
      error = "Username and password are required";
    } else {
      try {
        // Check if the user is an admin
        AdminDAO adminDAO = new AdminDAO();
        Admin admin = adminDAO.validateAdmin(username, password);
        if (admin != null) {
          session.setAttribute("username", username);
          session.setAttribute("role", "admin");
          response.sendRedirect("admin/dashboard.jsp");
          return; // Exit after redirect
        }

        // Check if the user is a regular user
        UserDAO userDAO = new UserDAO();
        User user = userDAO.validateUser(username, password);
        if (user != null) {
          session.setAttribute("username", username);
          session.setAttribute("role", "user");
          session.setAttribute("userId", user.getUserId());
          response.sendRedirect("user/dashboard.jsp");
          return; // Exit after redirect
        }

        // If neither admin nor user credentials match
        error = "Invalid username or password";
      } catch (Exception e) {
        error = "An error occurred during login: " + e.getMessage();
        e.printStackTrace();
      }
    }
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Login - Yamin's Zumba Studio</title>
  <link rel="stylesheet" href="style.css">
</head>
<body class="front-page">
<div class="container">
  <h1>Welcome to Yamin's Zumba Studio</h1>
  <h2>Login</h2>
  <% if (error != null) { %>
  <p class="error"><%= error %></p>
  <% } %>
  <form action="login.jsp" method="post">
    <label for="username">Username:</label>
    <input type="text" id="username" name="username" placeholder="Username" required>
    <label for="password">Password:</label>
    <input type="password" id="password" name="password" placeholder="Password" required>
    <input type="submit" value="Login">
  </form>
  <a href="user/register.jsp">New User? Register Here</a>
</div>
</body>
</html>