package com.trafficiq.controller;

import com.trafficiq.dao.SignalDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/deleteSignal")
public class DeleteSignalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int signalId =
                    Integer.parseInt(
                            request.getParameter("id")
                    );

            int junctionId =
                    Integer.parseInt(
                            request.getParameter("junctionId")
                    );


            SignalDAO dao =
                    new SignalDAO();

            dao.deleteSignal(signalId);


            // Return to same junction
            response.sendRedirect(
                    "junctionSignals?junctionId=" + junctionId
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("junctions");
        }
    }
}
