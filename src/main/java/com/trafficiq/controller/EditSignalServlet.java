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

@WebServlet("/editSignal")
public class EditSignalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int signalId =
                    Integer.parseInt(
                            request.getParameter("id")
                    );

            SignalDAO signalDAO =
                    new SignalDAO();

            JunctionDAO junctionDAO =
                    new JunctionDAO();


            Signal signal =
                    signalDAO.getSignalById(signalId);

            if (signal == null) {

                response.sendRedirect("junctions");

                return;
            }


            Junction junction =
                    junctionDAO.getJunctionById(
                            signal.getJunctionId()
                    );


            request.setAttribute(
                    "signal",
                    signal
            );

            request.setAttribute(
                    "junction",
                    junction
            );


            request.getRequestDispatcher(
                    "/signal/editSignal.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("junctions");
        }
    }
}