package com.allianceever.projectERP.service;

import com.allianceever.projectERP.model.dto.HolidayDto;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface HolidayService {

    HolidayDto getByHolidayName(String holidayName);

    HolidayDto getById(Long id);

    HolidayDto create(HolidayDto holidayDto);

    HolidayDto update(Long id, HolidayDto holidayDto);

    List<HolidayDto> getAllHolidaysOrderedByDate();

    void delete(Long id);

}
