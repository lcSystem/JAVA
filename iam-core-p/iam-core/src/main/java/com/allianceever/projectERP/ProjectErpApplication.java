package com.allianceever.projectERP;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.HashSet;
import java.util.Set;

import com.allianceever.projectERP.AuthenticatedBackend.models.ApplicationUser;
import com.allianceever.projectERP.AuthenticatedBackend.models.Role;
import com.allianceever.projectERP.AuthenticatedBackend.repository.RoleRepository;
import com.allianceever.projectERP.AuthenticatedBackend.repository.UserRepository;

@SpringBootApplication
public class ProjectErpApplication {
	public static void main(String[] args) {
		SpringApplication.run(ProjectErpApplication.class, args);
	}

	@Bean
	static CommandLineRunner run(RoleRepository roleRepository, UserRepository userRepository,
			PasswordEncoder passwordEncode) {
		return args -> {
			if (roleRepository.findByAuthority("ADMIN").isEmpty()) {
				roleRepository.save(new Role("ADMIN"));
			}
			if (roleRepository.findByAuthority("Employee").isEmpty()) {
				roleRepository.save(new Role("Employee"));
			}
			if (roleRepository.findByAuthority("Marketing").isEmpty()) {
				roleRepository.save(new Role("Marketing"));
			}
			if (roleRepository.findByAuthority("IT").isEmpty()) {
				roleRepository.save(new Role("IT"));
			}
			if (roleRepository.findByAuthority("Human_Capital").isEmpty()) {
				roleRepository.save(new Role("Human_Capital"));
			}
			if (roleRepository.findByAuthority("Business_Development").isEmpty()) {
				roleRepository.save(new Role("Business_Development"));
			}

			Role adminRole = roleRepository.findByAuthority("ADMIN").get();
			Set<Role> roles = new HashSet<>();
			roles.add(adminRole);

			if (userRepository.findByUsername("lcardenas").isEmpty()) {
				userRepository.save(new ApplicationUser(2, "lcardenas", passwordEncode.encode("67551623"), roles));
			}
		};
	}
}
