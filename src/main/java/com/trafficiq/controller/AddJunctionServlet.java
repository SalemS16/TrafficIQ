package com.trafficiq.controller;

import com.trafficiq.dao.JunctionDAO;
import com.trafficiq.model.Junction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/addJunction")
public class AddJunctionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String junctionName = request.getParameter("junctionName");
        String area = request.getParameter("area");
        int totalLanes = Integer.parseInt(request.getParameter("totalLanes"));
        String status = request.getParameter("status");

        Junction junction = new Junction();

        junction.setJunctionName(junctionName);
        junction.setArea(area);
        junction.setTotalLanes(totalLanes);
        junction.setStatus(status);

        JunctionDAO junctionDAO = new JunctionDAO();

        boolean result = junctionDAO.addJunction(junction);

        if(result){
            response.sendRedirect("junctions");
        }else{
            response.getWriter().println("Failed to Add Junction");
        }
    }
}
