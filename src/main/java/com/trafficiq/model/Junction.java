package com.trafficiq.model;

public class Junction {

    private int junctionId;
    private String junctionName;
    private String area;
    private int totalLanes;
    private String status;
    private String createdAt;

    public Junction() {
    }

    public Junction(int junctionId, String junctionName, String area,
                    int totalLanes, String status, String createdAt) {
        this.junctionId = junctionId;
        this.junctionName = junctionName;
        this.area = area;
        this.totalLanes = totalLanes;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getJunctionId() {
        return junctionId;
    }

    public void setJunctionId(int junctionId) {
        this.junctionId = junctionId;
    }

    public String getJunctionName() {
        return junctionName;
    }

    public void setJunctionName(String junctionName) {
        this.junctionName = junctionName;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public int getTotalLanes() {
        return totalLanes;
    }

    public void setTotalLanes(int totalLanes) {
        this.totalLanes = totalLanes;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
}
