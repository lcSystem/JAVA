package com.projectERP.model.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDate;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Table(name = "task")
public class Task {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "task_id")
    private Long taskID;

    @ManyToOne
    @JoinColumn(name = "project_id")
    private Project project;

    private String task_Name;
    private String task_Priority;
    private LocalDate due_Date;
    @Size(max = 1000)
    private String description;
    private String status;
}
