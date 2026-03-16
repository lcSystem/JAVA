package com.creditos.config;

import com.creditos.security.CustomAuthoritiesConverter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.web.SecurityFilterChain;

import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    @Value("${spring.security.oauth2.resourceserver.jwt.jwk-set-uri}")
    private String jwkSetUri;

    @Value("${jwt.secret}")
    private String clientAuthSecret;

    @Value("${jwt.issuer:client-auth}")
    private String clientAuthIssuer;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .cors(org.springframework.security.config.Customizer.withDefaults())
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        .anyRequest().authenticated())
                .oauth2ResourceServer(oauth2 -> oauth2
                        .jwt(jwt -> jwt.decoder(jwtDecoder())
                                .jwtAuthenticationConverter(jwtAuthenticationConverter())));
        return http.build();
    }

    @Bean
    public JwtAuthenticationConverter jwtAuthenticationConverter() {
        JwtAuthenticationConverter converter = new JwtAuthenticationConverter();
        converter.setJwtGrantedAuthoritiesConverter(new CustomAuthoritiesConverter());
        return converter;
    }

    @Bean
    public JwtDecoder jwtDecoder() {
        // 1. RSA Decoder for iam-core (Admin)
        NimbusJwtDecoder rsaDecoder = NimbusJwtDecoder.withJwkSetUri(jwkSetUri).build();

        // 2. HMAC Decoder for client-auth-service (Mobile)
        byte[] keyBytes = Base64.getDecoder().decode(clientAuthSecret);
        SecretKeySpec secretKey = new SecretKeySpec(keyBytes, "HmacSHA512");
        NimbusJwtDecoder hmacDecoder = NimbusJwtDecoder.withSecretKey(secretKey)
                .macAlgorithm(MacAlgorithm.HS512)
                .build();

        // 3. Delegating Decoder based on issuer
        return token -> {
            try {
                String issuer = decodeIssuer(token);
                if (clientAuthIssuer.equals(issuer)) {
                    return hmacDecoder.decode(token);
                }
            } catch (Exception ignored) {
            }

            return rsaDecoder.decode(token);
        };
    }

    private String decodeIssuer(String token) {
        try {
            String[] parts = token.split("\\.");
            if (parts.length < 2)
                return null;
            String payloadJson = new String(Base64.getUrlDecoder().decode(parts[1]), StandardCharsets.UTF_8);
            // Basic regex to extract "iss":"..." to avoid needing Jackson ObjectMapper if
            // not sure
            java.util.regex.Matcher matcher = java.util.regex.Pattern.compile("\"iss\"\\s*:\\s*\"([^\"]+)\"")
                    .matcher(payloadJson);
            if (matcher.find()) {
                return matcher.group(1);
            }
        } catch (Exception e) {
            return null;
        }
        return null;
    }

    @Bean
    public org.springframework.web.cors.CorsConfigurationSource corsConfigurationSource() {
        org.springframework.web.cors.CorsConfiguration configuration = new org.springframework.web.cors.CorsConfiguration();
        configuration.setAllowedOriginPatterns(java.util.List.of(
                "http://localhost:*",
                "http://127.0.0.1:*",
                "http://10.0.2.2:*"));
        configuration.setAllowedMethods(java.util.List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(java.util.List.of("*"));
        configuration.setAllowCredentials(true);
        org.springframework.web.cors.UrlBasedCorsConfigurationSource source = new org.springframework.web.cors.UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
