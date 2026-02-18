package com.allianceever.creditos.repository;

import com.allianceever.creditos.model.ApprovalAudit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ApprovalAuditRepository extends JpaRepository<ApprovalAudit, Long> {
}
