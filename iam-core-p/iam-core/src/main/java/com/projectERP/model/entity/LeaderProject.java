package com.allianceever.projectERP.model.entity;

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
@Table(name = "leaderProject")
public class LeaderProject {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "leader_project_id")
    private Long leaderProjectID;
    @Column(name = "project_id")
    private Long projectID;
    @Column(name = "leader_id")
    private Long leaderID;
    private String first_Name;
    private String last_Name;
    private String designation;
    private String imageName;
}
