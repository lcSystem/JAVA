package com.allianceever.projectERP.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import jakarta.validation.constraints.Size;

import java.time.LocalDate;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Table(name = "project")
public class Project {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "project_id")
    private Long projectID;
    private String project_Name;
    private String company_Name;
    private LocalDate start_Date;
    private LocalDate end_Date;
    private String rate;
    private String rate_Type;
    private String priority;
    private String total_Hours;
    private String status;
    private String created_By;
    @Size(max = 1000)
    private String description;

    private String progress;
}
