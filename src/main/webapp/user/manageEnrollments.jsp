<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.dao.UserDAO, com.project.dao.BatchDAO, com.project.bean.Batch, java.util.*" %>
<%
  // Restrict access to logged-in users only
  if (session.getAttribute("role") == null || !session.getAttribute("role").equals("user")) {
    response.sendRedirect("../login.jsp");
    return;
  }

  int userId = (Integer) session.getAttribute("userId");
  UserDAO userDAO = new UserDAO();
  BatchDAO batchDAO = new BatchDAO();
  List<Batch> enrolledBatches = userDAO.getEnrolledBatches(userId);
  List<Batch> availableBatches = batchDAO.getAllBatches();

  // Handle actions based on request parameters
  String action = request.getParameter("action");
  String error = null;

  if ("enroll".equals(action)) {
    int batchId = Integer.parseInt(request.getParameter("batchId"));
    if (userDAO.enrollUserInBatch(userId, batchId)) {
      enrolledBatches = userDAO.getEnrolledBatches(userId); // Refresh list
    } else {
      error = "Enrollment failed.";
    }
  } else if ("delete".equals(action)) {
    int batchId = Integer.parseInt(request.getParameter("batchId"));
    if (userDAO.deleteEnrollment(userId, batchId)) {
      enrolledBatches = userDAO.getEnrolledBatches(userId); // Refresh list
    } else {
      error = "Failed to delete enrollment.";
    }
  } else if ("update".equals(action)) {
    int oldBatchId = Integer.parseInt(request.getParameter("oldBatchId"));
    int newBatchId = Integer.parseInt(request.getParameter("newBatchId"));
    if (userDAO.updateEnrollment(userId, oldBatchId, newBatchId)) {
      enrolledBatches = userDAO.getEnrolledBatches(userId); // Refresh list
    } else {
      error = "Failed to update enrollment.";
    }
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Manage Enrollments</title>
  <link rel="stylesheet" href="../style.css">
</head>
<body>
<div class="container">
  <h2>Manage Your Enrollments</h2>

  <!-- Display error message if any -->
  <% if (error != null) { %>
  <p class="error"><%= error %></p>
  <% } %>

  <!-- Enroll in a New Batch -->
  <h3>Enroll in a New Batch</h3>
  <form action="manageEnrollments.jsp" method="post">
    <input type="hidden" name="action" value="enroll">
    <select name="batchId" required>
      <option value="">Select Batch</option>
      <% for (Batch batch : availableBatches) { %>
      <option value="<%= batch.getBatchId() %>">
        <%= batch.getBatchName() %> Batch - <%= batch.getTime() %>
      </option>
      <% } %>
    </select>
    <input type="submit" value="Enroll">
  </form>

  <!-- View and Manage Enrolled Batches -->
  <h3>Your Enrolled Batches</h3>
  <% if (enrolledBatches.isEmpty()) { %>
  <p>You are not enrolled in any batches yet.</p>
  <% } else { %>
  <table>
    <tr>
      <th>ID</th>
      <th>Name</th>
      <th>Start Date</th>
      <th>End Date</th>
      <th>Time</th>
      <th>Actions</th>
    </tr>
    <% for (Batch batch : enrolledBatches) { %>
    <tr>
      <td><%= batch.getBatchId() %></td>
      <td><%= batch.getBatchName() %></td>
      <td><%= batch.getStartDate() %></td>
      <td><%= batch.getEndDate() %></td>
      <td><%= batch.getTime() %></td>
      <td>
        <!-- Update Form -->
        <form action="manageEnrollments.jsp" method="post" style="display:inline;">
          <input type="hidden" name="action" value="update">
          <input type="hidden" name="oldBatchId" value="<%= batch.getBatchId() %>">
          <select name="newBatchId" required>
            <option value="">Select New Batch</option>
            <% for (Batch availableBatch : availableBatches) { %>
            <option value="<%= availableBatch.getBatchId() %>"
                    <%= availableBatch.getBatchId() == batch.getBatchId() ? "disabled" : "" %>>
              <%= availableBatch.getBatchName() %> - <%= availableBatch.getTime() %>
            </option>
            <% } %>
          </select>
          <input type="submit" value="Update">
        </form>
        <!-- Delete Form -->
        <form action="manageEnrollments.jsp" method="post" style="display:inline;">
          <input type="hidden" name="action" value="delete">
          <input type="hidden" name="batchId" value="<%= batch.getBatchId() %>">
          <input type="submit" value="Delete">
        </form>
      </td>
    </tr>
    <% } %>
  </table>
  <% } %>

  <!-- Back to Dashboard -->
  <a href="dashboard.jsp">Back to Dashboard</a>
</div>
</body>
</html>