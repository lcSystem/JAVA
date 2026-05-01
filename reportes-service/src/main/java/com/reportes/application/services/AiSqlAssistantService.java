package com.reportes.application.services;

import com.reportes.domain.model.ReportType;
import com.reportes.domain.ports.out.LlmGenerationPort;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class AiSqlAssistantService {

    private final LlmGenerationPort llmGenerationPort;
    private final DatabaseSchemaService databaseSchemaService;

    /**
     * Explains a query and suggests performance indexing based on context.
     * Uses the LlmGenerationPort (OpenAiLlmAdapter) but adapting prompt.
     */
    public String explainQueryAndSuggestOptimizations(String rawQuery) {
        String prompt = "Actúa como un Database Administrator y Arquitecto SQL Experto.\n" +
                "Analiza la siguiente consulta y responde en 2 puntos separados por '|':\n" +
                "1. Explicación breve de qué datos extrae (en español, max 20 palabras).\n" +
                "2. Sugerencias de rendimiento o posibles Security Insights (ej. faltan índices o vulnerabilidad). Max 30 palabras.\n"
                +
                "Query:\n" + rawQuery;

        // Note: The LlmGenerationPort was initially designed for returning HTML. We can
        // reuse it
        // to return the text if the model supports it and doesn't heavily HTML-sanitize
        // plain text out.
        // It returns a sanitized string which is safe to use.
        try {
            return llmGenerationPort.generateHtml(ReportType.DASHBOARD_EXPORT, prompt);
        } catch (Exception e) {
            log.error("AI Assistant Explanation Failed", e);
            return "No se pudo invocar al asistente de IA|Inténtalo de nuevo más tarde.";
        }
    }

    /**
     * Text to SQL engine feeding actual database schema conditionally to prevent
     * Hallucination.
     */
    public String generateQueryFromNaturalLanguage(String nlPrompt, String moduleKeyword) {
        // Obtenemos un subconjunto del esquema de base de datos basado en la palabra
        // reservada del módulo
        String schemaContext = databaseSchemaService.getCompactSchemaSummary(moduleKeyword);

        String prompt = "Actúa como un SQL Copilot experto para sentencias MariaDB/MySQL.\n" +
                "Tienes el siguiente contexto de esquema real de tablas y columnas (Data Dictionary):\n" +
                schemaContext + "\n\n" +
                "Deseo que construyas una consulta SELECT válida para este requerimiento:\n" +
                "\"" + nlPrompt + "\"\n\n" +
                "Reglas críticas:\n" +
                "- Devuelve ÚNICA Y EXCLUSIVAMENTE el código SQL sin backticks (``), sin markdown, sin explicaciones.\n"
                +
                "- Utiliza SOLO las tablas y columnas proveídas en el esquema. NO inventes prefijos u otros módulos.\n"
                +
                "- Usa WHERE apropiados si se intuyen en el texto. La query debe iniciar con SELECT.";

        try {
            return llmGenerationPort.generateText(prompt).replace("```sql", "").replace("```", "").trim();
        } catch (Exception e) {
            log.error("AI Text-To-SQL Generation Failed", e);
            return "SELECT 'Error interno al comunicarse con el LLM' AS error;";
        }
    }
}
