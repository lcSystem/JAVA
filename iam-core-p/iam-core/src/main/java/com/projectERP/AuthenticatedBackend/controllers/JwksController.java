package com.allianceever.projectERP.AuthenticatedBackend.controllers;

import com.nimbusds.jose.jwk.JWKMatcher;
import com.nimbusds.jose.jwk.JWKSelector;
import com.nimbusds.jose.jwk.JWKSet;
import com.nimbusds.jose.jwk.source.JWKSource;
import com.nimbusds.jose.proc.SecurityContext;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class JwksController {

    private final JWKSource<SecurityContext> jwkSource;

    public JwksController(JWKSource<SecurityContext> jwkSource) {
        this.jwkSource = jwkSource;
    }

    @GetMapping("/api/auth/jwks")
    public Map<String, Object> keys() throws Exception {
        JWKSet jwkSet = new JWKSet(this.jwkSource.get(new JWKSelector(new JWKMatcher.Builder().build()), null));
        return jwkSet.toJSONObject();
    }
}
