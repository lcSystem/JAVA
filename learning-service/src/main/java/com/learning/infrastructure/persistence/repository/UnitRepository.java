package com.learning.infrastructure.persistence.repository;

import com.learning.infrastructure.persistence.entity.UnitEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface UnitRepository extends JpaRepository<UnitEntity, String> {
    List<UnitEntity> findBySubjectIdOrderByOrderIndex(String subjectId);
}
