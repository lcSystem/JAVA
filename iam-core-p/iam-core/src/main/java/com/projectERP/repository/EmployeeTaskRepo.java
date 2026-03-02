package com.projectERP.repository;

import com.projectERP.model.entity.EmployeeTask;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface EmployeeTaskRepo extends JpaRepository<EmployeeTask, Long> {
    List<EmployeeTask> findByTaskID(Long taskID);

    EmployeeTask findByEmployeeIDAndTaskID(Long employeeID, Long taskID);
}
