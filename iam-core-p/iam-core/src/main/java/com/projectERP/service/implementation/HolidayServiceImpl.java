package com.projectERP.service.implementation;

import com.projectERP.exception.ResourceNotFoundException;
import com.projectERP.model.dto.HolidayDto;
import com.projectERP.model.entity.Holiday;
import com.projectERP.repository.HolidayRepo;
import com.projectERP.service.HolidayService;
import lombok.AllArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@AllArgsConstructor
@Service
@SuppressWarnings("null")
public class HolidayServiceImpl implements HolidayService {

    private HolidayRepo holidayRepo;
    private ModelMapper mapper;

    @Override
    public HolidayDto getByHolidayName(String holidayName) {
        Holiday holiday = holidayRepo.findByHolidayName(holidayName);
        if (holiday == null) {
            return null;
        }
        return mapper.map(holiday, HolidayDto.class);
    }

    @Override
    public HolidayDto getById(Long id) {
        Holiday holiday = holidayRepo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Holiday does not exist with the given id: " + id));
        return mapper.map(holiday, HolidayDto.class);
    }

    @Override
    public HolidayDto create(HolidayDto holidayDto) {
        // convert DTO to entity
        Holiday holiday = mapper.map(holidayDto, Holiday.class);
        Holiday newHoliday = holidayRepo.save(holiday);

        // convert entity to DTO
        return mapper.map(newHoliday, HolidayDto.class);
    }

    @Override
    public HolidayDto update(Long id, HolidayDto holidayDto) {
        // Find the existing holiday entity by id
        Holiday existingHoliday = holidayRepo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Holiday does not exist with the given id: " + id));

        // Update the fields of existingHoliday with the corresponding fields from
        // holidayDto
        existingHoliday.setHolidayName(holidayDto.getHolidayName());
        existingHoliday.setHolidayDate(holidayDto.getHolidayDate());
        existingHoliday.setHolidayDateEnd(holidayDto.getHolidayDateEnd());

        // Save the updated entity back to the database
        Holiday updatedHoliday = holidayRepo.save(existingHoliday);

        // Convert the updated entity to DTO and return it
        return mapper.map(updatedHoliday, HolidayDto.class);
    }

    @Override
    public List<HolidayDto> getAllHolidaysOrderedByDate() {
        List<Holiday> holidays = holidayRepo.findAllOrderByDate();

        return holidays.stream()
                .map(holiday -> mapper.map(holiday, HolidayDto.class))
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (!holidayRepo.existsById(id)) {
            throw new ResourceNotFoundException("Holiday does not exist with given id: " + id);
        }
        holidayRepo.deleteById(id);
    }

}
