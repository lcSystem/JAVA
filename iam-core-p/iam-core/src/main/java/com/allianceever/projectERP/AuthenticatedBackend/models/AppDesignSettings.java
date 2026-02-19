package com.allianceever.projectERP.AuthenticatedBackend.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "app_design_settings")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class AppDesignSettings {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "user_id")
    private ApplicationUser user;

    @Column(name = "app_name")
    private String appName;

    @Column(name = "app_font")
    private String appFont;

    @Column(name = "logo_url")
    private String logoUrl;

    @Column(name = "favicon_url")
    private String faviconUrl;

    public String getPrimaryColor() {
        return primaryColor;
    }

    private String primaryColor;

    @Column(name = "secondary_color")
    private String secondaryColor;

    @Column(name = "accent_color")
    private String accentColor;

    @Column(name = "is_dark_mode")
    private Boolean isDarkMode;

    @Column(name = "sidebar_color")
    private String sidebarColor;

    @Column(name = "table_header_color")
    private String tableHeaderColor;
}
