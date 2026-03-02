package com.creditos.repository;

import com.creditos.model.AmortizationInstallment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AmortizationInstallmentRepository extends JpaRepository<AmortizationInstallment, Long> {
    List<AmortizationInstallment> findByRequestIdOrderByInstallmentNumber(Long requestId);
}
