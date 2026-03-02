package com.projectERP.repository;

import com.projectERP.model.entity.Task;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TaskRepo extends JpaRepository<Task, Long> {
    List<Task> findByProjectProjectID(Long projectID);
}
