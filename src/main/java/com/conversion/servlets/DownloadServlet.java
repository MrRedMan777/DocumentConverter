package com.conversion.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;

@WebServlet(name = "DownloadServlet", urlPatterns = {"/download"})
public class DownloadServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fileName = request.getParameter("file");
        System.out.println("=== DÉBUT TÉLÉCHARGEMENT ===");
        System.out.println("Fichier demandé : " + fileName);
        
        if (fileName == null || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Nom de fichier manquant");
            return;
        }
        
        HttpSession session = request.getSession();
        String convertedPath = (String) session.getAttribute("convertedPath");
        
        System.out.println("Chemin depuis session : " + convertedPath);
        
        File file = null;
        
        // 1. Essayer le chemin de la session
        if (convertedPath != null && new File(convertedPath).exists()) {
            file = new File(convertedPath);
            System.out.println("Fichier trouvé via session : " + convertedPath);
        }
        // 2. Essayer le dossier converted
        else {
            String appPath = getServletContext().getRealPath("");
            String convertedDir = appPath + File.separator + "converted";
            String testPath = convertedDir + File.separator + fileName;
            
            System.out.println("Test du chemin : " + testPath);
            
            file = new File(testPath);
            if (file.exists()) {
                System.out.println("Fichier trouvé dans converted/");
            } else {
                // 3. Essayer le dossier uploads (fichier original)
                String uploadDir = appPath + File.separator + "uploads";
                testPath = uploadDir + File.separator + fileName;
                file = new File(testPath);
                
                if (file.exists()) {
                    System.out.println("Fichier trouvé dans uploads/");
                } else {
                    System.out.println("Fichier non trouvé : " + fileName);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, 
                                     "Fichier non trouvé : " + fileName);
                    return;
                }
            }
        }
        
        System.out.println("Fichier final : " + file.getAbsolutePath());
        System.out.println("Taille : " + file.length() + " bytes");
        
        // Déterminer le type MIME
        String mimeType = getServletContext().getMimeType(file.getName());
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }
        
        // Configurer les headers
        response.setContentType(mimeType);
        response.setContentLength((int) file.length());
        response.setHeader("Content-Disposition", 
                "attachment; filename=\"" + fileName + "\"");
        
        // Copier le fichier vers la réponse
        try (InputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            long totalBytes = 0;
            
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
                totalBytes += bytesRead;
            }
            
            System.out.println("Téléchargement terminé : " + totalBytes + " bytes transférés");
            System.out.println("=== FIN TÉLÉCHARGEMENT ===");
            
        } catch (IOException e) {
            System.out.println("Erreur lors du téléchargement : " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Erreur lors du téléchargement");
        }
    }
}