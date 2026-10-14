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

@WebServlet("/junctionSignals")
public class JunctionSignalsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int junctionId =
                    Integer.parseInt(
                            request.getParameter("junctionId")
                    );


            JunctionDAO junctionDAO =
                    new JunctionDAO();

            SignalDAO signalDAO =
                    new SignalDAO();


            /*
             * Get the selected junction
             */

            Junction junction =
                    junctionDAO.getJunctionById(junctionId);


            /*
             * Get signals belonging ONLY
             * to this junction
             */

            List<Signal> signalList =
                    signalDAO.getSignalsByJunction(junctionId);


            /*
             * Send data to JSP
             */

            request.setAttribute(
                    "junction",
                    junction
            );

            request.setAttribute(
                    "signalList",
                    signalList
            );


            request.getRequestDispatcher(
                    "/junction/junction-signals.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType("text/html");

            response.getWriter().println("<h3>Error loading junction signals</h3>");
            response.getWriter().println("<p>" + e.getMessage() + "</p>");
        }
    }
}
