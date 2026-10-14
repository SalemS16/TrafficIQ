package com.trafficiq.dao;

import com.trafficiq.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DashboardDAO {

    public int getTotalJunctions() {

        int total = 0;

        try {

            Connection con = DBConnection.getConnection();

            String sql = "SELECT COUNT(*) FROM junctions";

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                total = rs.getInt(1);
            }

        } catch (Exception e){
            e.printStackTrace();
        }

        return total;
    }

}