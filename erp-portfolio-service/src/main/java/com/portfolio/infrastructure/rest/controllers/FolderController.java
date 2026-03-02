package com.portfolio.infrastructure.rest.controllers;

import com.portfolio.domain.model.Folder;
import com.portfolio.domain.ports.in.FolderUseCase;
import com.portfolio.infrastructure.rest.dto.*;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/portfolio/folders")
@RequiredArgsConstructor
public class FolderController {

    private final FolderUseCase folderUseCase;

    @PostMapping
    @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_WRITE')")
    public ResponseEntity<FolderResponse> createFolder(
            @Valid @RequestBody CreateFolderRequest request,
            @AuthenticationPrincipal Jwt jwt) {

        Folder folder = folderUseCase.createFolder(request.getName(), request.getParentId(), getOwnerId(jwt));
        return ResponseEntity.status(HttpStatus.CREATED).body(toResponse(folder));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_READ')")
    public ResponseEntity<FolderResponse> getFolder(
            @PathVariable UUID id,
            @AuthenticationPrincipal Jwt jwt) {

        return ResponseEntity.ok(toResponse(folderUseCase.getFolderById(id, getOwnerId(jwt))));
    }

    @GetMapping("/root")
    @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_READ')")
    public ResponseEntity<List<FolderResponse>> getRootFolders(@AuthenticationPrincipal Jwt jwt) {
        List<FolderResponse> folders = folderUseCase.getRootFolders(getOwnerId(jwt))
                .stream().map(this::toResponse).collect(Collectors.toList());
        return ResponseEntity.ok(folders);
    }

    @GetMapping("/{id}/children")
    @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_READ')")
    public ResponseEntity<List<FolderResponse>> listChildren(
            @PathVariable UUID id,
            @AuthenticationPrincipal Jwt jwt) {

        List<FolderResponse> children = folderUseCase.listChildren(id, getOwnerId(jwt))
                .stream().map(this::toResponse).collect(Collectors.toList());
        return ResponseEntity.ok(children);
    }

    @GetMapping("/{id}/breadcrumb")
    @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_READ')")
    public ResponseEntity<List<FolderResponse>> getBreadcrumb(@PathVariable UUID id) {
        List<FolderResponse> breadcrumb = folderUseCase.getBreadcrumb(id)
                .stream().map(this::toResponse).collect(Collectors.toList());
        return ResponseEntity.ok(breadcrumb);
    }

    @PutMapping("/{id}/rename")
    @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_WRITE')")
    public ResponseEntity<FolderResponse> renameFolder(
            @PathVariable UUID id,
            @Valid @RequestBody RenameRequest request,
            @AuthenticationPrincipal Jwt jwt) {

        return ResponseEntity.ok(toResponse(folderUseCase.renameFolder(id, request.getNewName(), getOwnerId(jwt))));
    }

    @PutMapping("/{id}/move")
    @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_WRITE')")
    public ResponseEntity<FolderResponse> moveFolder(
            @PathVariable UUID id,
            @Valid @RequestBody MoveRequest request,
            @AuthenticationPrincipal Jwt jwt) {

        return ResponseEntity
                .ok(toResponse(folderUseCase.moveFolder(id, request.getTargetFolderId(), getOwnerId(jwt))));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_DELETE')")
    public ResponseEntity<Void> softDelete(
            @PathVariable UUID id,
            @AuthenticationPrincipal Jwt jwt) {

        folderUseCase.softDeleteFolder(id, getOwnerId(jwt));
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{id}/hard")
    @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_DELETE')")
    public ResponseEntity<Void> hardDelete(
            @PathVariable UUID id,
            @AuthenticationPrincipal Jwt jwt) {

        folderUseCase.hardDeleteFolder(id, getOwnerId(jwt));
        return ResponseEntity.noContent().build();
    }

    // ─── Mapping helpers ────────────────────────────────────────────

    private String getOwnerId(Jwt jwt) {
        String username = jwt.getClaimAsString("username");
        return (username != null && !username.isEmpty()) ? username : jwt.getSubject();
    }

    private FolderResponse toResponse(Folder folder) {
        return FolderResponse.builder()
                .id(folder.getId())
                .name(folder.getName())
                .parentId(folder.getParentId())
                .path(folder.getPath())
                .createdAt(folder.getCreatedAt())
                .updatedAt(folder.getUpdatedAt())
                .build();
    }
}
