package com.allianceever.projectERP.AuthenticatedBackend.services;

import java.util.HashSet;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.allianceever.projectERP.AuthenticatedBackend.models.ApplicationUser;
import com.allianceever.projectERP.AuthenticatedBackend.models.LoginResponseDTO;
import com.allianceever.projectERP.AuthenticatedBackend.models.Role;
import com.allianceever.projectERP.AuthenticatedBackend.repository.RoleRepository;
import com.allianceever.projectERP.AuthenticatedBackend.repository.UserRepository;
import com.allianceever.projectERP.AuthenticatedBackend.models.UserProfileDTO;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
@Transactional
public class AuthenticationService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private TokenService tokenService;

    public ApplicationUser registerUser(String username, String password, String role) {

        String encodedPassword = passwordEncoder.encode(password);
        Role userRole = roleRepository.findByAuthority(role).get();

        Set<Role> authorities = new HashSet<>();

        authorities.add(userRole);

        return userRepository.save(new ApplicationUser(0, username, encodedPassword, authorities));
    }

    public LoginResponseDTO loginUser(String username, String password) {

        try {
            Authentication auth = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(username, password));

            String token = tokenService.generateJwt(auth);

            return new LoginResponseDTO(userRepository.findByUsername(username).get(), token);

        } catch (AuthenticationException e) {
            return new LoginResponseDTO(null, "");
        }
    }

    public ApplicationUser updateUser(String username, String password, String role) {

        ApplicationUser applicationUser = userRepository.findByUsername(username).get();

        if (!password.equals("")) {
            String encodedPassword = passwordEncoder.encode(password);
            applicationUser.setPassword(encodedPassword);
        }

        Role userRole = roleRepository.findByAuthority(role).get();
        Set<Role> authorities = new HashSet<>();
        authorities.add(userRole);

        applicationUser.setAuthorities(authorities);
        return userRepository.save(applicationUser);
    }

    public void delete(String username) {
        ApplicationUser applicationUser = userRepository.findByUsername(username).get();
        Integer userId = applicationUser.getUserId();
        userRepository.deleteById(userId);
    }

    public UserProfileDTO getUserProfile(String username) {
        ApplicationUser user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return new UserProfileDTO(user);
    }

    public ApplicationUser updateUserProfile(String username, UserProfileDTO profileDTO) {
        ApplicationUser user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (profileDTO.getFirstName() != null)
            user.setFirstName(profileDTO.getFirstName());
        if (profileDTO.getLastName() != null)
            user.setLastName(profileDTO.getLastName());
        if (profileDTO.getEmail() != null)
            user.setEmail(profileDTO.getEmail());
        if (profileDTO.getPhone() != null)
            user.setPhone(profileDTO.getPhone());
        if (profileDTO.getBio() != null)
            user.setBio(profileDTO.getBio());
        if (profileDTO.getFacebook() != null)
            user.setFacebook(profileDTO.getFacebook());
        if (profileDTO.getTwitter() != null)
            user.setTwitter(profileDTO.getTwitter());
        if (profileDTO.getLinkedin() != null)
            user.setLinkedin(profileDTO.getLinkedin());
        if (profileDTO.getInstagram() != null)
            user.setInstagram(profileDTO.getInstagram());
        if (profileDTO.getCountry() != null)
            user.setCountry(profileDTO.getCountry());
        if (profileDTO.getCity() != null)
            user.setCity(profileDTO.getCity());
        if (profileDTO.getPostalCode() != null)
            user.setPostalCode(profileDTO.getPostalCode());
        if (profileDTO.getTaxId() != null)
            user.setTaxId(profileDTO.getTaxId());

        return userRepository.save(user);
    }

    public String uploadProfileImage(String username, MultipartFile file) throws IOException {
        ApplicationUser user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        String uploadDir = "uploads/images/profiles/";
        Path uploadPath = Paths.get(uploadDir);

        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        String originalFilename = file.getOriginalFilename();
        String extension = originalFilename != null && originalFilename.contains(".")
                ? originalFilename.substring(originalFilename.lastIndexOf("."))
                : ".jpg";

        String filename = UUID.randomUUID().toString() + extension;
        Path filePath = uploadPath.resolve(filename);

        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        String fileUrl = "/uploads/images/profiles/" + filename;
        user.setProfilePicture(fileUrl);
        userRepository.save(user);

        return fileUrl;
    }

}
