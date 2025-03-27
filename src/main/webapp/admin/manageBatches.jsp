<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.dao.BatchDAO, com.project.bean.Batch, java.util.*, java.text.SimpleDateFormat, java.sql.*" %>
<%
  // Restrict access to admin only
  if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
    response.sendRedirect("../login.jsp");
    return;
  }

  BatchDAO batchDAO = new BatchDAO();
  List<Batch> batches = batchDAO.getAllBatches();
  String action = request.getParameter("action");
  String error = null;
  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

  // Handle actions
  if ("add".equals(action)) {
    Batch batch = new Batch();
    batch.setBatchName(request.getParameter("batchName"));
    try {
      batch.setStartDate(sdf.parse(request.getParameter("startDate")));
      batch.setEndDate(sdf.parse(request.getParameter("endDate")));
      batch.setTime(request.getParameter("time"));
      if (batchDAO.addBatch(batch)) {
        batches = batchDAO.getAllBatches(); // Refresh list
      } else {
        error = "Failed to add batch";
      }
    } catch (Exception e) {
      error = "Invalid date format or data: " + e.getMessage();
    }
  } else if ("delete".equals(action)) {
    int batchId = Integer.parseInt(request.getParameter("batchId"));
    if (batchDAO.deleteBatch(batchId)) {
      batches = batchDAO.getAllBatches(); // Refresh list
    } else {
      error = "Failed to delete batch";
    }
  } else if ("update".equals(action)) {
    int batchId = Integer.parseInt(request.getParameter("batchId"));
    Batch batch = new Batch();
    batch.setBatchId(batchId);
    batch.setBatchName(request.getParameter("batchName"));
    try {
      batch.setStartDate(sdf.parse(request.getParameter("startDate")));
      batch.setEndDate(sdf.parse(request.getParameter("endDate")));
      batch.setTime(request.getParameter("time"));
      if (batchDAO.updateBatch(batch)) {
        batches = batchDAO.getAllBatches(); // Refresh list
      } else {
        error = "Failed to update batch";
      }
    } catch (Exception e) {
      error = "Invalid date format or data: " + e.getMessage();
    }
  }

  // Handle edit mode
  String editBatchIdStr = request.getParameter("editBatchId");
  Batch editBatch = null;
  if (editBatchIdStr != null) {
    int editBatchId = Integer.parseInt(editBatchIdStr);
    String query = "SELECT * FROM batch WHERE batch_id = ?";
    try (Connection conn = com.project.util.DBUtil.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(query)) {
      pstmt.setInt(1, editBatchId);
      ResultSet rs = pstmt.executeQuery();
      if (rs.next()) {
        editBatch = new Batch();
        editBatch.setBatchId(rs.getInt("batch_id"));
        editBatch.setBatchName(rs.getString("batch_name"));
        editBatch.setStartDate(rs.getDate("start_date"));
        editBatch.setEndDate(rs.getDate("end_date"));
        editBatch.setTime(rs.getString("time"));
      }
    } catch (SQLException e) {
      e.printStackTrace();
      error = "Error loading batch for edit: " + e.getMessage();
    }
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Manage Batches - Yamin's Zumba Studio</title>
  <link rel="stylesheet" href="../style.css">
</head>
<body>
<div class="container">
  <h2>Manage Batches</h2>
  <% if (error != null) { %>
  <p class="error"><%= error %></p>
  <% } %>

  <!-- Add/Edit Batch Form -->
  <h3><%= editBatch != null ? "Edit Batch" : "Add New Batch" %></h3>
  <form action="manageBatches.jsp" method="post">
    <% if (editBatch != null) { %>
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="batchId" value="<%= editBatch.getBatchId() %>">
    <% } else { %>
    <input type="hidden" name="action" value="add">
    <% } %>
    <label for="batchName">Batch Name:</label>
    <select id="batchName" name="batchName" required>
      <option value="">Select Batch Name</option>
      <option value="Morning" <%= editBatch != null && "Morning".equals(editBatch.getBatchName()) ? "selected" : "" %>>Morning</option>
      <option value="Evening" <%= editBatch != null && "Evening".equals(editBatch.getBatchName()) ? "selected" : "" %>>Evening</option>
    </select>
    <label for="startDate">Start Date:</label>
    <input type="date" id="startDate" name="startDate" value="<%= editBatch != null ? sdf.format(editBatch.getStartDate()) : "" %>" required>
    <label for="endDate">End Date:</label>
    <input type="date" id="endDate" name="endDate" value="<%= editBatch != null ? sdf.format(editBatch.getEndDate()) : "" %>" required>
    <label for="time">Time:</label>
    <select id="time" name="time" required>
      <option value="">Select Time</option>
      <option value="8:00 AM" <%= editBatch != null && "8:00 AM".equals(editBatch.getTime()) ? "selected" : "" %>>8:00 AM</option>
      <option value="9:00 AM" <%= editBatch != null && "9:00 AM".equals(editBatch.getTime()) ? "selected" : "" %>>9:00 AM</option>
      <option value="10:00 AM" <%= editBatch != null && "10:00 AM".equals(editBatch.getTime()) ? "selected" : "" %>>10:00 AM</option>
      <option value="11:00 AM" <%= editBatch != null && "11:00 AM".equals(editBatch.getTime()) ? "selected" : "" %>>11:00 AM</option>
      <option value="5:00 PM" <%= editBatch != null && "5:00 PM".equals(editBatch.getTime()) ? "selected" : "" %>>5:00 PM</option>
      <option value="6:00 PM" <%= editBatch != null && "6:00 PM".equals(editBatch.getTime()) ? "selected" : "" %>>6:00 PM</option>
      <option value="7:00 PM" <%= editBatch != null && "7:00 PM".equals(editBatch.getTime()) ? "selected" : "" %>>7:00 PM</option>
    </select>
    <input type="submit" value="<%= editBatch != null ? "Update" : "Add" %>">
    <% if (editBatch != null) { %>
    <a href="manageBatches.jsp">Cancel Edit</a>
    <% } %>
  </form>

  <!-- Existing Batches -->
  <h3>Existing Batches</h3>
  <% if (batches.isEmpty()) { %>
  <p>No batches available.</p>
  <% } else { %>
  <table>
    <tr><th>ID</th><th>Name</th><th>Start Date</th><th>End Date</th><th>Time</th><th>Actions</th></tr>
    <% for (Batch batch : batches) { %>
    <tr>
      <td><%= batch.getBatchId() %></td>
      <td><%= batch.getBatchName() %></td>
      <td><%= batch.getStartDate() %></td>
      <td><%= batch.getEndDate() %></td>
      <td><%= batch.getTime() %></td>
      <td>
        <a href="manageBatches.jsp?editBatchId=<%= batch.getBatchId() %>" class="button edit">Edit</a>
        <form action="manageBatches.jsp" method="post" style="display:inline;">
          <input type="hidden" name="action" value="delete">
          <input type="hidden" name="batchId" value="<%= batch.getBatchId() %>">
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