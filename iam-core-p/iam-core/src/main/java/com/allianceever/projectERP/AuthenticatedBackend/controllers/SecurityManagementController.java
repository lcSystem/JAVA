package com.allianceever.projectERP.AuthenticatedBackend.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.allianceever.projectERP.AuthenticatedBackend.models.ApplicationUser;
import com.allianceever.projectERP.AuthenticatedBackend.models.Menu;
import com.allianceever.projectERP.AuthenticatedBackend.models.Permiso;
import com.allianceever.projectERP.AuthenticatedBackend.models.Role;
import com.allianceever.projectERP.AuthenticatedBackend.services.SecurityManagementService;

@CrossOrigin(origins = "*") // Adjust as needed
@RestController
@RequestMapping("/api/security")
public class SecurityManagementController {

    @Autowired
    private SecurityManagementService securityService;

    // --- Users ---
    @GetMapping("/users")
    public List<ApplicationUser> getAllUsers() {
        return securityService.getAllUsers();
    }

    @PostMapping("/users")
    public ApplicationUser createUser(@RequestBody ApplicationUser user) {
        return securityService.createUser(user);
    }

    @PutMapping("/users/{id}")
    public ApplicationUser updateUser(@PathVariable Long id, @RequestBody ApplicationUser user) {
        return securityService.updateUser(id, user);
    }

    @DeleteMapping("/users/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable Long id) {
        securityService.deleteUser(id);
        return ResponseEntity.ok().build();
    }

    // --- Roles ---
    @GetMapping("/roles")
    public List<Role> getAllRoles() {
        return securityService.getAllRoles();
    }

    @PostMapping("/roles")
    public Role createRole(@RequestBody Role role) {
        return securityService.createRole(role);
    }

    @PutMapping("/roles/{id}")
    public Role updateRole(@PathVariable Integer id, @RequestBody Role role) {
        return securityService.updateRole(id, role);
    }

    @DeleteMapping("/roles/{id}")
    public ResponseEntity<?> deleteRole(@PathVariable Integer id) {
        securityService.deleteRole(id);
        return ResponseEntity.ok().build();
    }

    // --- Permisos ---
    @GetMapping("/permisos")
    public List<Permiso> getAllPermisos() {
        return securityService.getAllPermisos();
    }

    @PostMapping("/permisos")
    public Permiso createPermiso(@RequestBody Permiso permiso) {
        return securityService.createPermiso(permiso);
    }

    @PutMapping("/permisos/{id}")
    public Permiso updatePermiso(@PathVariable Long id, @RequestBody Permiso permiso) {
        return securityService.updatePermiso(id, permiso);
    }

    @DeleteMapping("/permisos/{id}")
    public ResponseEntity<?> deletePermiso(@PathVariable Long id) {
        securityService.deletePermiso(id);
        return ResponseEntity.ok().build();
    }

    // --- Menus ---
    @GetMapping("/menus")
    public List<Menu> getAllMenus() {
        return securityService.getAllMenus();
    }

    @GetMapping("/menus/root")
    public List<Menu> getRootMenus() {
        return securityService.getRootMenus();
    }

    @PostMapping("/menus")
    public Menu createMenu(@RequestBody Menu menu) {
        return securityService.createMenu(menu);
    }

    @PutMapping("/menus/{id}")
    public Menu updateMenu(@PathVariable Long id, @RequestBody Menu menu) {
        return securityService.updateMenu(id, menu);
    }

    @DeleteMapping("/menus/{id}")
    public ResponseEntity<?> deleteMenu(@PathVariable Long id) {
        securityService.deleteMenu(id);
        return ResponseEntity.ok().build();
    }

    // --- User Menus (filtered by permissions) ---
    @GetMapping("/users/{id}/menus")
    public List<Menu> getUserMenus(@PathVariable Long id) {
        return securityService.getUserMenus(id);
    }
}
