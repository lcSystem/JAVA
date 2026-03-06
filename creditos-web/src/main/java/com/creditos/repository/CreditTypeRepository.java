package com.creditos.repository;

import com.creditos.model.CreditType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CreditTypeRepository extends JpaRepository<CreditType, Long> {
    @Query("SELECT c FROM CreditType c WHERE c.deletedAt IS NULL")
    List<CreditType> findAllActive();

    @Modifying
    @Query(value = "UPDATE credit_types SET deleted_at = NOW() WHERE id = :id", nativeQuery = true)
    void softDeleteById(@Param("id") Long id);
}
