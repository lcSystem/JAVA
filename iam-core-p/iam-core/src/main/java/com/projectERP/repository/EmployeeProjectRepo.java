package com.projectERP.repository;

import com.projectERP.model.entity.EmployeeProject;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface EmployeeProjectRepo extends JpaRepository<EmployeeProject, Long> {
    List<EmployeeProject> findByProject_ProjectID(Long projectID);

    List<EmployeeProject> findByEmployee_EmployeeID(Long employeeID);

    EmployeeProject findByEmployee_EmployeeIDAndProject_ProjectID(Long employeeID, Long projectID);
}
