package com.trafficiq.model;

public class Signal {

    private int signalId;
    private int junctionId;
    private String junctionName;
    private String direction;

    private int greenTime;
    private int yellowTime;
    private int redTime;

    private String status;

    // NEW FIELDS
    private int displayOrder;
    private boolean active;

    // Default Constructor
    public Signal() {
    }

    // Parameterized Constructor
    public Signal(int signalId,
                  int junctionId,
                  String junctionName,
                  String direction,
                  int greenTime,
                  int yellowTime,
                  int redTime,
                  String status,
                  int displayOrder,
                  boolean active) {

        this.signalId = signalId;
        this.junctionId = junctionId;
        this.junctionName = junctionName;
        this.direction = direction;
        this.greenTime = greenTime;
        this.yellowTime = yellowTime;
        this.redTime = redTime;
        this.status = status;
        this.displayOrder = displayOrder;
        this.active = active;
    }

    // ===============================
    // Signal ID
    // ===============================

    public int getSignalId() {
        return signalId;
    }

    public void setSignalId(int signalId) {
        this.signalId = signalId;
    }

    // ===============================
    // Junction ID
    // ===============================

    public int getJunctionId() {
        return junctionId;
    }

    public void setJunctionId(int junctionId) {
        this.junctionId = junctionId;
    }

    // ===============================
    // Junction Name
    // ===============================

    public String getJunctionName() {
        return junctionName;
    }

    public void setJunctionName(String junctionName) {
        this.junctionName = junctionName;
    }

    // ===============================
    // Direction
    // ===============================

    public String getDirection() {
        return direction;
    }

    public void setDirection(String direction) {
        this.direction = direction;
    }

    // ===============================
    // Green Time
    // ===============================

    public int getGreenTime() {
        return greenTime;
    }

    public void setGreenTime(int greenTime) {
        this.greenTime = greenTime;
    }

    // ===============================
    // Yellow Time
    // ===============================

    public int getYellowTime() {
        return yellowTime;
    }

    public void setYellowTime(int yellowTime) {
        this.yellowTime = yellowTime;
    }

    // ===============================
    // Red Time
    // ===============================

    public int getRedTime() {
        return redTime;
    }

    public void setRedTime(int redTime) {
        this.redTime = redTime;
    }

    // ===============================
    // Status
    // ===============================

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // ===============================
    // Display Order
    // ===============================

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }

    // ===============================
    // Active
    // ===============================

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}