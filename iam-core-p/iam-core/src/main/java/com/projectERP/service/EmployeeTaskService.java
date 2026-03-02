package com.projectERP.service;

import com.projectERP.model.dto.EmployeeTaskDto;

import java.util.List;

public interface EmployeeTaskService {
    EmployeeTaskDto create(EmployeeTaskDto employeeTaskDto);
    List<EmployeeTaskDto> getAll();
    List<EmployeeTaskDto> findAll(String taskID);
    EmployeeTaskDto getById(Long employeeTaskID);
    EmployeeTaskDto getByEmployeeIDAndTaskID(String employeeID, String taskID);
    void delete(Long employeeTaskID);
}
