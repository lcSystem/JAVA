package com.allianceever.projectERP.AuthenticatedBackend.services;

import com.allianceever.projectERP.AuthenticatedBackend.models.AppDesignSettings;
import com.allianceever.projectERP.AuthenticatedBackend.models.AppDesignSettingsDTO;
import com.allianceever.projectERP.AuthenticatedBackend.models.ApplicationUser;
import com.allianceever.projectERP.AuthenticatedBackend.repository.AppDesignSettingsRepository;
import com.allianceever.projectERP.AuthenticatedBackend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class AppDesignSettingsService {

    @Autowired
    private AppDesignSettingsRepository designRepository;

    @Autowired
    private UserRepository userRepository;

    public AppDesignSettingsDTO getDesignSettings(String username) {
        ApplicationUser user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        return designRepository.findByUser(user)
                .map(AppDesignSettingsDTO::new)
                .orElse(getDefaultSettings());
    }

    public AppDesignSettingsDTO updateDesignSettings(String username, AppDesignSettingsDTO dto) {
        ApplicationUser user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        AppDesignSettings settings = designRepository.findByUser(user)
                .orElse(new AppDesignSettings());

        settings.setUser(user);

        if (dto.getAppName() != null)
            settings.setAppName(dto.getAppName());
        if (dto.getAppFont() != null)
            settings.setAppFont(dto.getAppFont());
        if (dto.getLogoUrl() != null)
            settings.setLogoUrl(dto.getLogoUrl());
        if (dto.getFaviconUrl() != null)
            settings.setFaviconUrl(dto.getFaviconUrl());
        if (dto.getPrimaryColor() != null)
            settings.setPrimaryColor(dto.getPrimaryColor());
        if (dto.getSecondaryColor() != null)
            settings.setSecondaryColor(dto.getSecondaryColor());
        if (dto.getAccentColor() != null)
            settings.setAccentColor(dto.getAccentColor());
        if (dto.getIsDarkMode() != null)
            settings.setIsDarkMode(dto.getIsDarkMode());
        if (dto.getSidebarColor() != null)
            settings.setSidebarColor(dto.getSidebarColor());
        if (dto.getTableHeaderColor() != null)
            settings.setTableHeaderColor(dto.getTableHeaderColor());

        AppDesignSettings saved = designRepository.save(settings);
        return new AppDesignSettingsDTO(saved);
    }

    private AppDesignSettingsDTO getDefaultSettings() {
        AppDesignSettingsDTO defaults = new AppDesignSettingsDTO();
        defaults.setAppName("IAM ERP");
        defaults.setAppFont("Inter");
        defaults.setLogoUrl("/images/logo/logo.svg");
        defaults.setFaviconUrl("/images/logo/logo.svg");
        defaults.setPrimaryColor("#4F46E5");
        defaults.setSecondaryColor("#10B981");
        defaults.setAccentColor("#F59E0B");
        defaults.setIsDarkMode(false);
        defaults.setSidebarColor("#FFFFFF");
        defaults.setTableHeaderColor("#F9FAFB");
        return defaults;
    }

    public String uploadLogo(String username, org.springframework.web.multipart.MultipartFile file) {
        ApplicationUser user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        AppDesignSettings settings = designRepository.findByUser(user)
                .orElse(new AppDesignSettings());
        settings.setUser(user);

        String uploadDir = "uploads/images/design/";
        java.nio.file.Path uploadPath = java.nio.file.Paths.get(uploadDir);

        try {
            if (!java.nio.file.Files.exists(uploadPath)) {
                java.nio.file.Files.createDirectories(uploadPath);
            }

            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename != null && originalFilename.contains(".")
                    ? originalFilename.substring(originalFilename.lastIndexOf("."))
                    : ".png";

            String filename = java.util.UUID.randomUUID().toString() + extension;
            java.nio.file.Path filePath = uploadPath.resolve(filename);

            java.nio.file.Files.copy(file.getInputStream(), filePath,
                    java.nio.file.StandardCopyOption.REPLACE_EXISTING);

            String logoUrl = "/uploads/images/design/" + filename;
            settings.setLogoUrl(logoUrl);
            designRepository.save(settings);

            return logoUrl;
        } catch (java.io.IOException e) {
            throw new RuntimeException("Could not store logo file", e);
        }

    }

    public String uploadFavicon(String username, org.springframework.web.multipart.MultipartFile file) {
        ApplicationUser user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        AppDesignSettings settings = designRepository.findByUser(user)
                .orElse(new AppDesignSettings());
        settings.setUser(user);

        String uploadDir = "uploads/images/design/";
        java.nio.file.Path uploadPath = java.nio.file.Paths.get(uploadDir);

        try {
            if (!java.nio.file.Files.exists(uploadPath)) {
                java.nio.file.Files.createDirectories(uploadPath);
            }

            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename != null && originalFilename.contains(".")
                    ? originalFilename.substring(originalFilename.lastIndexOf("."))
                    : ".png";

            String filename = "favicon_" + java.util.UUID.randomUUID().toString() + extension;
            java.nio.file.Path filePath = uploadPath.resolve(filename);

            java.nio.file.Files.copy(file.getInputStream(), filePath,
                    java.nio.file.StandardCopyOption.REPLACE_EXISTING);

            String faviconUrl = "/uploads/images/design/" + filename;
            settings.setFaviconUrl(faviconUrl);
            designRepository.save(settings);

            return faviconUrl;
        } catch (java.io.IOException e) {
            throw new RuntimeException("Could not store favicon file", e);
        }
    }
}
