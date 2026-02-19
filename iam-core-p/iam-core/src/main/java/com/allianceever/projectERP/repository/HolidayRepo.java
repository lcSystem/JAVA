package com.allianceever.projectERP.repository;

import com.allianceever.projectERP.model.entity.Holiday;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface HolidayRepo extends JpaRepository<Holiday, Long> {

    Holiday findByHolidayName(String HolidayName);

    @Query(value = "SELECT * FROM holiday ORDER BY holiday_date ASC", nativeQuery = true)
    List<Holiday> findAllOrderByDate();

}
