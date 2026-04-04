package com.conversion.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import com.conversion.services.*;
import java.io.*;

@WebServlet(name = "ConversionServlet", urlPatterns = {"/convert"})
public class ConversionServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String filePath = (String) session.getAttribute("filePath");
        String conversionType = request.getParameter("conversionType");
        
        if (filePath == null || filePath.isEmpty()) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        try {
            String outputPath = "";
            String outputFileName = "";
            String outputType = "";
            
            switch (conversionType) {
                case "pdfToWord":
                    PdfToWordConverter pdfToWord = new PdfToWordConverter();
                    outputPath = pdfToWord.convert(filePath);
                    outputFileName = new File(filePath).getName().replace(".pdf", ".docx");
                    outputType = "word";
                    break;
                    
                case "wordToPdf":
                    WordToPdfConverter wordToPdf = new WordToPdfConverter();
                    outputPath = wordToPdf.convert(filePath);
                    outputFileName = new File(filePath).getName().replace(".docx", ".pdf")
                                                      .replace(".doc", ".pdf");
                    outputType = "pdf";
                    break;
                    
                case "pdfToExcel":
                    PdfToExcelConverter pdfToExcel = new PdfToExcelConverter();
                    outputPath = pdfToExcel.convert(filePath);
                    outputFileName = new File(filePath).getName().replace(".pdf", ".xlsx");
                    outputType = "excel";
                    break;
            }
            
            // Stocker les informations du fichier converti
            session.setAttribute("convertedFile", outputFileName);
            session.setAttribute("convertedPath", outputPath);
            session.setAttribute("outputType", outputType);
            
            // Rediriger vers la page de résultat
            response.sendRedirect("result.jsp");
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur de conversion: " + e.getMessage());
            request.getRequestDispatcher("upload.jsp").forward(request, response);
        }
    }
}