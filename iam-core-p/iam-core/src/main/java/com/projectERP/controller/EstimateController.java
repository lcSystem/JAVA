package com.projectERP.controller;

import com.projectERP.model.dto.EstimatesInvoicesDto;
import com.projectERP.service.EstimatesInvoicesService;
import lombok.AllArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static org.springframework.http.HttpStatus.CREATED;

@RestController
@RequestMapping("/api/estimate")
@AllArgsConstructor
public class EstimateController {

    private EstimatesInvoicesService estimatesInvoicesService;

    // Build Get All Estimates REST API
    @GetMapping("/all")
    public ResponseEntity<List<EstimatesInvoicesDto>> getAllEstimates() {
        List<EstimatesInvoicesDto> estimates = estimatesInvoicesService.getAllEstimates();
        return ResponseEntity.ok(estimates);
    }

    // Build Get Estimate by ID REST API
    @GetMapping("/{id}")
    public ResponseEntity<EstimatesInvoicesDto> getEstimateById(@PathVariable("id") Long estimateID) {
        EstimatesInvoicesDto estimateDto = estimatesInvoicesService.getById(estimateID);
        if (estimateDto != null) {
            return ResponseEntity.ok(estimateDto);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Build Create Estimate REST API
    @PostMapping("/create")
    public ResponseEntity<EstimatesInvoicesDto> createEstimate(
            @ModelAttribute EstimatesInvoicesDto estimatesInvoicesDto, @AuthenticationPrincipal Jwt jwt) {
        EstimatesInvoicesDto createdEstimate = estimatesInvoicesService.create(estimatesInvoicesDto);
        return new ResponseEntity<>(createdEstimate, CREATED);
    }

    // Build Update Estimate REST API
    @PostMapping("/updateEstimate")
    @SuppressWarnings("null")
    public ResponseEntity<EstimatesInvoicesDto> updateEstimate(
            @ModelAttribute EstimatesInvoicesDto estimatesInvoicesDto) {
        Long estimateID = estimatesInvoicesDto.getId();
        EstimatesInvoicesDto existingEstimate = estimatesInvoicesService.getById(estimateID);
        if (existingEstimate == null) {
            return ResponseEntity.notFound().build();
        }
        // Perform a partial update using the DTO data
        BeanUtils.copyProperties(estimatesInvoicesDto, existingEstimate, getNullPropertyNames(estimatesInvoicesDto));

        // Save the updated data back to the database
        EstimatesInvoicesDto updatedEstimate = estimatesInvoicesService.update(estimateID, existingEstimate);
        return ResponseEntity.ok(updatedEstimate);
    }

    // Build Delete Estimate REST API
    @PostMapping("/delete/{id}")
    public ResponseEntity<String> deleteEstimate(@PathVariable("id") Long estimateID) {
        EstimatesInvoicesDto estimateDto = estimatesInvoicesService.getById(estimateID);
        if (estimateDto != null) {
            estimatesInvoicesService.delete(estimateID);
            return ResponseEntity.ok("Estimate deleted successfully!");
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Helper method to get the names of null properties
    @SuppressWarnings("null")
    public static String[] getNullPropertyNames(Object source) {
        final BeanWrapper src = new BeanWrapperImpl(source);
        java.beans.PropertyDescriptor[] pds = src.getPropertyDescriptors();

        Set<String> emptyNames = new HashSet<String>();
        for (java.beans.PropertyDescriptor pd : pds) {
            Object srcValue = src.getPropertyValue(pd.getName());
            if (srcValue == null)
                emptyNames.add(pd.getName());
        }
        String[] result = new String[emptyNames.size()];
        return emptyNames.toArray(result);
    }
}
