package com.projectERP.AuthenticatedBackend.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AppDesignSettingsDTO {
    private String appName;
    private String appFont;
    private String logoUrl;
    private String faviconUrl;
    private String primaryColor;
    private String secondaryColor;
    private String accentColor;
    private Boolean isDarkMode;
    private String sidebarColor;
    private String tableHeaderColor;

    public AppDesignSettingsDTO(AppDesignSettings settings) {
        if (settings != null) {
            this.appName = settings.getAppName();
            this.appFont = settings.getAppFont();
            this.logoUrl = settings.getLogoUrl();
            this.faviconUrl = settings.getFaviconUrl();
            this.primaryColor = settings.getPrimaryColor();
            this.secondaryColor = settings.getSecondaryColor();
            this.accentColor = settings.getAccentColor();
            this.isDarkMode = settings.getIsDarkMode();
            this.sidebarColor = settings.getSidebarColor();
            this.tableHeaderColor = settings.getTableHeaderColor();
        }
    }
}
