package com.projectERP.repository;

import com.projectERP.model.entity.Leaves;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface LeavesRepo extends JpaRepository<Leaves, Long> {

    @Query(value = "SELECT * FROM leaves ORDER BY start_date ASC", nativeQuery = true)
    List<Leaves> findAllOrderByDate();

    @Query(value = "SELECT * FROM leaves WHERE username = :username ORDER BY start_date ASC", nativeQuery = true)
    List<Leaves> getAllLeavesByUsernameOrderedByDate(@Param("username") String username);
}
