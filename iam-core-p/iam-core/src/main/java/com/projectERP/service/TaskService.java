package com.projectERP.service;

import com.projectERP.model.dto.TaskDto;

import java.util.List;

public interface TaskService {
    TaskDto create(TaskDto taskDto);
    TaskDto update(Long taskID, TaskDto taskDto);
    List<TaskDto> getAll();
    List<TaskDto> findAll(String projectID);
    TaskDto getById(Long taskID);
    void delete(Long taskID);
}
