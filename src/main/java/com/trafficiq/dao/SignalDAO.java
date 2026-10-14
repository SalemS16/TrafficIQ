package com.trafficiq.dao;

import com.trafficiq.model.Signal;
import com.trafficiq.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SignalDAO {

    // ==========================
    // Get All Signals
    // ==========================
    public List<Signal> getAllSignals() {

        List<Signal> signalList = new ArrayList<>();

        try {

            Connection con = DBConnection.getConnection();

            String sql =
                    "SELECT s.*, j.junction_name " +
                            "FROM signals s " +
                            "INNER JOIN junctions j " +
                            "ON s.junction_id = j.junction_id";

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Signal signal = new Signal();

                signal.setSignalId(rs.getInt("signal_id"));
                signal.setJunctionId(rs.getInt("junction_id"));
                signal.setJunctionName(rs.getString("junction_name"));
                signal.setDirection(rs.getString("direction"));
                signal.setGreenTime(rs.getInt("green_time"));
                signal.setYellowTime(rs.getInt("yellow_time"));
                signal.setRedTime(rs.getInt("red_time"));
                signal.setStatus(rs.getString("status"));
                signal.setDisplayOrder(rs.getInt("display_order"));
                signal.setActive(rs.getBoolean("is_active"));

                signalList.add(signal);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return signalList;
    }

    // ==========================
    // Add Signal
    // ==========================
    public void addSignal(Signal signal) {

        try {

            Connection con = DBConnection.getConnection();

            String sql =
                    "INSERT INTO signals(junction_id,direction,green_time,yellow_time,red_time,status,display_order,is_active) " +
                            "VALUES(?,?,?,?,?,?,?,?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, signal.getJunctionId());
            ps.setString(2, signal.getDirection());
            ps.setInt(3, signal.getGreenTime());
            ps.setInt(4, signal.getYellowTime());
            ps.setInt(5, signal.getRedTime());
            ps.setString(6, signal.getStatus());
            ps.setInt(7, signal.getDisplayOrder());
            ps.setBoolean(8, signal.isActive());
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    // ==========================
    // Get Signal By ID
    // ==========================
    public Signal getSignalById(int signalId) {

        Signal signal = null;

        try {

            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM signals WHERE signal_id=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, signalId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                signal = new Signal();

                signal.setSignalId(rs.getInt("signal_id"));
                signal.setJunctionId(rs.getInt("junction_id"));
                signal.setDirection(rs.getString("direction"));
                signal.setGreenTime(rs.getInt("green_time"));
                signal.setYellowTime(rs.getInt("yellow_time"));
                signal.setRedTime(rs.getInt("red_time"));
                signal.setStatus(rs.getString("status"));
                signal.setDisplayOrder(rs.getInt("display_order"));
                signal.setActive(rs.getBoolean("is_active"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return signal;
    }

    // ==========================
    // Update Signal
    // ==========================
    public void updateSignal(Signal signal) {

        try {

            Connection con = DBConnection.getConnection();

            String sql =
                    "UPDATE signals SET " +
                            "junction_id=?,direction=?,green_time=?,yellow_time=?,red_time=?,status=?,display_order=?,is_active=? " +
                            "WHERE signal_id=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, signal.getJunctionId());
            ps.setString(2, signal.getDirection());
            ps.setInt(3, signal.getGreenTime());
            ps.setInt(4, signal.getYellowTime());
            ps.setInt(5, signal.getRedTime());
            ps.setString(6, signal.getStatus());
            ps.setInt(7, signal.getDisplayOrder());
            ps.setBoolean(8, signal.isActive());
            ps.setInt(9, signal.getSignalId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    // ==========================
    // Delete Signal
    // ==========================
    public void deleteSignal(int signalId) {

        try {

            Connection con = DBConnection.getConnection();

            String sql = "DELETE FROM signals WHERE signal_id=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, signalId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

    }
    public int getTotalSignals() {

        int count = 0;

        try {

            Connection con = DBConnection.getConnection();

            String sql = "SELECT COUNT(*) FROM signals";

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }
    // ==========================
// Get Signals By Junction
// ==========================
    public List<Signal> getSignalsByJunction(int junctionId) {

        List<Signal> signalList = new ArrayList<>();

        try {

            Connection con = DBConnection.getConnection();

            String sql =
                    "SELECT * FROM signals " +
                            "WHERE junction_id=? " +
                            "ORDER BY display_order";

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setInt(1, junctionId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Signal signal = new Signal();

                signal.setSignalId(
                        rs.getInt("signal_id")
                );

                signal.setJunctionId(
                        rs.getInt("junction_id")
                );

                signal.setDirection(
                        rs.getString("direction")
                );

                signal.setGreenTime(
                        rs.getInt("green_time")
                );

                signal.setYellowTime(
                        rs.getInt("yellow_time")
                );

                signal.setRedTime(
                        rs.getInt("red_time")
                );

                signal.setStatus(
                        rs.getString("status")
                );

                signal.setDisplayOrder(
                        rs.getInt("display_order")
                );

                signal.setActive(
                        rs.getBoolean("is_active")
                );

                signalList.add(signal);
            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return signalList;
    }

}