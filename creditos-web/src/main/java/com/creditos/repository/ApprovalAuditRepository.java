package com.creditos.repository;

import com.creditos.model.ApprovalAudit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ApprovalAuditRepository extends JpaRepository<ApprovalAudit, Long> {
}
