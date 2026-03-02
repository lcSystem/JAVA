package com.projectERP.service.implementation;

import com.projectERP.exception.ResourceNotFoundException;
import com.projectERP.model.dto.PaymentDto;
import com.projectERP.model.entity.Payment;
import com.projectERP.repository.PaymentRepo;
import com.projectERP.service.PaymentService;
import lombok.AllArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
@SuppressWarnings("null")
public class PaymentServiceImpl implements PaymentService {

    private PaymentRepo paymentRepo;
    private ModelMapper mapper;

    @Override
    public PaymentDto create(PaymentDto paymentDto) {
        // convert DTO to entity
        Payment payment = mapper.map(paymentDto, Payment.class);
        Payment newPayment = paymentRepo.save(payment);

        // convert entity to DTO
        return mapper.map(newPayment, PaymentDto.class);
    }

    @Override
    public List<PaymentDto> getAll() {
        List<Payment> payments = paymentRepo.findAll();
        return payments.stream()
                .map(payment -> mapper.map(payment, PaymentDto.class))
                .collect(Collectors.toList());
    }

    @Override
    public PaymentDto getById(Long id) {
        Payment payment = paymentRepo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Payment not found with id: " + id));
        return mapper.map(payment, PaymentDto.class);
    }

    @Override
    public PaymentDto update(Long id, PaymentDto paymentDto) {
        Payment existingPayment = paymentRepo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Payment not found with id: " + id));

        // Update fields
        if (paymentDto.getEstimatesInvoices() != null) {
            existingPayment.setEstimatesInvoices(mapper.map(paymentDto.getEstimatesInvoices(),
                    com.projectERP.model.entity.EstimatesInvoices.class));
        }
        existingPayment.setPaidDate(paymentDto.getPaidDate());
        existingPayment.setPaidAmount(paymentDto.getPaidAmount());

        Payment updatedPayment = paymentRepo.save(existingPayment);
        return mapper.map(updatedPayment, PaymentDto.class);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (!paymentRepo.existsById(id)) {
            throw new ResourceNotFoundException("Payment not found with id: " + id);
        }
        paymentRepo.deleteById(id);
    }
}
