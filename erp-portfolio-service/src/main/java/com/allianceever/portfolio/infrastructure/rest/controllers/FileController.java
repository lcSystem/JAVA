package com.allianceever.portfolio.infrastructure.rest.controllers;

import lombok.extern.slf4j.Slf4j;

import com.allianceever.portfolio.domain.model.FileItem;
import com.allianceever.portfolio.domain.model.FileVersion;
import com.allianceever.portfolio.domain.ports.in.FileUseCase;
import com.allianceever.portfolio.infrastructure.rest.dto.*;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.InputStreamResource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/portfolio/files")
@RequiredArgsConstructor
@Slf4j
public class FileController {

        private final FileUseCase fileUseCase;

        @PostMapping("/upload")
        @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_WRITE')")
        public ResponseEntity<FileResponse> uploadFile(
                        @RequestParam("file") MultipartFile file,
                        @RequestParam(value = "folderId", required = false) UUID folderId,
                        @AuthenticationPrincipal Jwt jwt) throws IOException {

                log.info("UPLOAD DEBUG: Received upload request for file {} ({} bytes) for owner {}",
                                file.getOriginalFilename(), file.getSize(), getOwnerId(jwt));

                // Use streaming: file.getInputStream(), NOT file.getBytes()
                InputStream inputStream = file.getInputStream();
                FileItem saved = fileUseCase.uploadFile(
                                file.getOriginalFilename(),
                                file.getSize(),
                                file.getContentType(),
                                inputStream,
                                folderId,
                                getOwnerId(jwt));

                return ResponseEntity.status(HttpStatus.CREATED).body(toResponse(saved));
        }

        @GetMapping("/{id}/download")
        @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_READ')")
        public ResponseEntity<InputStreamResource> downloadFile(
                        @PathVariable UUID id,
                        @AuthenticationPrincipal Jwt jwt) {

                FileItem fileMeta = fileUseCase.getFileById(id, getOwnerId(jwt));
                InputStream stream = fileUseCase.downloadFile(id, getOwnerId(jwt));

                return ResponseEntity.ok()
                                .header(HttpHeaders.CONTENT_DISPOSITION,
                                                "attachment; filename=\"" + fileMeta.getName() + "\"")
                                .contentType(MediaType.parseMediaType(
                                                fileMeta.getMimeType() != null ? fileMeta.getMimeType()
                                                                : "application/octet-stream"))
                                .contentLength(fileMeta.getSizeBytes())
                                .body(new InputStreamResource(stream));
        }

        @GetMapping("/{id}")
        @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_READ')")
        public ResponseEntity<FileResponse> getFileMetadata(
                        @PathVariable UUID id,
                        @AuthenticationPrincipal Jwt jwt) {

                return ResponseEntity.ok(toResponse(fileUseCase.getFileById(id, getOwnerId(jwt))));
        }

        @GetMapping("/folder/{folderId}")
        @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_READ')")
        public ResponseEntity<Page<FileResponse>> listByFolder(
                        @PathVariable UUID folderId,
                        @AuthenticationPrincipal Jwt jwt,
                        @PageableDefault(size = 20) Pageable pageable) {

                log.info("LIST BY FOLDER DEBUG: Requesting files for folder {} and owner {}", folderId,
                                getOwnerId(jwt));
                Page<FileResponse> page = fileUseCase.listFilesByFolder(folderId, getOwnerId(jwt), pageable)
                                .map(this::toResponse);
                return ResponseEntity.ok(page);
        }

        @GetMapping("/root")
        @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_READ')")
        public ResponseEntity<Page<FileResponse>> listRootFiles(
                        @AuthenticationPrincipal Jwt jwt,
                        @PageableDefault(size = 20) Pageable pageable) {

                log.info("LIST ROOT DEBUG: Requesting root files for owner {}", getOwnerId(jwt));
                Page<FileResponse> page = fileUseCase.listRootFiles(getOwnerId(jwt), pageable)
                                .map(this::toResponse);
                return ResponseEntity.ok(page);
        }

        @GetMapping("/{id}/versions")
        @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_READ')")
        public ResponseEntity<List<FileVersionResponse>> getVersions(
                        @PathVariable UUID id,
                        @AuthenticationPrincipal Jwt jwt) {

                List<FileVersionResponse> versions = fileUseCase.getFileVersions(id, getOwnerId(jwt))
                                .stream().map(this::toVersionResponse).collect(Collectors.toList());
                return ResponseEntity.ok(versions);
        }

        @PutMapping("/{id}/rename")
        @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_WRITE')")
        public ResponseEntity<FileResponse> renameFile(
                        @PathVariable UUID id,
                        @Valid @RequestBody RenameRequest request,
                        @AuthenticationPrincipal Jwt jwt) {

                return ResponseEntity.ok(toResponse(fileUseCase.renameFile(id, request.getNewName(), getOwnerId(jwt))));
        }

        @PutMapping("/{id}/move")
        @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_WRITE')")
        public ResponseEntity<FileResponse> moveFile(
                        @PathVariable UUID id,
                        @Valid @RequestBody MoveRequest request,
                        @AuthenticationPrincipal Jwt jwt) {

                return ResponseEntity
                                .ok(toResponse(fileUseCase.moveFile(id, request.getTargetFolderId(), getOwnerId(jwt))));
        }

        @DeleteMapping("/{id}")
        @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_DELETE')")
        public ResponseEntity<Void> softDelete(
                        @PathVariable UUID id,
                        @AuthenticationPrincipal Jwt jwt) {

                fileUseCase.softDeleteFile(id, getOwnerId(jwt));
                return ResponseEntity.noContent().build();
        }

        @DeleteMapping("/{id}/hard")
        @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_DELETE')")
        public ResponseEntity<Void> hardDelete(
                        @PathVariable UUID id,
                        @AuthenticationPrincipal Jwt jwt) {

                fileUseCase.hardDeleteFile(id, getOwnerId(jwt));
                return ResponseEntity.noContent().build();
        }

        // ─── Mapping helpers ────────────────────────────────────────────

        private String getOwnerId(Jwt jwt) {
                return jwt.getSubject();
        }

        private FileResponse toResponse(FileItem file) {
                return FileResponse.builder()
                                .id(file.getId())
                                .name(file.getName())
                                .originalName(file.getOriginalName())
                                .folderId(file.getFolderId())
                                .mimeType(file.getMimeType())
                                .extension(file.getExtension())
                                .sizeBytes(file.getSizeBytes())
                                .tags(file.getTags())
                                .fileType(file.getFileType() != null ? file.getFileType().name() : null)
                                .createdAt(file.getCreatedAt())
                                .updatedAt(file.getUpdatedAt())
                                .build();
        }

        private FileVersionResponse toVersionResponse(FileVersion v) {
                return FileVersionResponse.builder()
                                .id(v.getId())
                                .fileId(v.getFileId())
                                .versionNumber(v.getVersionNumber())
                                .sizeBytes(v.getSizeBytes())
                                .checksum(v.getChecksum())
                                .createdBy(v.getCreatedBy())
                                .createdAt(v.getCreatedAt())
                                .build();
        }
}
