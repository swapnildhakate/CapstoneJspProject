package com.project.dao;

import com.project.bean.Batch;
import com.project.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BatchDAO {
    public boolean addBatch(Batch batch) {
        String query = "INSERT INTO batch (batch_name, start_date, end_date, time) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, batch.getBatchName());
            pstmt.setDate(2, new java.sql.Date(batch.getStartDate().getTime()));
            pstmt.setDate(3, new java.sql.Date(batch.getEndDate().getTime()));
            pstmt.setString(4, batch.getTime());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Batch> getAllBatches() {
        List<Batch> batches = new ArrayList<>();
        String query = "SELECT * FROM batch";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Batch batch = new Batch();
                batch.setBatchId(rs.getInt("batch_id"));
                batch.setBatchName(rs.getString("batch_name"));
                batch.setStartDate(rs.getDate("start_date"));
                batch.setEndDate(rs.getDate("end_date"));
                batch.setTime(rs.getString("time"));
                batches.add(batch);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return batches;
    }

    public boolean updateBatch(Batch batch) {
        String query = "UPDATE batch SET batch_name = ?, start_date = ?, end_date = ?, time = ? WHERE batch_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, batch.getBatchName());
            pstmt.setDate(2, new java.sql.Date(batch.getStartDate().getTime()));
            pstmt.setDate(3, new java.sql.Date(batch.getEndDate().getTime()));
            pstmt.setString(4, batch.getTime());
            pstmt.setInt(5, batch.getBatchId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteBatch(int batchId) {
        String query = "DELETE FROM batch WHERE batch_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, batchId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}