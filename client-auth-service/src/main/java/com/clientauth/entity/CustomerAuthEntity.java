package com.clientauth.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Set;

/**
 * Maps to the existing 'customers' table in the customer database.
 * Only includes fields needed for authentication and profile display.
 */
@Entity
@Table(name = "customers")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CustomerAuthEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "document_number", nullable = false, unique = true)
    private String documentNumber;

    @Column(length = 150)
    private String email;

    @Column(length = 50)
    private String phone;

    @Column(name = "type", nullable = false)
    private String type;

    @Column(name = "birth_date")
    private LocalDate birthDate;

    @Column(name = "company_name")
    private String companyName;

    private String position;

    @Column(name = "work_phone")
    private String workPhone;

    @Column(name = "corporate_email")
    private String corporateEmail;

    private BigDecimal salary;

    @Column(name = "status")
    private String status;

    @Column(name = "password_hash")
    private String passwordHash;

    @Column(name = "last_login")
    private LocalDateTime lastLogin;

    @Column(name = "login_attempts")
    @Builder.Default
    private Integer loginAttempts = 0;

    @Column(name = "account_locked")
    @Builder.Default
    private Boolean accountLocked = false;

    @Column(name = "lock_expires_at")
    private LocalDateTime lockExpiresAt;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "customer", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<CustomerAddressEntity> addresses;

    @OneToMany(mappedBy = "customer", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<CustomerContactEntity> contacts;
}
