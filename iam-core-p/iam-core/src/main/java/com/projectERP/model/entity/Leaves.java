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
@Table(name = "Leaves")
public class Leaves {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "leaves_id")
    private Long leavesID;

    private String username;

    private String EmployeeName;

    @ManyToOne
    @JoinColumn(name = "leave_type_id")
    private LeaveType leaveType;

    private Integer NumberOfDays;

    @Column(name = "start_date")
    private LocalDate StartDate;

    private LocalDate EndDate;

    private String LeaveReason;

    private String ApprovedBy;

    private String Status;

}
