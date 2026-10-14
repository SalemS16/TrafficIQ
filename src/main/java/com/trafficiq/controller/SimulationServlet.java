package com.trafficiq.controller;

import com.trafficiq.dao.JunctionDAO;
import com.trafficiq.model.Signal;
import com.trafficiq.service.SimulationManager;
import com.trafficiq.service.SimulationManager.JunctionSimulation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/simulation")
public class SimulationServlet extends HttpServlet {

    private final JunctionDAO junctionDAO =
            new JunctionDAO();

    private final SimulationManager simulationManager =
            SimulationManager.getInstance();


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        /*
         * Junction dropdown.
         */
        request.setAttribute(
                "junctionList",
                junctionDAO.getAllJunctions()
        );


        /*
         * Selected junction.
         */
        String junctionIdParam =
                request.getParameter("junctionId");


        if (
                junctionIdParam != null &&
                        !junctionIdParam.trim().isEmpty()
        ) {

            try {

                int junctionId =
                        Integer.parseInt(
                                junctionIdParam
                        );


                /*
                 * Get persistent simulation.
                 */
                JunctionSimulation simulation =
                        simulationManager.getSimulation(
                                junctionId
                        );


                List<Signal> signals =
                        simulation.getSignals();


                request.setAttribute(
                        "selectedJunctionId",
                        junctionId
                );


                request.setAttribute(
                        "signals",
                        signals
                );


                request.setAttribute(
                        "trafficStates",
                        simulation.getTrafficStates()
                );


                request.setAttribute(
                        "currentPhase",
                        simulation.getCurrentPhase()
                );


                request.setAttribute(
                        "phaseTimer",
                        simulation.getPhaseTimer()
                );


                request.setAttribute(
                        "globalRunning",
                        simulationManager.isGlobalRunning()
                );


                request.setAttribute(
                        "junctionPaused",
                        simulation.isPaused()
                );
            }

            catch (NumberFormatException e) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid junction ID"
                );

                return;
            }
        }


        request.getRequestDispatcher(
                "/simulation/simulation.jsp"
        ).forward(
                request,
                response
        );
    }
}