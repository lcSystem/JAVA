package com.projectERP.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Table(name = "leave_type")
public class LeaveType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "leave_type_id")
    private Long leaveTypeId;

    @Column(name = "username", nullable = false, length = 100)
    private String username;

    @Column(name = "leave_name", nullable = false, unique = true, length = 100)
    private String leaveName;

    @Column(name = "days", nullable = false)
    private Integer days;

    @Column(name = "leave_status", nullable = false, length = 30)
    private String leaveStatus;
}
