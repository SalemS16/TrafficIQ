package com.trafficiq.controller;

import com.trafficiq.dao.SignalDAO;
import com.trafficiq.model.Signal;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/updateSignal")
public class UpdateSignalServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int signalId =
                    Integer.parseInt(
                            request.getParameter("signalId")
                    );

            int junctionId =
                    Integer.parseInt(
                            request.getParameter("junctionId")
                    );


            String direction =
                    request.getParameter("direction");

            int greenTime =
                    Integer.parseInt(
                            request.getParameter("greenTime")
                    );

            int yellowTime =
                    Integer.parseInt(
                            request.getParameter("yellowTime")
                    );

            int redTime =
                    Integer.parseInt(
                            request.getParameter("redTime")
                    );

            String status =
                    request.getParameter("status");


            Signal signal =
                    new Signal();

            signal.setSignalId(signalId);
            signal.setJunctionId(junctionId);
            signal.setDirection(direction);
            signal.setGreenTime(greenTime);
            signal.setYellowTime(yellowTime);
            signal.setRedTime(redTime);
            signal.setStatus(status);

            // Keep signal active only when status is ACTIVE
            signal.setActive(
                    "ACTIVE".equalsIgnoreCase(status)
            );

            // For now, preserve a default order
            signal.setDisplayOrder(0);


            SignalDAO dao =
                    new SignalDAO();

            dao.updateSignal(signal);


            // Return to the SAME junction
            response.sendRedirect(
                    "junctionSignals?junctionId=" + junctionId
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("junctions");
        }
    }
}
