package com.projectERP.repository;

import com.projectERP.model.entity.Designation;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DesignationRepo extends JpaRepository<Designation, Long> {
}
