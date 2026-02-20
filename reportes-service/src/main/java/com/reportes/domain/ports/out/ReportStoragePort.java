package com.reportes.domain.ports.out;

public interface ReportStoragePort {
    String store(byte[] content, String fileName);

    byte[] retrieve(String fileUrl);
}
