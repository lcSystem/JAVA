package com.projectERP.service.implementation;

import com.projectERP.model.dto.HolidayDto;
import com.projectERP.model.dto.ItemDto;
import com.projectERP.model.entity.Holiday;
import com.projectERP.model.entity.Item;
import com.projectERP.repository.HolidayRepo;
import com.projectERP.repository.ItemRepo;
import com.projectERP.service.ItemService;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ItemServiceImpl implements ItemService {

    private ItemRepo itemRepo;
    private ModelMapper mapper;

    @Autowired
    public ItemServiceImpl(ItemRepo itemRepo, ModelMapper mapper) {
        this.itemRepo = itemRepo;
        this.mapper = mapper;
    }

    @Override
    public ItemDto create(ItemDto itemDto) {
        // convert DTO to entity
        Item item = mapper.map(itemDto, Item.class);
        Item newItem = itemRepo.save(item);

        // convert entity to DTO
        return mapper.map(newItem, ItemDto.class);
    }

}
