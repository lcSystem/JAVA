package com.projectERP.service;

import com.projectERP.model.dto.MessageTaskDto;

import java.util.List;

public interface MessageTaskService {
    MessageTaskDto create(MessageTaskDto messageTaskDto);
    List<MessageTaskDto> getAll();
    List<MessageTaskDto> findAll(String taskID);
    MessageTaskDto getById(Long messageTaskID);
    void delete(Long messageTaskID);
}
