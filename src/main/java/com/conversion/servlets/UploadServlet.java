package com.conversion.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;

@WebServlet(name = "UploadServlet", urlPatterns = {"/upload"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 15
)
public class UploadServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Créer dossier uploads
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Récupérer le fichier
            Part filePart = request.getPart("file");
            
            if (filePart == null || filePart.getSize() == 0) {
                request.setAttribute("error", "Veuillez sélectionner un fichier");
                request.getRequestDispatcher("upload.jsp").forward(request, response);
                return;
            }
            
            // Nom du fichier
            String fileName = getFileName(filePart);
            
            // Sauvegarder
            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);
            
            // Déterminer type
            String fileType = getFileType(fileName);
            
            // Stocker en session
            HttpSession session = request.getSession();
            session.setAttribute("uploadedFile", fileName);
            session.setAttribute("filePath", filePath);
            session.setAttribute("fileType", fileType);
            
            // REDIRECTION CORRECTE
            response.sendRedirect("upload.jsp?step=conversion");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur upload: " + e.getMessage());
            request.getRequestDispatcher("upload.jsp").forward(request, response);
        }
    }
    
    private String getFileName(Part part) {
        String content = part.getHeader("content-disposition");
        String[] items = content.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf("=") + 2, item.length() - 1);
            }
        }
        return "file";
    }
    
    private String getFileType(String fileName) {
        if (fileName == null) return "unknown";
        String lower = fileName.toLowerCase();
        if (lower.endsWith(".pdf")) return "pdf";
        if (lower.endsWith(".doc") || lower.endsWith(".docx")) return "word";
        if (lower.endsWith(".xls") || lower.endsWith(".xlsx")) return "excel";
        if (lower.endsWith(".txt")) return "text";
        return "other";
    }
}