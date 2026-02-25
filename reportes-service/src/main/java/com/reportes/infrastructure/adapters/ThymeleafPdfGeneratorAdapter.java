package com.reportes.infrastructure.adapters;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;
import com.reportes.domain.model.dynamic.ReportTemplate;
import com.reportes.domain.ports.out.DynamicPdfGeneratorPort;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

@Component
@RequiredArgsConstructor
@Slf4j
public class ThymeleafPdfGeneratorAdapter implements DynamicPdfGeneratorPort {

    private final TemplateEngine templateEngine;
    private final ObjectMapper objectMapper;

    @Override
    public byte[] generatePdf(ReportTemplate template, String rawDataJson, Map<String, Object> parameters) {
        try {
            // 1. Parse raw json data into a list of maps for easy iteration in thymeleaf
            List<Map<String, Object>> data = objectMapper.readValue(rawDataJson, new TypeReference<>() {
            });

            // 2. Prepare Thymeleaf Context
            Context context = new Context();
            context.setVariable("template", template);
            context.setVariable("data", data);
            context.setVariable("config", template.getConfig());
            context.setVariable("columns", template.getColumns());
            context.setVariable("parameters", parameters);

            // 3. Process HTML
            // We need a generic html template located in
            // src/main/resources/templates/dynamic-report.html
            String htmlContent = templateEngine.process("dynamic-report", context);

            // 4. Generate PDF from HTML using OpenHTMLToPDF
            try (ByteArrayOutputStream os = new ByteArrayOutputStream()) {
                PdfRendererBuilder builder = new PdfRendererBuilder();
                builder.useFastMode();
                builder.withHtmlContent(htmlContent, null);
                builder.toStream(os);
                builder.run();
                return os.toByteArray();
            }

        } catch (JsonProcessingException e) {
            log.error("Failed to parse raw data for PDF report", e);
            throw new RuntimeException("Invalid JSON data format", e);
        } catch (Exception e) {
            log.error("Error generating PDF", e);
            throw new RuntimeException("PDF generation failed", e);
        }
    }
}
