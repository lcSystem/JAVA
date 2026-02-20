package com.reportes.infrastructure.adapters.out.storage;

import com.reportes.domain.ports.out.ReportStoragePort;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;

@Component
@Slf4j
public class FileSystemStorageAdapter implements ReportStoragePort {

    @Value("${report.storage.path:/tmp/reports}")
    private String storageBasePath;

    @Override
    public String store(byte[] content, String fileName) {
        try {
            String dateFolder = LocalDate.now().toString();
            Path targetDir = Paths.get(storageBasePath, dateFolder);
            if (!Files.exists(targetDir)) {
                Files.createDirectories(targetDir);
            }
            Path filePath = targetDir.resolve(fileName);
            Files.write(filePath, content);
            log.info("Report stored at: {}", filePath);
            return filePath.toString();
        } catch (IOException e) {
            log.error("Failed to store file: {}", e.getMessage());
            throw new RuntimeException("Storage failure", e);
        }
    }

    @Override
    public byte[] retrieve(String fileUrl) {
        try {
            return Files.readAllBytes(Paths.get(fileUrl));
        } catch (IOException e) {
            log.error("Failed to retrieve file: {}", e.getMessage());
            throw new RuntimeException("Retrieval failure", e);
        }
    }
}
