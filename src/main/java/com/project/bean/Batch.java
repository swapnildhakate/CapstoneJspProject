package com.project.bean;

import java.util.Date;

public class Batch {
    private int batchId;
    private String batchName; // Will be "Morning" or "Evening"
    private Date startDate;
    private Date endDate;
    private String time; // Will be selected from predefined times (e.g., "9:00 AM")

    // Default constructor
    public Batch() {}

    // Parameterized constructor
    public Batch(int batchId, String batchName, Date startDate, Date endDate, String time) {
        this.batchId = batchId;
        this.batchName = batchName;
        this.startDate = startDate;
        this.endDate = endDate;
        this.time = time;
    }

    // Getters and Setters
    public int getBatchId() { return batchId; }
    public void setBatchId(int batchId) { this.batchId = batchId; }
    public String getBatchName() { return batchName; }
    public void setBatchName(String batchName) { this.batchName = batchName; }
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
    public String getTime() { return time; }
    public void setTime(String time) { this.time = time; }
}