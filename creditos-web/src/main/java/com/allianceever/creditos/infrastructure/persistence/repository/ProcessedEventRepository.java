package com.allianceever.creditos.infrastructure.persistence.repository;

import com.allianceever.creditos.infrastructure.persistence.entity.ProcessedEvent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProcessedEventRepository extends JpaRepository<ProcessedEvent, String> {
}
