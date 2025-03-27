package com.project.dao;

import com.project.bean.Batch;
import com.project.bean.User;
import com.project.util.DBUtil;
import java.sql.*;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    // Password hashing method
    private String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashedBytes = md.digest(password.getBytes());
        StringBuilder sb = new StringBuilder();
        for (byte b : hashedBytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    public boolean registerUser(User user) {
        String query = "INSERT INTO user (username, password, email) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, hashPassword(user.getPassword()));
            pstmt.setString(3, user.getEmail());
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public User validateUser(String username, String password) {
        String query = "SELECT * FROM user WHERE username = ? AND password = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, username);
            pstmt.setString(2, hashPassword(password));
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean enrollUserInBatch(int userId, int batchId) {
        String query = "INSERT INTO enrollment (user_id, batch_id) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, batchId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Method to get all users
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM user";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                // Note: Password is not retrieved for security reasons
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Method to delete a user
    public boolean deleteUser(int userId) {
        String query = "DELETE FROM user WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Method to update a user (for edit functionality)
    public boolean updateUser(User user) {
        String query = "UPDATE user SET username = ?, password = ?, email = ? WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, hashPassword(user.getPassword()));
            pstmt.setString(3, user.getEmail());
            pstmt.setInt(4, user.getUserId());
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // New method: Get enrolled batches for a user
    public List<Batch> getEnrolledBatches(int userId) {
        List<Batch> enrolledBatches = new ArrayList<>();
        String query = "SELECT b.* FROM batch b JOIN enrollment e ON b.batch_id = e.batch_id WHERE e.user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Batch batch = new Batch();
                batch.setBatchId(rs.getInt("batch_id"));
                batch.setBatchName(rs.getString("batch_name"));
                batch.setStartDate(rs.getDate("start_date"));
                batch.setEndDate(rs.getDate("end_date"));
                batch.setTime(rs.getString("time"));
                enrolledBatches.add(batch);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return enrolledBatches;
    }

    // New method: Update enrollment (change batch for a user)
    public boolean updateEnrollment(int userId, int oldBatchId, int newBatchId) {
        String query = "UPDATE enrollment SET batch_id = ? WHERE user_id = ? AND batch_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, newBatchId);
            pstmt.setInt(2, userId);
            pstmt.setInt(3, oldBatchId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // New method: Delete enrollment
    public boolean deleteEnrollment(int userId, int batchId) {
        String query = "DELETE FROM enrollment WHERE user_id = ? AND batch_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, batchId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // New method: Get all enrollments with user and batch details
    public List<Object[]> getAllEnrollments() {
        List<Object[]> enrollments = new ArrayList<>();
        String query = "SELECT u.username, u.email, b.batch_name, b.start_date, b.end_date, b.time " +
                "FROM enrollment e " +
                "JOIN user u ON e.user_id = u.user_id " +
                "JOIN batch b ON e.batch_id = b.batch_id";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Object[] enrollment = new Object[6];
                enrollment[0] = rs.getString("username");     // User username
                enrollment[1] = rs.getString("email");        // User email
                enrollment[2] = rs.getString("batch_name");   // Batch name
                enrollment[3] = rs.getDate("start_date");     // Batch start date
                enrollment[4] = rs.getDate("end_date");       // Batch end date
                enrollment[5] = rs.getString("time");         // Batch time
                enrollments.add(enrollment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return enrollments;
    }
}