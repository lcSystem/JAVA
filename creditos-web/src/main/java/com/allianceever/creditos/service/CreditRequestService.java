package com.allianceever.creditos.service;

import com.allianceever.creditos.dto.CreditRequestDTO;
import com.allianceever.creditos.model.AmortizationInstallment;
import com.allianceever.creditos.model.ApprovalAudit;
import com.allianceever.creditos.model.ApplicantProfile;
import com.allianceever.creditos.model.CreditRequest;
import com.allianceever.creditos.model.CreditType;
import com.allianceever.creditos.repository.AmortizationInstallmentRepository;
import com.allianceever.creditos.repository.ApplicantProfileRepository;
import com.allianceever.creditos.repository.ApprovalAuditRepository;
import com.allianceever.creditos.repository.CreditRequestRepository;
import com.allianceever.creditos.repository.CreditTypeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CreditRequestService {

    private final CreditRequestRepository creditRequestRepository;
    private final CreditTypeRepository creditTypeRepository;
    private final ApplicantProfileRepository applicantProfileRepository;
    private final ScoringService scoringService;
    private final AmortizationService amortizationService;
    private final ApprovalAuditRepository approvalAuditRepository;
    private final AmortizationInstallmentRepository amortizationInstallmentRepository;

    @Transactional
    public CreditRequestDTO submitRequest(CreditRequestDTO dto) {
        CreditType type = creditTypeRepository.findById(dto.getCreditTypeId())
                .orElseThrow(() -> new RuntimeException("Credit type not found"));

        ApplicantProfile profile = applicantProfileRepository.findByUserId(dto.getApplicantUserId())
                .orElseThrow(() -> new RuntimeException(
                        "Applicant profile not found for user_id: " + dto.getApplicantUserId()));

        // Validaciones básicas de política
        validateCreditPolicy(dto, type);

        CreditRequest request = CreditRequest.builder()
                .applicant(profile)
                .creditType(type)
                .amount(dto.getAmount())
                .termMonths(dto.getTermMonths())
                .purpose(dto.getPurpose())
                .status("EVALUATING")
                .build();

        CreditRequest saved = creditRequestRepository.save(request);
        return mapToDTO(saved);
    }

    private void validateCreditPolicy(CreditRequestDTO dto, CreditType type) {
        if (dto.getAmount().compareTo(type.getMinAmount()) < 0 || dto.getAmount().compareTo(type.getMaxAmount()) > 0) {
            throw new RuntimeException("Amount out of allowed range for type: " + type.getName());
        }
        if (dto.getTermMonths() < type.getMinTermMonths() || dto.getTermMonths() > type.getMaxTermMonths()) {
            throw new RuntimeException("Term out of allowed range for type: " + type.getName());
        }
    }

    @Transactional
    public CreditRequestDTO evaluateRequest(Long requestId) {
        CreditRequest request = creditRequestRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Request not found"));

        if (!"EVALUATING".equals(request.getStatus()) && !"DRAFT".equals(request.getStatus())) {
            throw new RuntimeException("Request is not in an evaluatable state");
        }

        ScoringService.ScoringResult result = scoringService.evaluate(request);

        request.setScoringResult(result.getResult());
        request.setScoringRecommendation(result.getRecommendation());

        // Si el resultado es APPROVED y es automático, podríamos cambiar estado a
        // APPROVED
        // Pero por ahora solo guardamos el resultado.

        CreditRequest saved = creditRequestRepository.save(request);
        return mapToDTO(saved);
    }

    @Transactional
    public CreditRequestDTO approveRequest(Long requestId, String approver, String comments) {
        CreditRequest request = creditRequestRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Request not found"));

        request.setStatus("APPROVED");

        ApprovalAudit audit = ApprovalAudit.builder()
                .request(request)
                .approverUsername(approver)
                .decision("APPROVED")
                .comments(comments)
                .build();

        approvalAuditRepository.save(audit);
        return mapToDTO(creditRequestRepository.save(request));
    }

    @Transactional
    public CreditRequestDTO disburseRequest(Long requestId) {
        CreditRequest request = creditRequestRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Request not found"));

        if (!"APPROVED".equals(request.getStatus())) {
            throw new RuntimeException("Request must be APPROVED to be disbursed");
        }

        // Generar tabla de amortización
        List<AmortizationInstallment> schedule = amortizationService.generateFrenchSchedule(request);
        amortizationInstallmentRepository.saveAll(schedule);

        request.setStatus("DISBURSED");
        return mapToDTO(creditRequestRepository.save(request));
    }

    @Transactional
    public CreditRequestDTO restructureCredit(Long requestId, Integer newTerm, String approver, String comments) {
        CreditRequest request = creditRequestRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Request not found"));

        if (!"DISBURSED".equals(request.getStatus())) {
            throw new RuntimeException("Only disbursed/active credits can be restructured");
        }

        // Eliminar cuotas pendientes
        List<AmortizationInstallment> pending = amortizationInstallmentRepository
                .findByRequestIdOrderByInstallmentNumber(requestId)
                .stream().filter(i -> "PENDING".equals(i.getStatus())).collect(Collectors.toList());

        amortizationInstallmentRepository.deleteAll(pending);

        // Actualizar plazo y generar nueva tabla (Simplificado: asume que el monto se
        // recalcula sobre el saldo actual)
        request.setTermMonths(newTerm);
        List<AmortizationInstallment> newSchedule = amortizationService.generateFrenchSchedule(request);
        amortizationInstallmentRepository.saveAll(newSchedule);

        ApprovalAudit audit = ApprovalAudit.builder()
                .request(request)
                .approverUsername(approver)
                .decision("RESTRUCTURED")
                .comments(comments)
                .build();

        approvalAuditRepository.save(audit);
        return mapToDTO(creditRequestRepository.save(request));
    }

    public List<CreditRequestDTO> getRequestsByUserId(Long userId) {
        return creditRequestRepository.findByApplicantUserId(userId).stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    private CreditRequestDTO mapToDTO(CreditRequest entity) {
        return CreditRequestDTO.builder()
                .id(entity.getId())
                .applicantUserId(entity.getApplicant().getUserId())
                .creditTypeId(entity.getCreditType().getId())
                .amount(entity.getAmount())
                .termMonths(entity.getTermMonths())
                .purpose(entity.getPurpose())
                .status(entity.getStatus())
                .scoringResult(entity.getScoringResult())
                .build();
    }
}
