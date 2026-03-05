package com.reportes.infrastructure.adapters;

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

    @Override
    public byte[] generatePdf(ReportTemplate template, List<Map<String, Object>> data, Map<String, Object> parameters) {
        try {

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

        } catch (Exception e) {
            log.error("Error generating PDF", e);
            throw new RuntimeException("PDF generation failed", e);
        }
    }
}
