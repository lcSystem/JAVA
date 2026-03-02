package com.projectERP.repository;

import com.projectERP.model.entity.MessageTask;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MessageTaskRepo extends JpaRepository<MessageTask, Long> {
    List<MessageTask> findByTaskID(Long taskID);
}
