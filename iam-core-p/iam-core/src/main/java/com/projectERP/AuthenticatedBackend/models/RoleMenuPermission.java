package com.projectERP.AuthenticatedBackend.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import lombok.EqualsAndHashCode;

@Entity
@Table(name = "role_menu_permission", uniqueConstraints = {
        @UniqueConstraint(columnNames = { "role_id", "menu_id" })
})
@Data
@NoArgsConstructor
@AllArgsConstructor
public class RoleMenuPermission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "role_id", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private Role role;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "menu_id", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private Menu menu;

    @Column(name = "can_read", nullable = false, columnDefinition = "TINYINT(1)")
    private Boolean canRead = false;

    @Column(name = "can_create", nullable = false, columnDefinition = "TINYINT(1)")
    private Boolean canCreate = false;

    @Column(name = "can_update", nullable = false, columnDefinition = "TINYINT(1)")
    private Boolean canUpdate = false;

    @Column(name = "can_delete", nullable = false, columnDefinition = "TINYINT(1)")
    private Boolean canDelete = false;
}
