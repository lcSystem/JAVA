package com.projectERP.repository;

import com.projectERP.model.entity.ImageProject;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ImageProjectRepo extends JpaRepository<ImageProject, Long> {
    List<ImageProject> findByProjectID(Long projectID);
}
