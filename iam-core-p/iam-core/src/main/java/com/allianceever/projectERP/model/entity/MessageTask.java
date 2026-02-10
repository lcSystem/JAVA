package com.allianceever.projectERP.model.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Table(name = "messageTask")
public class MessageTask {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "message_task_id")
    private Long messageTaskID;
    @Column(name = "task_id")
    private Long taskID;
    @Column(name = "employee_id")
    private Long employeeID;
    private String first_Name;
    private String last_Name;
    private String imageName;
    private String date;
    @Size(max = 500)
    private String message;
}
