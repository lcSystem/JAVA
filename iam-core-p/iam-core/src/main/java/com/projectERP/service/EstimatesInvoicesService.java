package com.projectERP.service;

import com.projectERP.model.dto.EstimatesInvoicesDto;
import com.projectERP.model.dto.HolidayDto;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface EstimatesInvoicesService {

    EstimatesInvoicesDto create(EstimatesInvoicesDto estimatesInvoicesDto);

    EstimatesInvoicesDto getById(Long id);

    EstimatesInvoicesDto update(Long id, EstimatesInvoicesDto estimatesInvoicesDto);

    List<EstimatesInvoicesDto> getAllEstimates();

    List<EstimatesInvoicesDto> getAllInvoices();

    void delete(Long id);
}
