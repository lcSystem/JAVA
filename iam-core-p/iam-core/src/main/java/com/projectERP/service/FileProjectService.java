package com.projectERP.service;

import com.projectERP.model.dto.FileProjectDto;

import java.util.List;

public interface FileProjectService {
    FileProjectDto create(FileProjectDto fileProjectDto);
    List<FileProjectDto> getAll();
    List<FileProjectDto> findAll(String projectID);
    FileProjectDto getById(Long fileProjectID);
    void delete(Long fileProjectID);
}
