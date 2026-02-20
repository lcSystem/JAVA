package com.reportes.infrastructure.messaging;

import com.reportes.domain.model.ReportType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReportRequestedEvent {
    private String eventId;
    private String version;
    private Long timestamp;
    private String signature; // HMAC
    private Payload payload;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Payload {
        private ReportType reportType;
        private String requestedBy;
        private String data; // JSON string
    }
}
