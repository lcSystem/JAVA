package com.allianceever.creditos.service;

import com.allianceever.creditos.model.CreditType;
import com.allianceever.creditos.repository.CreditTypeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CreditTypeService {

    private final CreditTypeRepository creditTypeRepository;

    public List<CreditType> getAllActiveCreditTypes() {
        return creditTypeRepository.findAll(); // In a real app, maybe filter by active=true
    }

    public CreditType getCreditTypeById(Long id) {
        return creditTypeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Credit Type not found"));
    }

    public CreditType saveCreditType(CreditType creditType) {
        return creditTypeRepository.save(creditType);
    }

    public CreditType updateCreditType(Long id, CreditType creditType) {
        CreditType existing = getCreditTypeById(id);
        existing.setName(creditType.getName());
        existing.setDescription(creditType.getDescription());
        existing.setMinAmount(creditType.getMinAmount());
        existing.setMaxAmount(creditType.getMaxAmount());
        existing.setMinTermMonths(creditType.getMinTermMonths());
        existing.setMaxTermMonths(creditType.getMaxTermMonths());
        existing.setAnnualInterestRate(creditType.getAnnualInterestRate());
        existing.setPolicyDescription(creditType.getPolicyDescription());
        existing.setActive(creditType.getActive());
        return creditTypeRepository.save(existing);
    }

    public void deleteCreditType(Long id) {
        creditTypeRepository.deleteById(id);
    }
}
