package com.conversion.services;

import org.apache.poi.xwpf.usermodel.*;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import java.io.*;

public class WordToPdfConverter {
    
    public String convert(String wordPath) throws Exception {
        String outputPath = wordPath.replace(".docx", ".pdf")
                                   .replace(".doc", ".pdf");
        
        File wordFile = new File(wordPath);
        if (!wordFile.exists()) {
            throw new FileNotFoundException("Fichier Word non trouvé: " + wordPath);
        }
        
        try (XWPFDocument document = new XWPFDocument(new FileInputStream(wordPath));
             PDDocument pdfDocument = new PDDocument()) {
            
            // Extraire le texte du document Word
            StringBuilder textBuilder = new StringBuilder();
            for (XWPFParagraph paragraph : document.getParagraphs()) {
                textBuilder.append(paragraph.getText()).append("\n");
            }
            
            String text = textBuilder.toString();
            
            if (text.trim().isEmpty()) {
                throw new Exception("Le document Word est vide");
            }
            
            // Diviser le texte en lignes
            String[] lines = text.split("\n");
            
            PDPage currentPage = new PDPage();
            pdfDocument.addPage(currentPage);
            PDPageContentStream contentStream = new PDPageContentStream(pdfDocument, currentPage);
            
            contentStream.beginText();
            contentStream.setFont(PDType1Font.HELVETICA, 12);
            contentStream.newLineAtOffset(50, 750);
            
            float yPosition = 750;
            float leading = 14.5f;
            
            for (String line : lines) {
                String[] wrappedLines = wrapText(line, 100);
                
                for (String wrappedLine : wrappedLines) {
                    if (yPosition < 50) {
                        // Fin de page, créer une nouvelle page
                        contentStream.endText();
                        contentStream.close();
                        
                        currentPage = new PDPage();
                        pdfDocument.addPage(currentPage);
                        contentStream = new PDPageContentStream(pdfDocument, currentPage);
                        contentStream.beginText();
                        contentStream.setFont(PDType1Font.HELVETICA, 12);
                        contentStream.newLineAtOffset(50, 750);
                        yPosition = 750;
                    }
                    
                    contentStream.showText(wrappedLine);
                    contentStream.newLineAtOffset(0, -leading);
                    yPosition -= leading;
                }
            }
            
            contentStream.endText();
            contentStream.close();
            
            // Sauvegarder le PDF
            pdfDocument.save(outputPath);
            
            System.out.println("Conversion Word to PDF réussie: " + outputPath);
            return outputPath;
            
        } catch (Exception e) {
            throw new Exception("Erreur lors de la conversion Word to PDF: " + e.getMessage(), e);
        }
    }
    
    private String[] wrapText(String text, int maxLength) {
        if (text == null || text.length() <= maxLength) {
            return new String[]{text != null ? text : ""};
        }
        
        java.util.List<String> lines = new java.util.ArrayList<>();
        int start = 0;
        
        while (start < text.length()) {
            int end = Math.min(start + maxLength, text.length());
            
            // Essayer de couper à un espace
            if (end < text.length()) {
                int lastSpace = text.lastIndexOf(' ', end);
                if (lastSpace > start && lastSpace < end) {
                    end = lastSpace;
                }
            }
            
            lines.add(text.substring(start, end).trim());
            start = end;
            // Sauter les espaces au début de la prochaine ligne
            while (start < text.length() && text.charAt(start) == ' ') {
                start++;
            }
        }
        
        return lines.toArray(new String[0]);
    }
}