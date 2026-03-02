package com.projectERP.controller;

import com.projectERP.model.dto.HolidayDto;
import com.projectERP.service.HolidayService;
import lombok.AllArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static org.springframework.http.HttpStatus.CREATED;

@RestController
@RequestMapping("/api/holiday")
@AllArgsConstructor
public class HolidayController {

    private HolidayService holidayService;

    @GetMapping("/all")
    public ResponseEntity<List<HolidayDto>> getAllHolidays() {
        List<HolidayDto> holidays = holidayService.getAllHolidaysOrderedByDate();
        return ResponseEntity.ok(holidays);
    }

    @PostMapping("/create")
    public ResponseEntity<HolidayDto> createHoliday(@ModelAttribute HolidayDto holidayDto) {
        HolidayDto createdHoliday = holidayService.create(holidayDto);
        return new ResponseEntity<>(createdHoliday, CREATED);
    }

    @GetMapping("/{id}")
    public ResponseEntity<HolidayDto> getHolidayById(@PathVariable("id") Long id) {
        HolidayDto holidayDto = holidayService.getById(id);
        if (holidayDto != null) {
            return ResponseEntity.ok(holidayDto);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping("/updateHoliday")
    @SuppressWarnings("null")
    public ResponseEntity<HolidayDto> updateHoliday(@ModelAttribute HolidayDto holidayDto) {
        Long holidayId = holidayDto.getHolidayId();
        HolidayDto existingHoliday = holidayService.getById(holidayId);
        if (existingHoliday == null) {
            return ResponseEntity.notFound().build();
        }

        BeanUtils.copyProperties(holidayDto, existingHoliday, getNullPropertyNames(holidayDto));

        HolidayDto updatedHoliday = holidayService.update(holidayId, existingHoliday);
        return ResponseEntity.ok(updatedHoliday);
    }

    @PostMapping("/delete/{id}")
    public ResponseEntity<String> deleteHoliday(@PathVariable("id") Long id) {
        holidayService.delete(id);
        return ResponseEntity.ok("Holiday deleted successfully!");
    }

    @SuppressWarnings("null")
    public static String[] getNullPropertyNames(Object source) {
        final BeanWrapper src = new BeanWrapperImpl(source);
        java.beans.PropertyDescriptor[] pds = src.getPropertyDescriptors();

        Set<String> emptyNames = new HashSet<>();
        for (java.beans.PropertyDescriptor pd : pds) {
            Object srcValue = src.getPropertyValue(pd.getName());
            if (srcValue == null)
                emptyNames.add(pd.getName());
        }
        String[] result = new String[emptyNames.size()];
        return emptyNames.toArray(result);
    }
}
