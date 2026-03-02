package com.projectERP.service;


import com.projectERP.model.dto.HolidayDto;
import com.projectERP.model.dto.ItemDto;
import org.springframework.stereotype.Service;

@Service
public interface ItemService {

    ItemDto create(ItemDto itemDto);

}
