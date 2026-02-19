package com.allianceever.projectERP.repository;

import com.allianceever.projectERP.model.entity.EstimatesInvoices;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface EstimatesInvoicesRepo extends JpaRepository<EstimatesInvoices, Long> {
}
