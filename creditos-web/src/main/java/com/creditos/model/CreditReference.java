package com.creditos.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "credit_references")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreditReference {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "owner_id", nullable = false)
    private Long ownerId;

    @Column(name = "owner_type", length = 20, nullable = false)
    private String ownerType; // 'APPLICANT' or 'CO_DEBTOR'

    @Column(name = "reference_type", length = 20, nullable = false)
    private String referenceType; // 'FAMILY' or 'PERSONAL'

    @Column(name = "full_name", nullable = false)
    private String fullName;

    @Column(name = "relationship", length = 50)
    private String relationship;

    @Column(name = "phone", length = 20)
    private String phone;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
