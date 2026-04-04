package com.conversion.services;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.*;
import java.io.*;

public class PdfToExcelConverter {
    
    public String convert(String pdfPath) throws Exception {
        String outputPath = pdfPath.replace(".pdf", ".xlsx");
        
        File pdfFile = new File(pdfPath);
        if (!pdfFile.exists()) {
            throw new FileNotFoundException("Fichier PDF non trouvé: " + pdfPath);
        }
        
        try (PDDocument document = PDDocument.load(pdfFile);
             Workbook workbook = new XSSFWorkbook()) {
            
            PDFTextStripper stripper = new PDFTextStripper();
            String text = stripper.getText(document);
            
            // Créer une feuille Excel
            Sheet sheet = workbook.createSheet("Contenu PDF");
            
            // Style pour l'en-tête
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            
            // Créer l'en-tête
            Row headerRow = sheet.createRow(0);
            Cell headerCell = headerRow.createCell(0);
            headerCell.setCellValue("Contenu du PDF");
            headerCell.setCellStyle(headerStyle);
            
            // Diviser le texte en lignes
            String[] lines = text.split("\n");
            
            for (int i = 0; i < lines.length; i++) {
                Row row = sheet.createRow(i + 1); // +1 pour sauter l'en-tête
                Cell cell = row.createCell(0);
                cell.setCellValue(lines[i]);
            }
            
            // Ajuster la largeur de la colonne
            sheet.autoSizeColumn(0);
            
            // Sauvegarder le fichier Excel
            try (FileOutputStream out = new FileOutputStream(outputPath)) {
                workbook.write(out);
            }
            
            System.out.println("Conversion PDF to Excel réussie: " + outputPath);
            return outputPath;
            
        } catch (Exception e) {
            throw new Exception("Erreur lors de la conversion PDF to Excel: " + e.getMessage(), e);
        }
    }
}