package com.appointment.infrastructure.adapters.out.persistence;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.appointment.application.ports.out.AppointmentRepositoryPort;
import com.appointment.application.ports.out.AvailabilityRepositoryPort;
import com.appointment.domain.model.Appointment;
import com.appointment.domain.model.Availability;
import com.appointment.infrastructure.adapters.out.persistence.entity.AppointmentEntity;
import com.appointment.infrastructure.adapters.out.persistence.entity.AvailabilityEntity;
import com.appointment.infrastructure.adapters.out.persistence.mapper.AppointmentPersistenceMapper;
import com.appointment.infrastructure.adapters.out.persistence.mapper.AvailabilityPersistenceMapper;
import com.appointment.infrastructure.adapters.out.persistence.repository.SpringDataAppointmentRepository;
import com.appointment.infrastructure.adapters.out.persistence.repository.SpringDataAvailabilityRepository;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class DatabasePersistenceAdapter implements AppointmentRepositoryPort, AvailabilityRepositoryPort {

    private final SpringDataAppointmentRepository appointmentRepository;
    private final SpringDataAvailabilityRepository availabilityRepository;
    private final AppointmentPersistenceMapper appointmentMapper;
    private final AvailabilityPersistenceMapper availabilityMapper;

    @Override
    @Transactional
    public Appointment save(Appointment appointment) {
        AppointmentEntity entity = appointmentMapper.toEntity(appointment);
        AppointmentEntity saved = appointmentRepository.save(entity);
        return appointmentMapper.toDomain(saved);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Appointment> findById(UUID id) {
        return appointmentRepository.findById(id).map(appointmentMapper::toDomain);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Appointment> findByEmployeeIdAndDateRange(UUID employeeId, LocalDateTime start, LocalDateTime end) {
        return appointmentRepository
                .findByEmployeeIdAndStartTimeGreaterThanEqualAndEndTimeLessThanEqual(employeeId, start, end)
                .stream()
                .map(appointmentMapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<Appointment> findByCustomerId(String customerId) {
        return appointmentRepository.findByCustomerId(customerId)
                .stream()
                .map(appointmentMapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public boolean existsOverlapping(UUID employeeId, LocalDateTime start, LocalDateTime end) {
        return appointmentRepository.existsOverlappingAppointment(employeeId, start, end);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean existsOverlappingExcluding(UUID employeeId, LocalDateTime start, LocalDateTime end, UUID excludeId) {
        return appointmentRepository.existsOverlappingAppointmentExcluding(employeeId, start, end, excludeId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Availability> findByEmployeeId(UUID employeeId) {
        return availabilityRepository.findByEmployeeId(employeeId)
                .stream()
                .map(availabilityMapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public Availability save(Availability availability) {
        AvailabilityEntity entity = availabilityMapper.toEntity(availability);
        AvailabilityEntity saved = availabilityRepository.save(entity);
        return availabilityMapper.toDomain(saved);
    }
}
