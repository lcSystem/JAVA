package com.projectERP.AuthenticatedBackend.security;

import java.util.HashSet;
import java.util.Set;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Component;

import com.projectERP.AuthenticatedBackend.infrastructure.messaging.dto.NotificationLevel;
import com.projectERP.AuthenticatedBackend.infrastructure.messaging.dto.NotificationType;
import com.projectERP.AuthenticatedBackend.infrastructure.messaging.dto.SystemNotificationEvent;
import com.projectERP.AuthenticatedBackend.infrastructure.messaging.publisher.SystemNotificationPublisher;
import com.projectERP.AuthenticatedBackend.repository.RoleRepository;
import com.projectERP.AuthenticatedBackend.services.PermissionService;

/**
 * AOP Aspect that intercepts methods annotated with @RequirePermission
 * and validates RBAC authorization against the role_menu_permission table.
 */
@Aspect
@Component
public class RequirePermissionAspect {

    @Autowired
    private PermissionService permissionService;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private SystemNotificationPublisher systemNotificationPublisher;

    @Around("@annotation(requirePermission)")
    public Object checkPermission(ProceedingJoinPoint joinPoint, RequirePermission requirePermission) throws Throwable {
        String menuCodigo = requirePermission.menu();
        String action = requirePermission.action();

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()) {
            throw new AccessDeniedException("User is not authenticated");
        }

        Set<String> roleNames = new HashSet<>();
        Set<Integer> roleIds = new HashSet<>();
        String userId = null;

        if (authentication instanceof JwtAuthenticationToken) {
            JwtAuthenticationToken jwtAuth = (JwtAuthenticationToken) authentication;
            Jwt jwt = jwtAuth.getToken();
            userId = jwt.getSubject();

            // Extract roles from JWT claim
            String rolesStr = jwt.getClaimAsString("roles");
            if (rolesStr != null) {
                for (String roleName : rolesStr.split(" ")) {
                    String cleanRole = roleName.trim();
                    if (!cleanRole.isEmpty()) {
                        roleNames.add(cleanRole);
                        // Look up role ID from DB
                        roleRepository.findByAuthority(cleanRole)
                                .ifPresent(role -> roleIds.add(role.getRoleId()));
                    }
                }
            }
        } else {
            // Fallback: extract from granted authorities
            authentication.getAuthorities().forEach(auth -> {
                String authority = auth.getAuthority();
                if (authority.startsWith("ROLE_")) {
                    authority = authority.substring(5);
                }
                roleNames.add(authority);
                roleRepository.findByAuthority(authority)
                        .ifPresent(role -> roleIds.add(role.getRoleId()));
            });
        }

        if (roleIds.isEmpty()) {
            throw new AccessDeniedException("No roles found for current user");
        }

        if (!permissionService.hasPermission(roleNames, roleIds, menuCodigo, action)) {
            String message = "No tienes permisos para realizar esta accion en menu " + menuCodigo;
            try {
                if (userId != null) {
                    final String finalUserId = userId;
                    SystemNotificationEvent event = SystemNotificationEvent.builder()
                            .userId(finalUserId)
                            .message("Intento de acceso no autorizado. " + message)
                            .type(NotificationType.SYSTEM)
                            .level(NotificationLevel.ERROR)
                            .extraData("Acción rechazada: " + action + " en menú: " + menuCodigo)
                            .build();
                    systemNotificationPublisher.publishNotification(event);
                }
            } catch (Exception ignored) {
            }
            throw new AccessDeniedException(message);
        }

        return joinPoint.proceed();
    }
}
