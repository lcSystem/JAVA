package com.clientauth.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "customer_addresses")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CustomerAddressEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private CustomerAuthEntity customer;

    private String street;
    private String city;
    private String state;
    private String country;

    @Column(name = "postal_code")
    private String postalCode;

    private String type;
}
