package com.conversion.services;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.poi.xwpf.usermodel.*;
import java.io.*;

public class PdfToWordConverter {
    
    public String convert(String pdfPath) throws Exception {
        String outputPath = pdfPath.replace(".pdf", ".docx");
        
        File pdfFile = new File(pdfPath);
        if (!pdfFile.exists()) {
            throw new FileNotFoundException("Fichier PDF non trouvé: " + pdfPath);
        }
        
        try (PDDocument document = PDDocument.load(pdfFile);
             XWPFDocument wordDocument = new XWPFDocument()) {
            
            PDFTextStripper stripper = new PDFTextStripper();
            String text = stripper.getText(document);
            
            // Nettoyer le texte
            text = cleanText(text);
            
            // Créer un paragraphe dans le document Word
            if (!text.isEmpty()) {
                XWPFParagraph paragraph = wordDocument.createParagraph();
                XWPFRun run = paragraph.createRun();
                run.setText(text);
                run.setFontFamily("Arial");
                run.setFontSize(11);
            }
            
            // Sauvegarder le document Word
            try (FileOutputStream out = new FileOutputStream(outputPath)) {
                wordDocument.write(out);
            }
            
            System.out.println("Conversion PDF to Word réussie: " + outputPath);
            return outputPath;
            
        } catch (Exception e) {
            throw new Exception("Erreur lors de la conversion PDF to Word: " + e.getMessage(), e);
        }
    }
    
    private String cleanText(String text) {
        // Supprimer les caractères de contrôle et les espaces multiples
        return text.replaceAll("[\\x00-\\x08\\x0B\\x0C\\x0E-\\x1F]", "")
                   .replaceAll("\\s+", " ")
                   .trim();
    }
}