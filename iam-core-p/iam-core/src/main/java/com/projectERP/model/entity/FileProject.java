package com.projectERP.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Table(name = "fileProject")
public class FileProject {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "file_project_id")
    private Long fileProjectID;
    @Column(name = "project_id")
    private Long projectID;
    private String fileName;
    private String originalName;
    private String dateCreation;
}
