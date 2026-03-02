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
@Table(name = "employeeTask")
public class EmployeeTask {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "employee_task_id")
    private Long employeeTaskID;
    @Column(name = "task_id")
    private Long taskID;
    @Column(name = "employee_id")
    private Long employeeID;
    private String first_Name;
    private String last_Name;
    private String designation;
    private String imageName;
}
