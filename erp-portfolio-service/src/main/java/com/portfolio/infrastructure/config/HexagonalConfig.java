package com.portfolio.infrastructure.config;

import com.portfolio.application.services.*;
import com.portfolio.domain.ports.in.*;
import com.portfolio.domain.ports.out.*;
import com.portfolio.infrastructure.client.IamServiceClient;
import com.portfolio.infrastructure.client.ParameterServiceClient;
import com.portfolio.infrastructure.storage.FileSystemStorageAdapter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

/**
 * Hexagonal architecture configuration.
 * Wires domain ports to infrastructure adapters.
 */
@Configuration
public class HexagonalConfig {

    @Value("${portfolio.storage.base-path}")
    private String storagePath;

    @Value("${portfolio.parameter-service.base-url}")
    private String parameterServiceUrl;

    @Value("${portfolio.iam-service.base-url}")
    private String iamServiceUrl;

    @Value("${portfolio.defaults.max-file-size-mb:10}")
    private int defaultMaxFileSizeMb;

    @Value("${portfolio.defaults.allowed-extensions:jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx,ppt,pptx}")
    private String defaultAllowedExtensions;

    @Value("${portfolio.defaults.require-reauth:false}")
    private boolean defaultRequireReAuth;

    @Bean
    public RestTemplate restTemplate() {
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getInterceptors().add(new RestTemplateHeaderInterceptor());
        return restTemplate;
    }

    @Bean
    public StoragePort storagePort() {
        return new FileSystemStorageAdapter(storagePath);
    }

    @Bean
    public ParameterClientPort parameterClientPort(RestTemplate restTemplate) {
        return new ParameterServiceClient(restTemplate, parameterServiceUrl);
    }

    @Bean
    public IamClientPort iamClientPort(RestTemplate restTemplate) {
        return new IamServiceClient(restTemplate, iamServiceUrl);
    }

    @Bean
    public SettingsUseCase settingsUseCase(SettingsRepository settingsRepo, ParameterClientPort parameterClient) {
        return new SettingsUseCaseImpl(
                settingsRepo,
                parameterClient,
                defaultMaxFileSizeMb,
                defaultAllowedExtensions,
                defaultRequireReAuth);
    }

    @Bean
    public FolderUseCase folderUseCase(FolderRepositoryPort folderRepo,
            FileRepositoryPort fileRepo,
            StoragePort storage) {
        return new FolderUseCaseImpl(folderRepo, fileRepo, storage);
    }

    @Bean
    public FileUseCase fileUseCase(FileRepositoryPort fileRepo,
            FolderRepositoryPort folderRepo,
            StoragePort storage,
            SettingsUseCase settings) {
        return new FileUseCaseImpl(fileRepo, folderRepo, storage, settings);
    }

    @Bean
    public ReAuthUseCase reAuthUseCase(IamClientPort iamClient) {
        return new ReAuthUseCaseImpl(iamClient, "portfolio-reauth-secret-key-change-in-production");
    }
}
