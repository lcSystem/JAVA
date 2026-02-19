package com.allianceever.creditos.infrastructure.adapters;

import com.allianceever.creditos.domain.model.CreditRequest;
import com.allianceever.creditos.domain.ports.out.CreditRequestRepositoryPort;
import com.allianceever.creditos.infrastructure.mappers.CreditRequestMapper;
import com.allianceever.creditos.model.ApplicantProfile;
import com.allianceever.creditos.repository.ApplicantProfileRepository;
import com.allianceever.creditos.repository.CreditRequestRepository;
import com.allianceever.creditos.repository.CreditTypeRepository;
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
        com.allianceever.creditos.model.CreditRequest entity = CreditRequestMapper.toEntity(creditRequest);

        // Fetch and set relationships
        if (creditRequest.getId() != null) {
            // Update existing
            com.allianceever.creditos.model.CreditRequest existing = creditRequestRepository
                    .findById(creditRequest.getId())
                    .orElseThrow(() -> new RuntimeException("Credit request not found"));
            entity = existing;
            entity.setStatus(creditRequest.getStatus());
            entity.setScoringResult(creditRequest.getScoringResult());
            entity.setScoringRecommendation(creditRequest.getScoringRecommendation());
        } else {
            // New request
            ApplicantProfile applicant = applicantProfileRepository.findByUserId(creditRequest.getApplicantUserId())
                    .orElseThrow(() -> new RuntimeException(
                            "Applicant profile not found for user: " + creditRequest.getApplicantUserId()));
            entity.setApplicant(applicant);

            com.allianceever.creditos.model.CreditType type = creditTypeRepository
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
        return creditRequestRepository.findByApplicantUserId(userId).stream()
                .map(CreditRequestMapper::toDomain)
                .collect(Collectors.toList());
    }
}
