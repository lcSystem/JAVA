package com.reportes.application.strategies;

import com.reportes.domain.model.ReportRequest;
import com.reportes.domain.model.ReportType;
import org.springframework.stereotype.Component;

@Component
public class CreditSummaryStrategy implements ReportStrategy {

    @Override
    public boolean supports(ReportType type) {
        return type == ReportType.CREDIT_SUMMARY;
    }

    @Override
    public String buildPrompt(ReportRequest request) {
        return "Generate a business credit summary report in HTML format. " +
                "Data: " + request.getParameters() + " " +
                "Include sections: Header, Executive summary, Detailed tables, Risk analysis, Financial metrics, and Conclusion. "
                +
                "Return clean HTML only.";
    }
}
