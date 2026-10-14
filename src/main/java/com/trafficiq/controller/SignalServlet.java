package com.trafficiq.controller;

import com.trafficiq.dao.SignalDAO;
import com.trafficiq.model.Signal;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/signals")
public class SignalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        SignalDAO dao = new SignalDAO();

        List<Signal> signalList = dao.getAllSignals();

        request.setAttribute("signalList", signalList);

        request.getRequestDispatcher("/signal/signals.jsp")
                .forward(request,response);

    }
}
