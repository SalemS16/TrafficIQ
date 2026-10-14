package com.trafficiq.model;

public class TrafficState {

    private int signalId;
    private int vehicleCount;
    private int waitingTime;
    private int vehiclesPassed;
    private int totalWaitingTime;

    public TrafficState() {
    }

    public TrafficState(int signalId, int vehicleCount) {
        this.signalId = signalId;
        this.vehicleCount = vehicleCount;
        this.waitingTime = 0;
        this.vehiclesPassed = 0;
        this.totalWaitingTime = 0;
    }

    public int getSignalId() {
        return signalId;
    }

    public void setSignalId(int signalId) {
        this.signalId = signalId;
    }

    public int getVehicleCount() {
        return vehicleCount;
    }

    public void setVehicleCount(int vehicleCount) {
        this.vehicleCount = vehicleCount;
    }

    public int getWaitingTime() {
        return waitingTime;
    }

    public void setWaitingTime(int waitingTime) {
        this.waitingTime = waitingTime;
    }

    public int getVehiclesPassed() {
        return vehiclesPassed;
    }

    public void setVehiclesPassed(int vehiclesPassed) {
        this.vehiclesPassed = vehiclesPassed;
    }

    public int getTotalWaitingTime() {
        return totalWaitingTime;
    }

    public void setTotalWaitingTime(int totalWaitingTime) {
        this.totalWaitingTime = totalWaitingTime;
    }
}