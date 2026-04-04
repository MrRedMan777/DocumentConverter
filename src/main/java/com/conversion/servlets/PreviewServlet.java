package com.conversion.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;

@WebServlet(name = "PreviewServlet", urlPatterns = {"/preview"})
public class PreviewServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fileName = request.getParameter("file");
        if (fileName == null || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Nom de fichier manquant");
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
        
        if (!file.exists()) {
            response.getWriter().write("<div class='alert alert-danger'>Fichier non trouvé : " + fileName + "</div>");
            return;
        }
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Lire le contenu selon le type de fichier
            String content = readFileContent(file);
            response.getWriter().write(content);
            
        } catch (Exception e) {
            response.getWriter().write("<div class='alert alert-warning'>Impossible de lire le fichier : " + e.getMessage() + "</div>");
        }
    }
    
    private String readFileContent(File file) throws IOException {
        StringBuilder content = new StringBuilder();
        
        // Pour les fichiers texte
        if (file.getName().toLowerCase().endsWith(".txt")) {
            try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    content.append(escapeHtml(line)).append("\n");
                }
            }
        }
        // Pour les fichiers PDF convertis en texte
        else if (file.getName().toLowerCase().endsWith(".pdf")) {
            content.append("<div class='alert alert-info'>");
            content.append("<i class='bi bi-info-circle me-2'></i>");
            content.append("Aperçu PDF non disponible. Veuillez télécharger le fichier.");
            content.append("</div>");
        }
        // Pour les autres fichiers
        else {
            content.append("<div class='alert alert-info'>");
            content.append("<h5><i class='bi bi-file-earmark me-2'></i>").append(file.getName()).append("</h5>");
            content.append("<p>Taille : ").append(formatFileSize(file.length())).append("</p>");
            content.append("<p>Type : ").append(getFileType(file.getName())).append("</p>");
            content.append("<div class='mt-3'>");
            content.append("<button class='btn btn-primary' onclick='downloadFile()'>");
            content.append("<i class='bi bi-download me-2'></i>Télécharger");
            content.append("</button>");
            content.append("</div>");
            content.append("</div>");
        }
        
        return content.toString();
    }
    
    private String escapeHtml(String text) {
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }
    
    private String formatFileSize(long size) {
        if (size < 1024) return size + " bytes";
        if (size < 1024 * 1024) return (size / 1024) + " KB";
        return (size / (1024 * 1024)) + " MB";
    }
    
    private String getFileType(String fileName) {
        if (fileName.toLowerCase().endsWith(".pdf")) return "PDF Document";
        if (fileName.toLowerCase().endsWith(".doc") || fileName.toLowerCase().endsWith(".docx")) return "Word Document";
        if (fileName.toLowerCase().endsWith(".xls") || fileName.toLowerCase().endsWith(".xlsx")) return "Excel Spreadsheet";
        if (fileName.toLowerCase().endsWith(".txt")) return "Text File";
        return "File";
    }
}