package com.clientauth.service;

import com.clientauth.dto.*;
import com.clientauth.entity.ClientRefreshToken;
import com.clientauth.entity.CustomerAuthEntity;
import com.clientauth.exception.AccountLockedException;
import com.clientauth.exception.InvalidCredentialsException;
import com.clientauth.repository.CustomerAuthRepository;
import com.clientauth.repository.RefreshTokenRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class ClientAuthService {

        private final CustomerAuthRepository customerRepo;
        private final RefreshTokenRepository refreshTokenRepo;
        private final JwtService jwtService;
        private final PasswordEncoder passwordEncoder;

        private static final int MAX_LOGIN_ATTEMPTS = 3;

        /**
         * Authenticate a client using their cédula (document number) and password.
         */
        @Transactional
        public LoginResponse login(LoginRequest request) {
                CustomerAuthEntity customer = customerRepo
                                .findByDocumentNumber(request.getCedula())
                                .orElseThrow(() -> new InvalidCredentialsException("Credenciales inválidas"));

                // Reload with addresses and contacts eagerly
                customer = customerRepo.findByIdWithDetails(customer.getId())
                                .orElseThrow(() -> new InvalidCredentialsException("Cliente no encontrado"));

                // 1. Check customer status BEFORE checking password
                if (!"ACTIVE".equals(customer.getStatus())) {
                        throw new AccountLockedException("La cuenta no está activa. Contacte soporte.");
                }

                // 2. Verify password
                try {
                        if (customer.getPasswordHash() == null
                                        || !passwordEncoder.matches(request.getPassword(),
                                                        customer.getPasswordHash())) {
                                throw new InvalidCredentialsException("Credenciales inválidas");
                        }
                } catch (InvalidCredentialsException e) {
                        updateFailedLoginAttempts(customer.getDocumentNumber());
                        throw e;
                }

                // Successful login — reset attempts
                customer.setLoginAttempts(0);
                customer.setAccountLocked(false);
                customer.setLastLogin(LocalDateTime.now());
                customerRepo.save(customer);

                // Generate tokens
                String accessToken = jwtService.generateToken(
                                customer.getId(),
                                customer.getDocumentNumber(),
                                customer.getName());

                String refreshToken = createRefreshToken(customer.getId(), request.getDeviceInfo());

                log.info("Client login successful: cedula={}", request.getCedula());

                return LoginResponse.builder()
                                .token(accessToken)
                                .refreshToken(refreshToken)
                                .expiresIn(jwtService.getExpirationSeconds())
                                .customer(toProfileResponse(customer))
                                .build();
        }

        /**
         * Refresh an expired access token using a valid refresh token.
         */
        @Transactional
        public LoginResponse refresh(RefreshRequest request) {
                ClientRefreshToken refreshToken = refreshTokenRepo
                                .findByTokenAndRevokedFalse(request.getRefreshToken())
                                .orElseThrow(() -> new InvalidCredentialsException("Refresh token inválido"));

                if (refreshToken.getExpiresAt().isBefore(LocalDateTime.now())) {
                        refreshToken.setRevoked(true);
                        refreshTokenRepo.save(refreshToken);
                        throw new InvalidCredentialsException("Refresh token expirado");
                }

                CustomerAuthEntity customer = customerRepo.findByIdWithDetails(refreshToken.getCustomerId())
                                .orElseThrow(() -> new InvalidCredentialsException("Cliente no encontrado"));

                // Revoke old refresh token
                refreshToken.setRevoked(true);
                refreshTokenRepo.save(refreshToken);

                // Generate new tokens
                String newAccessToken = jwtService.generateToken(
                                customer.getId(),
                                customer.getDocumentNumber(),
                                customer.getName());

                String newRefreshToken = createRefreshToken(customer.getId(), refreshToken.getDeviceInfo());

                return LoginResponse.builder()
                                .token(newAccessToken)
                                .refreshToken(newRefreshToken)
                                .expiresIn(jwtService.getExpirationSeconds())
                                .customer(toProfileResponse(customer))
                                .build();
        }

        /**
         * Logout — revoke all refresh tokens for this customer.
         */
        @Transactional
        public void logout(Long customerId) {
                refreshTokenRepo.revokeAllByCustomerId(customerId);
                log.info("Client logout: customerId={}", customerId);
        }

        /**
         * Change password for a client.
         */
        @Transactional
        public void changePassword(Long customerId, ChangePasswordRequest request) {
                CustomerAuthEntity customer = customerRepo.findById(customerId)
                                .orElseThrow(() -> new InvalidCredentialsException("Cliente no encontrado"));

                if (!passwordEncoder.matches(request.getCurrentPassword(), customer.getPasswordHash())) {
                        throw new InvalidCredentialsException("La contraseña actual es incorrecta");
                }

                customer.setPasswordHash(passwordEncoder.encode(request.getNewPassword()));
                customerRepo.save(customer);

                // Revoke all tokens (force re-login)
                refreshTokenRepo.revokeAllByCustomerId(customerId);
                log.info("Client password changed: customerId={}", customerId);
        }

        /**
         * Updates the failed login attempts in a separate transaction.
         * This ensures that the increment is persisted even if the main login
         * transaction rolls back.
         */
        @Transactional(propagation = Propagation.REQUIRES_NEW)
        public void updateFailedLoginAttempts(String documentNumber) {
                CustomerAuthEntity customer = customerRepo.findByDocumentNumber(documentNumber)
                                .orElse(null);
                if (customer == null)
                        return;

                int attempts = (customer.getLoginAttempts() == null ? 0 : customer.getLoginAttempts()) + 1;
                customer.setLoginAttempts(attempts);

                if (attempts >= MAX_LOGIN_ATTEMPTS) {
                        customer.setStatus("INACTIVE");
                        customer.setAccountLocked(true);
                        log.warn("Account completely locked (status INACTIVE) for cedula={} after {} attempts",
                                        customer.getDocumentNumber(), attempts);
                }

                customerRepo.save(customer);
        }

        private void handleFailedLogin(CustomerAuthEntity customer) {
                // This method is now legacy or can be removed, but I'll keep it for internal
                // use if needed
                // though updateFailedLoginAttempts is preferred now.
                updateFailedLoginAttempts(customer.getDocumentNumber());
        }

        private String createRefreshToken(Long customerId, String deviceInfo) {
                String tokenValue = UUID.randomUUID().toString();
                ClientRefreshToken token = ClientRefreshToken.builder()
                                .customerId(customerId)
                                .token(tokenValue)
                                .deviceInfo(deviceInfo)
                                .expiresAt(LocalDateTime.now()
                                                .plusSeconds(jwtService.getRefreshExpirationMs() / 1000))
                                .build();
                refreshTokenRepo.save(token);
                return tokenValue;
        }

        private CustomerProfileResponse toProfileResponse(CustomerAuthEntity customer) {
                return CustomerProfileResponse.builder()
                                .id(customer.getId())
                                .name(customer.getName())
                                .documentNumber(customer.getDocumentNumber())
                                .email(customer.getEmail())
                                .phone(customer.getPhone())
                                .type(customer.getType())
                                .status(customer.getStatus())
                                .addresses(customer.getAddresses() != null ? customer.getAddresses().stream()
                                                .map(addr -> com.clientauth.dto.CustomerAddressResponse.builder()
                                                                .id(addr.getId())
                                                                .street(addr.getStreet())
                                                                .city(addr.getCity())
                                                                .state(addr.getState())
                                                                .country(addr.getCountry())
                                                                .postalCode(addr.getPostalCode())
                                                                .type(addr.getType())
                                                                .build())
                                                .collect(java.util.stream.Collectors.toList())
                                                : java.util.Collections.emptyList())
                                .contacts(customer.getContacts() != null ? customer.getContacts().stream()
                                                .map(contact -> com.clientauth.dto.CustomerContactResponse.builder()
                                                                .id(contact.getId())
                                                                .name(contact.getName())
                                                                .phone(contact.getPhone())
                                                                .email(contact.getEmail())
                                                                .position(contact.getPosition())
                                                                .documentNumber(contact.getDocumentNumber())
                                                                .birthDate(contact.getBirthDate())
                                                                .isLegalRepresentative(
                                                                                contact.getIsLegalRepresentative())
                                                                .build())
                                                .collect(java.util.stream.Collectors.toList())
                                                : java.util.Collections.emptyList())
                                .build();
        }
}
