package com.projectERP.AuthenticatedBackend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.projectERP.AuthenticatedBackend.repository.UserRepository;

@Service
public class UserService implements UserDetailsService {

    @Autowired
    private PasswordEncoder encoder;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private com.projectERP.AuthenticatedBackend.repository.RoleMenuPermissionRepository roleMenuPermissionRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        System.out.println("In the user details service");

        com.projectERP.AuthenticatedBackend.models.ApplicationUser user = userRepository
                .findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("user is not valid"));

        // Load permissions and add as authorities
        java.util.Set<Integer> roleIds = user.getAuthorities().stream()
                .map(auth -> ((com.projectERP.AuthenticatedBackend.models.Role) auth).getRoleId())
                .collect(java.util.stream.Collectors.toSet());

        if (!roleIds.isEmpty()) {
            java.util.Set<org.springframework.security.core.GrantedAuthority> permissions = roleMenuPermissionRepository
                    .findByRoleIds(roleIds).stream()
                    .flatMap(rmp -> {
                        java.util.List<org.springframework.security.core.GrantedAuthority> list = new java.util.ArrayList<>();
                        if (Boolean.TRUE.equals(rmp.getCanRead()))
                            list.add(new org.springframework.security.core.authority.SimpleGrantedAuthority(
                                    rmp.getMenu().getCodigo() + "_READ"));
                        if (Boolean.TRUE.equals(rmp.getCanCreate()))
                            list.add(new org.springframework.security.core.authority.SimpleGrantedAuthority(
                                    rmp.getMenu().getCodigo() + "_CREATE"));
                        if (Boolean.TRUE.equals(rmp.getCanUpdate()))
                            list.add(new org.springframework.security.core.authority.SimpleGrantedAuthority(
                                    rmp.getMenu().getCodigo() + "_UPDATE"));
                        if (Boolean.TRUE.equals(rmp.getCanDelete()))
                            list.add(new org.springframework.security.core.authority.SimpleGrantedAuthority(
                                    rmp.getMenu().getCodigo() + "_DELETE"));
                        return list.stream();
                    })
                    .collect(java.util.stream.Collectors.toSet());

            user.setPermissions(permissions);
        }

        return user;
    }

}
