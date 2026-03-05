package com.reportes.application.services.dynamic;

import com.reportes.domain.model.dynamic.DataSourceConfig;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class DataSourceRegistryService {

    private final List<DataSourceConfig> dataSources;

    public DataSourceRegistryService() {
        // En un entorno 100% dinámico, esto podría venir de una tabla en la BD
        // o un IAM. Por ahora, catálogo estático con roles permitidos.

        dataSources = List.of(
                DataSourceConfig.builder()
                        .dataSourceId("CREDIT_REQUESTS")
                        .displayName("Solicitudes de Crédito")
                        .allowedRoles(Set.of("ADMIN", "CREDIT_ANALYST"))
                        .fields(List.of(
                                new DataSourceConfig.FieldConfig("c_req_1", "ID Solicitud", "id", "string"),
                                new DataSourceConfig.FieldConfig("c_req_2", "Monto Solicitado", "requestedAmount",
                                        "number"),
                                new DataSourceConfig.FieldConfig("c_req_3", "Monto Aprobado", "approvedAmount",
                                        "number"),
                                new DataSourceConfig.FieldConfig("c_req_4", "Plazo (Meses)", "termMonths", "number"),
                                new DataSourceConfig.FieldConfig("c_req_5", "Estado", "status", "string"),
                                new DataSourceConfig.FieldConfig("c_req_6", "Fecha Solicitud", "requestDate", "date"),
                                new DataSourceConfig.FieldConfig("c_req_7", "Observaciones", "observations", "string")))
                        .build(),

                DataSourceConfig.builder()
                        .dataSourceId("CODEBTOR_PROFILES")
                        .displayName("Perfiles de Codeudores")
                        .allowedRoles(Set.of("ADMIN", "CREDIT_ANALYST"))
                        .fields(List.of(
                                new DataSourceConfig.FieldConfig("cod_1", "ID Codeudor", "id", "string"),
                                new DataSourceConfig.FieldConfig("cod_2", "Ocupación", "occupation", "string"),
                                new DataSourceConfig.FieldConfig("cod_3", "Ingreso Mensual", "monthlyIncome", "number"),
                                new DataSourceConfig.FieldConfig("cod_4", "Tipo Contrato", "contractType", "string")))
                        .build(),

                DataSourceConfig.builder()
                        .dataSourceId("PORTFOLIO_FOLDERS")
                        .displayName("Carpetas y Archivos (Portfolio)")
                        .allowedRoles(Set.of("ADMIN", "PORTFOLIO_MANAGER"))
                        .fields(List.of(
                                new DataSourceConfig.FieldConfig("port_1", "ID Carpeta", "id", "string"),
                                new DataSourceConfig.FieldConfig("port_2", "Nombre", "name", "string"),
                                new DataSourceConfig.FieldConfig("port_3", "Descripción", "description", "string"),
                                new DataSourceConfig.FieldConfig("port_4", "Propietario JWT", "ownerId", "string"),
                                new DataSourceConfig.FieldConfig("port_5", "Fecha Creación", "createdAt", "date")))
                        .build(),

                DataSourceConfig.builder()
                        .dataSourceId("USERS_SYSTEM")
                        .displayName("Usuarios del Sistema (IAM)")
                        .allowedRoles(Set.of("ADMIN", "IAM_ADMIN"))
                        .fields(List.of(
                                new DataSourceConfig.FieldConfig("iam_1", "ID Usuario", "id", "string"),
                                new DataSourceConfig.FieldConfig("iam_2", "Username", "username", "string"),
                                new DataSourceConfig.FieldConfig("iam_3", "Email", "email", "string"),
                                new DataSourceConfig.FieldConfig("iam_4", "Activo", "enabled", "boolean")))
                        .build(),

                DataSourceConfig.builder()
                        .dataSourceId("SYSTEM_PARAMS")
                        .displayName("Parámetros del Sistema")
                        .allowedRoles(Set.of("ADMIN"))
                        .fields(List.of(
                                new DataSourceConfig.FieldConfig("param_1", "ID Parámetro", "id", "number"),
                                new DataSourceConfig.FieldConfig("param_2", "Categoría", "categoryName", "string"),
                                new DataSourceConfig.FieldConfig("param_3", "Servicio", "serviceName", "string"),
                                new DataSourceConfig.FieldConfig("param_4", "Nombre", "name", "string"),
                                new DataSourceConfig.FieldConfig("param_5", "Clave", "key", "string"),
                                new DataSourceConfig.FieldConfig("param_6", "Valor", "value", "string"),
                                new DataSourceConfig.FieldConfig("param_7", "Tipo", "type", "string"),
                                new DataSourceConfig.FieldConfig("param_8", "Activo", "enabled", "boolean")))
                        .build());
    }

    public List<DataSourceConfig> getAllAllowedForUser(Set<String> userRoles) {
        return dataSources.stream()
                .filter(ds -> userRoles.stream().anyMatch(role -> ds.getAllowedRoles().contains(role)))
                .collect(Collectors.toList());
    }

    public boolean isAllowed(String dataSourceId, Set<String> userRoles) {
        return dataSources.stream()
                .filter(ds -> ds.getDataSourceId().equals(dataSourceId))
                .findFirst()
                .map(ds -> userRoles.stream().anyMatch(role -> ds.getAllowedRoles().contains(role)))
                .orElse(false);
    }

    public Optional<DataSourceConfig> getById(String dataSourceId) {
        return dataSources.stream()
                .filter(ds -> ds.getDataSourceId().equals(dataSourceId))
                .findFirst();
    }
}
