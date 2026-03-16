package com.clientauth.repository;

import com.clientauth.entity.CustomerAuthEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CustomerAuthRepository extends JpaRepository<CustomerAuthEntity, Long> {

    Optional<CustomerAuthEntity> findByDocumentNumber(String documentNumber);

    boolean existsByDocumentNumber(String documentNumber);

    @Query("SELECT DISTINCT c FROM CustomerAuthEntity c "
            + "LEFT JOIN FETCH c.addresses "
            + "LEFT JOIN FETCH c.contacts "
            + "WHERE c.id = :id")
    Optional<CustomerAuthEntity> findByIdWithDetails(@Param("id") Long id);
}
