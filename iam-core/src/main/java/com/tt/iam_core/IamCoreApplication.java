package com.tt.iam_core;

import com.tt.iam_core.infrastructure.entities.Usuario;
import com.tt.iam_core.infrastructure.repositories.UsuarioRepository; 
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.time.LocalDateTime;

@SpringBootApplication
public class IamCoreApplication {
    public static void main(String[] args) {
        SpringApplication.run(IamCoreApplication.class, args);
    }

    @Bean
    CommandLineRunner testDb(UsuarioRepository repo) {
        return args -> {
            Usuario u = new Usuario();
            u.setUsername("admin");
            u.setEmail("admin@empresa.com");
            u.setPasswordHash("123456");
            u.setEstado(true); 
            u.setFechaCreacion(LocalDateTime.now());

            repo.save(u);

            repo.findAll().forEach(user -> 
                System.out.println("Usuario guardado: " + user.getUsername())
            );
        };
    }
}
