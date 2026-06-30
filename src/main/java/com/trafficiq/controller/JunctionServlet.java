package com.trafficiq.controller;

import com.trafficiq.dao.JunctionDAO;
import com.trafficiq.model.Junction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/junctions")
public class JunctionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        JunctionDAO junctionDAO = new JunctionDAO();

        List<Junction> junctionList = junctionDAO.getAllJunctions();

        request.setAttribute("junctionList", junctionList);

        request.getRequestDispatcher("junctions.jsp")
                .forward(request, response);
    }
}
