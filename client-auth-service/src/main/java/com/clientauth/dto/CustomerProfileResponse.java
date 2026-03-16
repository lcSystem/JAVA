package com.clientauth.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CustomerProfileResponse {
    private Long id;
    private String name;
    private String documentNumber;
    private String email;
    private String phone;
    private LocalDate birthDate;
    private String companyName;
    private String position;
    private String workPhone;
    private String corporateEmail;
    private BigDecimal salary;
    private String type;
    private String status;
    private List<CustomerAddressResponse> addresses;
    private List<CustomerContactResponse> contacts;
}
