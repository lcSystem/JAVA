package com.allianceever.projectERP.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDate;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Table(name = "employees")
public class Employee {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "employee_id")
    private Long employeeID;
    private String first_Name;
    private String last_Name;
    @Column(unique = true)
    private String userName;
    private String email;
    private String password;
    @Column(name = "join_date")
    private LocalDate joinDate;
    private String phone;

    @ManyToOne
    @JoinColumn(name = "department_id")
    private Department department;

    @ManyToOne
    @JoinColumn(name = "designation_id")
    private Designation designation;
    private String company;
    private Integer remainingLeaves;
    private String role;
    @Column(name = "pin_code")
    private Double pinCode;
    private String cv_Name;
    private Byte cv;
    @Column(unique = true)
    private String cin;
    private String reportTo;
    private LocalDate birthday;
    private String address;
    private String gender;
    private String state;
    private String country;
    private String imageName;
}
