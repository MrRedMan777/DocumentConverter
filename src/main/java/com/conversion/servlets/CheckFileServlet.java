package com.conversion.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;

@WebServlet(name = "CheckFileServlet", urlPatterns = {"/checkfile"})
public class CheckFileServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fileName = request.getParameter("file");
        if (fileName == null || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        HttpSession session = request.getSession();
        String convertedPath = (String) session.getAttribute("convertedPath");
        
        // Si le chemin n'est pas en session, chercher dans le dossier converted
        if (convertedPath == null || !new File(convertedPath).exists()) {
            String appPath = getServletContext().getRealPath("");
            convertedPath = appPath + File.separator + "converted" + File.separator + fileName;
        }
        
        File file = new File(convertedPath);
        
        if (file.exists()) {
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("OK");
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("NOT FOUND");
        }
    }
}