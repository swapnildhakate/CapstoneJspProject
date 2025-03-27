<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.dao.UserDAO, com.project.bean.User" %>
<%
  String error = null;
  String success = null;

  // Check if form is submitted
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    User user = new User();
    user.setUsername(request.getParameter("username"));
    user.setPassword(request.getParameter("password"));
    user.setEmail(request.getParameter("email"));

    UserDAO userDAO = new UserDAO();
    try {
      if (userDAO.registerUser(user)) {
        success = "Registration successful! Please log in.";
      } else {
        error = "Registration failed. Username or email may already exist.";
      }
    } catch (Exception e) {
      error = "Registration error: " + e.getMessage();
    }
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Register - Yamin's Zumba Studio</title>
  <link rel="stylesheet" href="../style.css">
</head>
<body>
<div class="container">
  <h2>Register</h2>
  <% if (error != null) { %>
  <p class="error"><%= error %></p>
  <% } %>
  <% if (success != null) { %>
  <p style="color: #34C759; font-weight: bold; text-align: center;"><%= success %></p>
  <a href="../login.jsp">Go to Login</a>
  <% } else { %>
  <form action="register.jsp" method="post">
    <label for="username">Username:</label>
    <input type="text" id="username" name="username" placeholder="Username" required>
    <label for="password">Password:</label>
    <input type="password" id="password" name="password" placeholder="Password" required>
    <label for="email">Email:</label>
    <input type="text" id="email" name="email" placeholder="Email" required>
    <input type="submit" value="Register">
  </form>
  <a href="../login.jsp">Back to Login</a>
  <% } %>
</div>
</body>
</html>