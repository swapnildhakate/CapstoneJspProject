package com.project.util;

import java.sql.*;

public class DBUtil {
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(DBUtilHelperConstant.DRIVER);
            return DriverManager.getConnection(
                    DBUtilHelperConstant.URL,
                    DBUtilHelperConstant.USERNAME,
                    DBUtilHelperConstant.PASSWORD
            );
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found", e);
        }
    }

    public static void closeResources(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}