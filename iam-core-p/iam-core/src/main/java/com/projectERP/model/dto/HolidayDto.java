package com.projectERP.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class HolidayDto {

    private Long HolidayId;
    private String holidayName;
    private LocalDate holidayDate;
    private LocalDate holidayDateEnd;

}
