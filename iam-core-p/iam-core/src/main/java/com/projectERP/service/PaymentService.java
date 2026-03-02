package com.projectERP.service;

import com.projectERP.model.dto.EstimatesInvoicesDto;
import com.projectERP.model.dto.ExpensesDto;
import com.projectERP.model.dto.LeaveTypeDto;
import com.projectERP.model.dto.PaymentDto;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface PaymentService {

    void delete(Long id);

    List<PaymentDto> getAll();

    PaymentDto getById(Long id);

    PaymentDto update(Long id, PaymentDto paymentDto);

    PaymentDto create(PaymentDto paymentDto);
}
