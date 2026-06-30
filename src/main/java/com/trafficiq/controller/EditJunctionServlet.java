package com.trafficiq.controller;

import com.trafficiq.dao.JunctionDAO;
import com.trafficiq.model.Junction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/editJunction")
public class EditJunctionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        JunctionDAO junctionDAO = new JunctionDAO();

        Junction junction = junctionDAO.getJunctionById(id);

        request.setAttribute("junction", junction);

        request.getRequestDispatcher("editJunction.jsp")
                .forward(request, response);
    }
}