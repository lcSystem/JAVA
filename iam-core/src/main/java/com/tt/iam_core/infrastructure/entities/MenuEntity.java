package com.tt.iam_core.infrastructure.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.Set;

@Entity
@Getter
@Setter
@Table(name = "menu")
public class MenuEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(length = 255)
    private String ruta;

    @Column(length = 50)
    private String icono;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private MenuEntity parent;

    @Column(nullable = false)
    private Integer orden = 0;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private EstadoMenuEntity estado = EstadoMenuEntity.ACTIVO;

    @OneToMany(mappedBy = "menu", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<MenuPermisoEntity> permisos;

    @OneToMany(mappedBy = "parent", fetch = FetchType.LAZY)
    private Set<MenuEntity> subMenus;

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (!(o instanceof MenuEntity))
            return false;
        MenuEntity menu = (MenuEntity) o;
        return id != null && id.equals(menu.getId());
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}
