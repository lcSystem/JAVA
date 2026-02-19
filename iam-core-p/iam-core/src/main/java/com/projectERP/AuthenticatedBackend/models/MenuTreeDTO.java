package com.allianceever.projectERP.AuthenticatedBackend.models;

import java.util.ArrayList;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO for sending the menu tree to the frontend.
 * Includes CRUD permissions so the frontend can show/hide buttons.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MenuTreeDTO {

    private Long id;
    private String nombre;
    private String ruta;
    private String icono;
    private String codigo;
    private Integer orden;
    private PermissionsDTO permissions;
    private List<MenuTreeDTO> children = new ArrayList<>();

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PermissionsDTO {
        private boolean read;
        private boolean create;
        private boolean update;
        private boolean delete;
    }
}
