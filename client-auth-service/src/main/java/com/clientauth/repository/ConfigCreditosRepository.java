package com.clientauth.repository;

import com.clientauth.entity.ConfigCreditosEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ConfigCreditosRepository extends JpaRepository<ConfigCreditosEntity, Long> {

    Optional<ConfigCreditosEntity> findByConfigKey(String configKey);
}
