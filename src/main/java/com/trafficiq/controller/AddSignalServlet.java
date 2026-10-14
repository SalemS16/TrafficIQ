package com.trafficiq.controller;

import com.trafficiq.dao.SignalDAO;
import com.trafficiq.model.Signal;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/addSignal")
public class AddSignalServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int junctionId = Integer.parseInt(
                    request.getParameter("junctionId")
            );

            String direction =
                    request.getParameter("direction");

            int greenTime = Integer.parseInt(
                    request.getParameter("greenTime")
            );

            int yellowTime = Integer.parseInt(
                    request.getParameter("yellowTime")
            );

            int redTime = Integer.parseInt(
                    request.getParameter("redTime")
            );

            String status =
                    request.getParameter("status");


            Signal signal = new Signal();

            signal.setJunctionId(junctionId);
            signal.setDirection(direction);
            signal.setGreenTime(greenTime);
            signal.setYellowTime(yellowTime);
            signal.setRedTime(redTime);
            signal.setStatus(status);

            // Default values
            signal.setDisplayOrder(1);

            signal.setActive(
                    "ACTIVE".equals(status)
            );


            SignalDAO signalDAO =
                    new SignalDAO();

            signalDAO.addSignal(signal);


            response.sendRedirect(
                    "junctionSignals?junctionId=" + junctionId
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().println(
                    "Error while adding signal: "
                            + e.getMessage()
            );
        }
    }
}
