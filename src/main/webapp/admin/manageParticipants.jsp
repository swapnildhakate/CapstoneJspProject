<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.dao.UserDAO, com.project.bean.User, java.util.*, java.sql.*" %>
<%
    // Restrict access to admin only
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    UserDAO userDAO = new UserDAO();
    List<User> users = userDAO.getAllUsers();
    String action = request.getParameter("action");
    String error = null;

    // Handle actions
    if ("add".equals(action)) {
        User user = new User();
        user.setUsername(request.getParameter("username"));
        user.setPassword(request.getParameter("password")); // Will be hashed in UserDAO
        user.setEmail(request.getParameter("email"));
        if (userDAO.registerUser(user)) {
            users = userDAO.getAllUsers(); // Refresh list
        } else {
            error = "Failed to add participant. Username or email may already exist.";
        }
    } else if ("delete".equals(action)) {
        int userId = Integer.parseInt(request.getParameter("userId"));
        if (userDAO.deleteUser(userId)) {
            users = userDAO.getAllUsers(); // Refresh list
        } else {
            error = "Failed to delete participant";
        }
    } else if ("update".equals(action)) {
        int userId = Integer.parseInt(request.getParameter("userId"));
        User user = new User();
        user.setUserId(userId);
        user.setUsername(request.getParameter("username"));
        user.setPassword(request.getParameter("password")); // Will be hashed in UserDAO
        user.setEmail(request.getParameter("email"));
        if (userDAO.updateUser(user)) {
            users = userDAO.getAllUsers(); // Refresh list
        } else {
            error = "Failed to update participant";
        }
    }

    // Handle edit mode
    String editUserIdStr = request.getParameter("editUserId");
    User editUser = null;
    if (editUserIdStr != null) {
        int editUserId = Integer.parseInt(editUserIdStr);
        String query = "SELECT * FROM user WHERE user_id = ?";
        try (Connection conn = com.project.util.DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, editUserId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                editUser = new User();
                editUser.setUserId(rs.getInt("user_id"));
                editUser.setUsername(rs.getString("username"));
                editUser.setEmail(rs.getString("email"));
                // Password is not pre-filled for security; user must re-enter it
            }
        } catch (SQLException e) {
            e.printStackTrace();
            error = "Error loading participant for edit: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Participants - Yamin's Zumba Studio</title>
    <link rel="stylesheet" href="../style.css">
</head>
<body>
<div class="container">
    <h2>Manage Participants</h2>
    <% if (error != null) { %>
    <p class="error"><%= error %></p>
    <% } %>

    <!-- Add/Edit Participant Form -->
    <h3><%= editUser != null ? "Edit Participant" : "Add New Participant" %></h3>
    <form action="manageParticipants.jsp" method="post">
        <% if (editUser != null) { %>
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="userId" value="<%= editUser.getUserId() %>">
        <% } else { %>
        <input type="hidden" name="action" value="add">
        <% } %>
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" value="<%= editUser != null ? editUser.getUsername() : "" %>" required>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" placeholder="<%= editUser != null ? "Enter new password" : "Password" %>" required>
        <label for="email">Email:</label>
        <input type="text" id="email" name="email" value="<%= editUser != null ? editUser.getEmail() : "" %>" required>
        <input type="submit" value="<%= editUser != null ? "Update" : "Add" %>">
        <% if (editUser != null) { %>
        <a href="manageParticipants.jsp">Cancel Edit</a>
        <% } %>
    </form>

    <!-- Existing Participants -->
    <h3>Existing Participants</h3>
    <% if (users.isEmpty()) { %>
    <p>No participants available.</p>
    <% } else { %>
    <table>
        <tr><th>ID</th><th>Username</th><th>Email</th><th>Actions</th></tr>
        <% for (User user : users) { %>
        <tr>
            <td><%= user.getUserId() %></td>
            <td><%= user.getUsername() %></td>
            <td><%= user.getEmail() %></td>
            <td>
                <a href="manageParticipants.jsp?editUserId=<%= user.getUserId() %>" class="button edit">Edit</a>
                <form action="manageParticipants.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                    <input type="submit" value="Delete">
                </form>
            </td>
        </tr>
        <% } %>
    </table>
    <% } %>
    <a href="dashboard.jsp">Back to Dashboard</a>
</div>
</body>
</html>