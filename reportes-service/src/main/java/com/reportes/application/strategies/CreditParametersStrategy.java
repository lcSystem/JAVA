package com.reportes.application.strategies;

import com.reportes.domain.model.ReportRequest;
import com.reportes.domain.model.ReportType;
import org.springframework.stereotype.Component;

@Component
public class CreditParametersStrategy implements ReportStrategy {

    @Override
    public boolean supports(ReportType type) {
        // We will map this to a specific type if needed, but for now using a generic
        // one
        return type == ReportType.PORTFOLIO_ANALYSIS;
    }

    @Override
    public String buildPrompt(ReportRequest request) {
        return "Generate a comprehensive technical report of the current credit system parameters. " +
                "Data provided: " + request.getParameters() + " " +
                "The report must include: Interest rates, Terms, Commissions, Guaranteed types, " +
                "and Policy validation rules. Use professional financial formatting in HTML.";
    }
}
