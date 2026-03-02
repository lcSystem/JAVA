package com.projectERP.service.implementation;

import com.projectERP.exception.ResourceNotFoundException;
import com.projectERP.model.dto.EstimatesInvoicesDto;
import com.projectERP.model.entity.EstimatesInvoices;
import com.projectERP.model.entity.Item;
import com.projectERP.repository.EstimatesInvoicesRepo;
import com.projectERP.service.EstimatesInvoicesService;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@SuppressWarnings("null")
public class EstimatesInvoicesServiceImpl implements EstimatesInvoicesService {

    private ModelMapper mapper;

    private EstimatesInvoicesRepo estimatesInvoicesRepo;

    @Autowired
    public EstimatesInvoicesServiceImpl(ModelMapper mapper, EstimatesInvoicesRepo estimatesInvoicesRepo) {
        this.mapper = mapper;
        this.estimatesInvoicesRepo = estimatesInvoicesRepo;
    }

    @Override
    public EstimatesInvoicesDto create(EstimatesInvoicesDto estimatesInvoicesDto) {
        // convert DTO to entity
        EstimatesInvoices estimatesInvoices = mapper.map(estimatesInvoicesDto, EstimatesInvoices.class);

        EstimatesInvoices newEstimatesInvoices = estimatesInvoicesRepo.save(estimatesInvoices);

        // convert entity to DTO
        return mapper.map(newEstimatesInvoices, EstimatesInvoicesDto.class);

    }

    @Override
    public EstimatesInvoicesDto getById(Long id) {
        EstimatesInvoices estimatesInvoices = estimatesInvoicesRepo.findById(id).orElseThrow(
                () -> new ResourceNotFoundException("Estimates / Invoices does not exist with the given id: " + id));
        return mapper.map(estimatesInvoices, EstimatesInvoicesDto.class);
    }

    @Override
    public EstimatesInvoicesDto update(Long id, EstimatesInvoicesDto estimatesInvoicesDto) {
        EstimatesInvoices existingEstimatesInvoices = estimatesInvoicesRepo.findById(id).orElseThrow(
                () -> new ResourceNotFoundException("Estimates / Invoices does not exist with the given id: " + id));

        // Update basic fields
        existingEstimatesInvoices.setEstimateDate(estimatesInvoicesDto.getEstimateDate());
        existingEstimatesInvoices.setCreateDate(estimatesInvoicesDto.getCreateDate());
        existingEstimatesInvoices.setExpiryDate(estimatesInvoicesDto.getExpiryDate());
        existingEstimatesInvoices.setOtherInfo(estimatesInvoicesDto.getOtherInfo());
        existingEstimatesInvoices.setStatus(estimatesInvoicesDto.getStatus());
        existingEstimatesInvoices.setTotal(estimatesInvoicesDto.getTotal());
        existingEstimatesInvoices.setTax(estimatesInvoicesDto.getTax());

        // Handle associations if provided
        if (estimatesInvoicesDto.getClient() != null) {
            existingEstimatesInvoices.setClient(mapper.map(estimatesInvoicesDto.getClient(),
                    com.projectERP.model.entity.Client.class));
        }
        if (estimatesInvoicesDto.getProject() != null) {
            existingEstimatesInvoices.setProject(mapper.map(estimatesInvoicesDto.getProject(),
                    com.projectERP.model.entity.Project.class));
        }

        // Handle items
        if (estimatesInvoicesDto.getItems() != null) {
            List<Item> itemList = estimatesInvoicesDto.getItems().stream()
                    .map(itemDto -> {
                        Item item = mapper.map(itemDto, Item.class);
                        item.setEstimateInvoices(existingEstimatesInvoices);
                        return item;
                    })
                    .collect(Collectors.toList());
            existingEstimatesInvoices.setItems(itemList);
        }

        EstimatesInvoices updatedEstimatesInvoices = estimatesInvoicesRepo.save(existingEstimatesInvoices);
        return mapper.map(updatedEstimatesInvoices, EstimatesInvoicesDto.class);
    }

    @Override
    public List<EstimatesInvoicesDto> getAllEstimates() {

        List<EstimatesInvoices> estimatesInvoices = estimatesInvoicesRepo.findAll();

        return estimatesInvoices.stream()
                .filter(estimatesInvoice -> "estimate".equals(estimatesInvoice.getType()))
                .map(estimatesInvoice -> mapper.map(estimatesInvoice, EstimatesInvoicesDto.class))
                .collect(Collectors.toList());
    }

    @Override
    public List<EstimatesInvoicesDto> getAllInvoices() {

        List<EstimatesInvoices> estimatesInvoices = estimatesInvoicesRepo.findAll();

        return estimatesInvoices.stream()
                .filter(estimatesInvoice -> "invoice".equals(estimatesInvoice.getType()))
                .map(estimatesInvoice -> mapper.map(estimatesInvoice, EstimatesInvoicesDto.class))
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (!estimatesInvoicesRepo.existsById(id)) {
            throw new ResourceNotFoundException("invoice / estimate is not exist with given id: " + id);
        }
        estimatesInvoicesRepo.deleteById(id);
    }

}
