package com.allianceever.projectERP.controller;

import com.allianceever.projectERP.model.dto.EstimatesInvoicesDto;
import com.allianceever.projectERP.service.EstimatesInvoicesService;
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
@RequestMapping("/api/invoice")
@AllArgsConstructor
public class InvoiceController {
    
    private EstimatesInvoicesService estimatesInvoicesService;

    // Build Get All Invoices REST API
    @GetMapping("/all")
    public ResponseEntity<List<EstimatesInvoicesDto>> getAllInvoices(){
        List<EstimatesInvoicesDto> invoices = estimatesInvoicesService.getAllInvoices();
        return ResponseEntity.ok(invoices);
    }

    // Build Get Invoice by ID REST API
    @GetMapping("/{id}")
    public ResponseEntity<EstimatesInvoicesDto> getInvoiceById(@PathVariable("id") Integer invoiceID){
        EstimatesInvoicesDto invoiceDto = estimatesInvoicesService.getById(invoiceID);
        if (invoiceDto != null) {
            return ResponseEntity.ok(invoiceDto);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Build Create Invoice REST API
    @PostMapping("/create")
    public ResponseEntity<EstimatesInvoicesDto> createInvoice(@ModelAttribute EstimatesInvoicesDto estimatesInvoicesDto, @AuthenticationPrincipal Jwt jwt){
        EstimatesInvoicesDto createdInvoice = estimatesInvoicesService.create(estimatesInvoicesDto);
        return new ResponseEntity<>(createdInvoice, CREATED);
    }

    // Build Update Invoice REST API
    @PostMapping("/updateInvoice")
    public ResponseEntity<EstimatesInvoicesDto> updateInvoice(@ModelAttribute EstimatesInvoicesDto estimatesInvoicesDto){
        Integer invoiceID = estimatesInvoicesDto.getId();
        EstimatesInvoicesDto existingInvoice = estimatesInvoicesService.getById(invoiceID);
        if (existingInvoice == null) {
            return ResponseEntity.notFound().build();
        }
        // Perform a partial update of the existingInvoice using the estimatesInvoicesDto data
        BeanUtils.copyProperties(estimatesInvoicesDto, existingInvoice, getNullPropertyNames(estimatesInvoicesDto));

        // Save the updated invoice data back to the database
        EstimatesInvoicesDto updatedInvoice = estimatesInvoicesService.update(invoiceID, existingInvoice);
        return ResponseEntity.ok(updatedInvoice);
    }

    // Build Delete Invoice REST API
    @PostMapping("/delete/{id}")
    public ResponseEntity<String> deleteInvoice(@PathVariable("id") Integer invoiceID){
        EstimatesInvoicesDto invoiceDto = estimatesInvoicesService.getById(invoiceID);
        if (invoiceDto != null) {
            estimatesInvoicesService.delete(invoiceID);
            return ResponseEntity.ok("Invoice deleted successfully!");
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Helper method to get the names of null properties in the estimatesInvoicesDto
    public static String[] getNullPropertyNames(Object source) {
        final BeanWrapper src = new BeanWrapperImpl(source);
        java.beans.PropertyDescriptor[] pds = src.getPropertyDescriptors();

        Set<String> emptyNames = new HashSet<String>();
        for (java.beans.PropertyDescriptor pd : pds) {
            Object srcValue = src.getPropertyValue(pd.getName());
            if (srcValue == null) emptyNames.add(pd.getName());
        }
        String[] result = new String[emptyNames.size()];
        return emptyNames.toArray(result);
    }
}
