package com.projectERP.AuthenticatedBackend.infrastructure.adapters;

import com.projectERP.AuthenticatedBackend.domain.model.User;
import com.projectERP.AuthenticatedBackend.domain.ports.out.UserRepositoryPort;
import com.projectERP.AuthenticatedBackend.infrastructure.mappers.UserMapper;
import com.projectERP.AuthenticatedBackend.repository.UserRepository;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class UserRepositoryAdapter implements UserRepositoryPort {

    private final UserRepository userRepository;

    public UserRepositoryAdapter(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public Optional<User> findById(Integer id) {
        return userRepository.findById(id).map(UserMapper::toDomain);
    }

    @Override
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username).map(UserMapper::toDomain);
    }

    @Override
    public User save(User user) {
        return UserMapper.toDomain(userRepository.save(UserMapper.toEntity(user)));
    }

    @Override
    public void deleteById(Integer id) {
        userRepository.deleteById(id);
    }

    @Override
    public boolean existsByUsername(String username) {
        return userRepository.findByUsername(username).isPresent();
    }
}
