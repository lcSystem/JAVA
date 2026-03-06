package com.creditos.infrastructure.adapters;

import com.creditos.domain.model.CreditRequest;
import com.creditos.domain.ports.out.CreditRequestRepositoryPort;
import com.creditos.infrastructure.mappers.CreditRequestMapper;
import com.creditos.model.ApplicantProfile;
import com.creditos.repository.ApplicantProfileRepository;
import com.creditos.repository.CreditRequestRepository;
import com.creditos.repository.CreditTypeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class CreditRequestRepositoryAdapter implements CreditRequestRepositoryPort {

    private final CreditRequestRepository creditRequestRepository;
    private final CreditTypeRepository creditTypeRepository;
    private final ApplicantProfileRepository applicantProfileRepository;

    @Override
    public CreditRequest save(CreditRequest creditRequest) {
        com.creditos.model.CreditRequest entity = CreditRequestMapper.toEntity(creditRequest);

        // Fetch and set relationships
        if (creditRequest.getId() != null) {
            // Update existing
            com.creditos.model.CreditRequest existing = creditRequestRepository
                    .findById(creditRequest.getId())
                    .orElseThrow(() -> new RuntimeException("Credit request not found"));
            entity = existing;
            entity.setStatus(creditRequest.getStatus());
            entity.setScoringResult(creditRequest.getScoringResult());
            entity.setScoringRecommendation(creditRequest.getScoringRecommendation());
        } else {
            // New request
            ApplicantProfile applicant = applicantProfileRepository.findByUserId(creditRequest.getApplicantUserId())
                    .orElseGet(() -> {
                        ApplicantProfile newProfile = ApplicantProfile.builder()
                                .userId(creditRequest.getApplicantUserId())
                                .monthlyIncome(java.math.BigDecimal.ZERO)
                                .monthlyExpenses(java.math.BigDecimal.ZERO)
                                .currentDebts(java.math.BigDecimal.ZERO)
                                .build();
                        return applicantProfileRepository.save(newProfile);
                    });
            entity.setApplicant(applicant);

            com.creditos.model.CreditType type = creditTypeRepository
                    .findById(creditRequest.getCreditType().getId())
                    .orElseThrow(() -> new RuntimeException("Credit type not found"));
            entity.setCreditType(type);
        }

        return CreditRequestMapper.toDomain(creditRequestRepository.save(entity));
    }

    @Override
    public Optional<CreditRequest> findById(Long id) {
        return creditRequestRepository.findById(id).map(CreditRequestMapper::toDomain);
    }

    @Override
    public List<CreditRequest> findByApplicantUserId(Long userId) {
        return creditRequestRepository.findByApplicantUserIdOrderByIdDesc(userId).stream()
                .map(CreditRequestMapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<CreditRequest> findAll() {
        return creditRequestRepository.findAll().stream()
                .map(CreditRequestMapper::toDomain)
                .collect(Collectors.toList());
    }
}
