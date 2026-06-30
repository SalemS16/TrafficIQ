package com.trafficiq.controller;

import com.trafficiq.dao.JunctionDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/deleteJunction")
public class DeleteJunctionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        JunctionDAO dao = new JunctionDAO();

        dao.deleteJunction(id);

        response.sendRedirect("junctions");
    }
}