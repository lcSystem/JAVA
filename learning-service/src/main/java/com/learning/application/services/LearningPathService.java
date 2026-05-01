package com.learning.application.services;

import com.learning.domain.model.*;
import com.learning.infrastructure.persistence.entity.*;
import com.learning.infrastructure.persistence.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class LearningPathService {

    private final SubjectRepository subjectRepository;
    private final UnitRepository unitRepository;

    public List<Subject> getAllSubjects() {
        return subjectRepository.findAll().stream()
                .map(entity -> Subject.builder()
                        .id(entity.getId())
                        .name(entity.getName())
                        .description(entity.getDescription())
                        .build())
                .collect(Collectors.toList());
    }

    public List<Unit> getUnitsForSubject(String subjectId) {
        return unitRepository.findBySubjectIdOrderByOrderIndex(subjectId).stream()
                .map(entity -> Unit.builder()
                        .id(entity.getId())
                        .subjectId(subjectId)
                        .name(entity.getName())
                        .orderIndex(entity.getOrderIndex())
                        .build())
                .collect(Collectors.toList());
    }
}
