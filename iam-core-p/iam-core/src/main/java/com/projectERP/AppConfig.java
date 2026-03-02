package com.projectERP;

import com.projectERP.repository.HolidayRepo;
import com.projectERP.service.HolidayService;
import com.projectERP.service.implementation.HolidayServiceImpl;
import org.modelmapper.ModelMapper;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfig {
    @Bean
    public HolidayService holidayService(HolidayRepo h, ModelMapper m) {
        return new HolidayServiceImpl(h, m);
    }

    @Bean
    public ModelMapper modelMapper() {
        return new ModelMapper();

    }
}