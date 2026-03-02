package com.projectERP.repository;

import com.projectERP.model.entity.Holiday;
import com.projectERP.model.entity.Payment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PaymentRepo extends JpaRepository<Payment, Long> {

    List<Payment> findByEstimatesInvoicesId(Long invoiceId);

}
