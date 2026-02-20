package com.reportes.domain.ports.out;

public interface PdfGenerationPort {
    byte[] generatePdf(String html);
}
