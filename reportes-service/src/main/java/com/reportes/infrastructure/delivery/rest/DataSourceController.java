package com.reportes.infrastructure.delivery.rest;

import com.reportes.domain.model.dynamic.DataSourceConfig;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/dynamic-reports/data-sources")
public class DataSourceController {

        @GetMapping
        public ResponseEntity<List<DataSourceConfig>> getDataSources() {
                // En un entorno 100% dinámico, esto podría venir de una base de datos o de un
                // Service Registry (Consul/Eureka)
                // Por ahora, configuramos el catálogo del ERP de manera estática aquí para que
                // el frontend pueda construir su UI

                DataSourceConfig creditos = DataSourceConfig.builder()
                                .microserviceId("creditos-web")
                                .microserviceName("Módulo de Créditos")
                                .entities(List.of(
                                                DataSourceConfig.EntityConfig.builder()
                                                                .entityId("solicitudes")
                                                                .entityName("Solicitudes de Crédito")
                                                                .endpointUrl("/api/v1/credit-requests") // URL relativa
                                                                                                        // para que el
                                                                                                        // API
                                                                                                        // Gateway/Frontend
                                                                                                        // la resuelva
                                                                .fields(List.of(
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "c_req_1",
                                                                                                "ID Solicitud", "id",
                                                                                                "string"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "c_req_2",
                                                                                                "Monto Solicitado",
                                                                                                "requestedAmount",
                                                                                                "number"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "c_req_3",
                                                                                                "Monto Aprobado",
                                                                                                "approvedAmount",
                                                                                                "number"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "c_req_4",
                                                                                                "Plazo (Meses)",
                                                                                                "termMonths",
                                                                                                "number"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "c_req_5", "Estado",
                                                                                                "status", "string"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "c_req_6",
                                                                                                "Fecha Solicitud",
                                                                                                "requestDate",
                                                                                                "date"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "c_req_7",
                                                                                                "Observaciones",
                                                                                                "observations",
                                                                                                "string")))
                                                                .build(),
                                                DataSourceConfig.EntityConfig.builder()
                                                                .entityId("codeudores")
                                                                .entityName("Perfiles de Codeudores")
                                                                .endpointUrl("/api/v1/codebtor-profiles")
                                                                .fields(List.of(
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "cod_1", "ID Codeudor",
                                                                                                "id", "string"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "cod_2", "Ocupación",
                                                                                                "occupation", "string"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "cod_3",
                                                                                                "Ingreso Mensual",
                                                                                                "monthlyIncome",
                                                                                                "number"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "cod_4",
                                                                                                "Tipo Contrato",
                                                                                                "contractType",
                                                                                                "string")))
                                                                .build()))
                                .build();

                DataSourceConfig portfolio = DataSourceConfig.builder()
                                .microserviceId("erp-portfolio")
                                .microserviceName("Gestor Documental (Portfolio)")
                                .entities(List.of(
                                                DataSourceConfig.EntityConfig.builder()
                                                                .entityId("carpetas")
                                                                .entityName("Carpetas y Archivos")
                                                                .endpointUrl("/api/v1/folders")
                                                                .fields(List.of(
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "port_1", "ID Carpeta",
                                                                                                "id", "string"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "port_2", "Nombre",
                                                                                                "name", "string"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "port_3", "Descripción",
                                                                                                "description",
                                                                                                "string"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "port_4",
                                                                                                "Propietario JWT",
                                                                                                "ownerId",
                                                                                                "string"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "port_5",
                                                                                                "Fecha Creación",
                                                                                                "createdAt",
                                                                                                "date")))
                                                                .build()))
                                .build();

                DataSourceConfig iam = DataSourceConfig.builder()
                                .microserviceId("iam-core")
                                .microserviceName("Gestión de Usuarios (IAM)")
                                .entities(List.of(
                                                DataSourceConfig.EntityConfig.builder()
                                                                .entityId("usuarios")
                                                                .entityName("Usuarios del Sistema")
                                                                .endpointUrl("/api/v1/users")
                                                                .fields(List.of(
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "iam_1", "ID Usuario",
                                                                                                "id", "string"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "iam_2", "Username",
                                                                                                "username", "string"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "iam_3", "Email",
                                                                                                "email", "string"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "iam_4", "Activo",
                                                                                                "enabled", "boolean")))
                                                                .build()))
                                .build();

                DataSourceConfig parametrizaciones = DataSourceConfig.builder()
                                .microserviceId("parametrizaciones")
                                .microserviceName("Parámetros del Sistema")
                                .entities(List.of(
                                                DataSourceConfig.EntityConfig.builder()
                                                                .entityId("parametros")
                                                                .entityName("Parámetros Generales")
                                                                .endpointUrl("/api/parameters/{service}") // Consider
                                                                                                          // that the
                                                                                                          // service is
                                                                                                          // part of URL
                                                                                                          // or query,
                                                                                                          // frontend
                                                                                                          // can adapt
                                                                                                          // if needed,
                                                                                                          // or point to
                                                                                                          // a valid
                                                                                                          // endpoint to
                                                                                                          // get all
                                                                .fields(List.of(
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "param_1",
                                                                                                "ID Parámetro", "id",
                                                                                                "number"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "param_2", "Categoría",
                                                                                                "categoryName",
                                                                                                "string"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "param_3", "Servicio",
                                                                                                "serviceName",
                                                                                                "string"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "param_4", "Nombre",
                                                                                                "name", "string"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "param_5", "Clave",
                                                                                                "key", "string"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "param_6", "Valor",
                                                                                                "value", "string"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "param_7", "Tipo",
                                                                                                "type", "string"),
                                                                                new DataSourceConfig.FieldConfig(
                                                                                                "param_8", "Activo",
                                                                                                "enabled", "boolean")))
                                                                .build()))
                                .build();

                return ResponseEntity.ok(List.of(creditos, portfolio, iam, parametrizaciones));
        }
}
