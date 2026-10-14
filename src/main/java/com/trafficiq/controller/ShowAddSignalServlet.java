package com.trafficiq.controller;

import com.trafficiq.dao.JunctionDAO;
import com.trafficiq.dao.SignalDAO;
import com.trafficiq.model.Junction;
import com.trafficiq.model.Signal;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/showAddSignal")
public class ShowAddSignalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        int junctionId = Integer.parseInt(
                request.getParameter("junctionId")
        );

        JunctionDAO junctionDAO = new JunctionDAO();
        SignalDAO signalDAO = new SignalDAO();

        // Get selected junction
        Junction junction =
                junctionDAO.getJunctionById(junctionId);

        // Get signals already added to this junction
        List<Signal> existingSignals =
                signalDAO.getSignalsByJunction(junctionId);

        request.setAttribute("junction", junction);

        request.setAttribute(
                "existingSignals",
                existingSignals
        );

        request.getRequestDispatcher("/signal/addSignal.jsp")
                .forward(request, response);
    }
}