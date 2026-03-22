package com.appointment.infrastructure.adapters.out.persistence.repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.appointment.infrastructure.adapters.out.persistence.entity.AppointmentEntity;

@Repository
public interface SpringDataAppointmentRepository extends JpaRepository<AppointmentEntity, UUID> {

        List<AppointmentEntity> findByEmployeeIdAndStartTimeGreaterThanEqualAndEndTimeLessThanEqual(UUID employeeId,
                        LocalDateTime start, LocalDateTime end);

        List<AppointmentEntity> findByCustomerId(String customerId);

        @Query("SELECT CASE WHEN COUNT(a) > 0 THEN true ELSE false END FROM AppointmentEntity a " +
                        "WHERE a.employeeId = :employeeId " +
                        "AND a.status != 'CANCELLED' " +
                        "AND (" +
                        "(:start >= a.startTime AND :start < a.endTime) OR " +
                        "(:end > a.startTime AND :end <= a.endTime) OR " +
                        "(a.startTime >= :start AND a.endTime <= :end)" +
                        ")")
        boolean existsOverlappingAppointment(@Param("employeeId") UUID employeeId, @Param("start") LocalDateTime start,
                        @Param("end") LocalDateTime end);

        @Query("SELECT CASE WHEN COUNT(a) > 0 THEN true ELSE false END FROM AppointmentEntity a " +
                        "WHERE a.employeeId = :employeeId " +
                        "AND a.id != :excludeId " +
                        "AND a.status != 'CANCELLED' " +
                        "AND (" +
                        "(:start >= a.startTime AND :start < a.endTime) OR " +
                        "(:end > a.startTime AND :end <= a.endTime) OR " +
                        "(a.startTime >= :start AND a.endTime <= :end)" +
                        ")")
        boolean existsOverlappingAppointmentExcluding(@Param("employeeId") UUID employeeId,
                        @Param("start") LocalDateTime start,
                        @Param("end") LocalDateTime end,
                        @Param("excludeId") UUID excludeId);
}
