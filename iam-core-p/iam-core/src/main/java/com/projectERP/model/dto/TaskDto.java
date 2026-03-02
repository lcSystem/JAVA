package com.projectERP.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TaskDto {
    private Long taskID;
    private ProjectDto project;
    private String task_Name;
    private String task_Priority;
    private LocalDate due_Date;
    private String description;
    private String status;
}
