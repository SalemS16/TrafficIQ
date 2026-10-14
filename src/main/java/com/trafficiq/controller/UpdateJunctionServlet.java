package com.trafficiq.controller;

import com.trafficiq.dao.JunctionDAO;
import com.trafficiq.model.Junction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/updateJunction")
public class UpdateJunctionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        Junction junction = new Junction();

        junction.setJunctionId(Integer.parseInt(request.getParameter("junctionId")));
        junction.setJunctionName(request.getParameter("junctionName"));
        junction.setArea(request.getParameter("area"));
        junction.setStatus(request.getParameter("status"));

        JunctionDAO dao = new JunctionDAO();

        boolean result = dao.updateJunction(junction);

        if(result){
            response.sendRedirect("junctions");
        }else{
            response.getWriter().println("Update Failed");
        }

    }
}
