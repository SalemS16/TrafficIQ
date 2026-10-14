package com.trafficiq.dao;

import com.trafficiq.model.Junction;
import com.trafficiq.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class JunctionDAO {

    public List<Junction> getAllJunctions() {

        List<Junction> junctionList = new ArrayList<>();

        try {

            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM junctions";

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Junction junction = new Junction();

                junction.setJunctionId(rs.getInt("junction_id"));
                junction.setJunctionName(rs.getString("junction_name"));
                junction.setArea(rs.getString("area"));
                junction.setStatus(rs.getString("status"));
                junction.setCreatedAt(rs.getString("created_at"));

                junctionList.add(junction);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return junctionList;
    }
    public boolean addJunction(Junction junction) {

        boolean status = false;

        try {

            Connection con = DBConnection.getConnection();

            String sql =
                    "INSERT INTO junctions(junction_name, area, status) " +
                            "VALUES (?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, junction.getJunctionName());
            ps.setString(2, junction.getArea());
            ps.setString(3, junction.getStatus());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                status = true;
            }

        } catch (Exception e) {

            e.printStackTrace();

            System.out.println("ADD JUNCTION ERROR: " + e.getMessage());
        }

        return status;
    }
    public Junction getJunctionById(int id) {

        Junction junction = null;

        try {

            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM junctions WHERE junction_id = ?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                junction = new Junction();

                junction.setJunctionId(rs.getInt("junction_id"));
                junction.setJunctionName(rs.getString("junction_name"));
                junction.setArea(rs.getString("area"));
                junction.setStatus(rs.getString("status"));
                junction.setCreatedAt(rs.getString("created_at"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return junction;
    }
    public boolean updateJunction(Junction junction) {

        boolean status = false;

        try {

            Connection con = DBConnection.getConnection();

            String sql =
                    "UPDATE junctions " +
                            "SET junction_name=?, area=?, status=? " +
                            "WHERE junction_id=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, junction.getJunctionName());
            ps.setString(2, junction.getArea());
            ps.setString(3, junction.getStatus());
            ps.setInt(4, junction.getJunctionId());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                status = true;
            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return status;
    }
    public boolean deleteJunction(int id) {

        boolean status = false;

        try {

            Connection con = DBConnection.getConnection();

            String sql = "DELETE FROM junctions WHERE junction_id = ?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, id);

            int rows = ps.executeUpdate();

            if(rows > 0){
                status = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
    public int getTotalJunctions() {

        int count = 0;

        try {

            Connection con = DBConnection.getConnection();

            String sql = "SELECT COUNT(*) FROM junctions";

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
}