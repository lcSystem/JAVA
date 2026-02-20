package com.reportes.infrastructure.adapters.out.pdf;

import com.reportes.domain.ports.out.PdfGenerationPort;
import com.reportes.domain.exception.PayloadTooLargeException;
import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.io.ByteArrayOutputStream;

@Component
@Slf4j
public class OpenHtmlToPdfAdapter implements PdfGenerationPort {

    private static final int MAX_HTML_SIZE = 10 * 1024 * 1024; // 10MB

    @Override
    public byte[] generatePdf(String html) {
        if (html.length() > MAX_HTML_SIZE) {
            throw new PayloadTooLargeException("Generated HTML exceeds maximum allowed size");
        }

        log.info("Generating PDF from HTML (length: {})", html.length());

        try (ByteArrayOutputStream os = new ByteArrayOutputStream()) {
            PdfRendererBuilder builder = new PdfRendererBuilder();
            builder.useFastMode();
            builder.withHtmlContent(html, null);
            builder.toStream(os);
            builder.run();
            return os.toByteArray();
        } catch (Exception e) {
            log.error("Error during PDF generation: {}", e.getMessage());
            throw new RuntimeException("PDF generation failed", e);
        }
    }
}
