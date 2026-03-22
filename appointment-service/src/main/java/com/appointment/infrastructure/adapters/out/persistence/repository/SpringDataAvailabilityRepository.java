package com.appointment.infrastructure.adapters.out.persistence.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.appointment.infrastructure.adapters.out.persistence.entity.AvailabilityEntity;

@Repository
public interface SpringDataAvailabilityRepository extends JpaRepository<AvailabilityEntity, UUID> {
    List<AvailabilityEntity> findByEmployeeId(UUID employeeId);
}
