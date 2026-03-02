package com.creditos.service;

import com.creditos.dto.PaymentDTO;
import com.creditos.model.AmortizationInstallment;
import com.creditos.model.CreditRequest;
import com.creditos.model.Payment;
import com.creditos.repository.AmortizationInstallmentRepository;
import com.creditos.repository.CreditRequestRepository;
import com.creditos.repository.PaymentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final AmortizationInstallmentRepository installmentRepository;
    private final CreditRequestRepository requestRepository;

    @Transactional
    public PaymentDTO registerPayment(PaymentDTO dto) {
        AmortizationInstallment installment = installmentRepository.findById(dto.getInstallmentId())
                .orElseThrow(() -> new RuntimeException("Installment not found"));

        if ("PAID".equals(installment.getStatus())) {
            throw new RuntimeException("Installment is already paid");
        }

        // Registrar el pago
        Payment payment = Payment.builder()
                .installment(installment)
                .amountPaid(dto.getAmountPaid())
                .paymentType(dto.getPaymentType())
                .receiptNumber(dto.getReceiptNumber())
                .build();

        Payment savedPayment = paymentRepository.save(payment);

        // Actualizar estado de la cuota (Simplificado: si el monto coincide o supera,
        // se marca como PAID)
        if (dto.getAmountPaid().compareTo(installment.getTotalInstallment()) >= 0) {
            installment.setStatus("PAID");
            installmentRepository.save(installment);
        }

        // Verificar si el crédito completo está pagado
        checkIfCreditIsFullyPaid(installment.getRequest().getId());

        return mapToDTO(savedPayment);
    }

    private void checkIfCreditIsFullyPaid(Long requestId) {
        List<AmortizationInstallment> schedule = installmentRepository
                .findByRequestIdOrderByInstallmentNumber(requestId);
        boolean allPaid = schedule.stream().allMatch(i -> "PAID".equals(i.getStatus()));

        if (allPaid) {
            CreditRequest request = requestRepository.findById(requestId).get();
            request.setStatus("PAID");
            requestRepository.save(request);
        }
    }

    private PaymentDTO mapToDTO(Payment entity) {
        return PaymentDTO.builder()
                .id(entity.getId())
                .installmentId(entity.getInstallment().getId())
                .paymentDate(entity.getPaymentDate())
                .amountPaid(entity.getAmountPaid())
                .paymentType(entity.getPaymentType())
                .receiptNumber(entity.getReceiptNumber())
                .build();
    }
}
