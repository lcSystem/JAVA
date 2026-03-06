package com.creditos.service;

import com.creditos.model.CreditType;
import com.creditos.repository.CreditTypeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CreditTypeService {

    private final CreditTypeRepository creditTypeRepository;

    public List<CreditType> getAllActiveCreditTypes() {
        return creditTypeRepository.findAllActive();
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

    @Transactional
    public void deleteCreditType(Long id) {
        System.out.println("[CreditTypeService] Attempting to explicit soft-delete credit type with ID: " + id);
        try {
            creditTypeRepository.softDeleteById(id);
            System.out.println("[CreditTypeService] Successfully soft-deleted credit type with ID: " + id);
        } catch (Exception e) {
            System.err.println(
                    "[CreditTypeService] Error soft-deleting credit type with ID: " + id + ". Error: "
                            + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
}
