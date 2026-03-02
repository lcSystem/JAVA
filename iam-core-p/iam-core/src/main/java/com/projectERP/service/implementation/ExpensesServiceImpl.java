package com.projectERP.service.implementation;

import com.projectERP.exception.ResourceNotFoundException;
import com.projectERP.model.dto.ExpensesDto;
import com.projectERP.model.entity.Expenses;
import com.projectERP.repository.ExpensesRepo;
import com.projectERP.service.ExpensesService;
import lombok.AllArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class ExpensesServiceImpl implements ExpensesService {

    private ExpensesRepo expensesRepo;
    private ModelMapper mapper;

    @Override
    public ExpensesDto getById(Long id) {
        Expenses expense = expensesRepo.findById(id).orElseThrow(
                () -> new ResourceNotFoundException("Expense does not exist with the given ID: " + id));
        return mapper.map(expense, ExpensesDto.class);
    }

    @Override
    public ExpensesDto create(ExpensesDto expensesDto) {
        Expenses expenses = mapper.map(expensesDto, Expenses.class);
        Expenses createdExpense = expensesRepo.save(expenses);
        return mapper.map(createdExpense, ExpensesDto.class);
    }

    @Override
    public ExpensesDto update(Long id, ExpensesDto expensesDto) {
        expensesRepo.findById(id).orElseThrow(
                () -> new ResourceNotFoundException("Expense does not exist with the given ID: " + id));
        // convert DTO to entity
        Expenses expenses = mapper.map(expensesDto, Expenses.class);
        Expenses updatedExpense = expensesRepo.save(expenses);

        // convert entity to DTO
        return mapper.map(updatedExpense, ExpensesDto.class);
    }

    @Override
    public List<ExpensesDto> getAllExpensesOrderedByDate() {
        List<Expenses> expenses = expensesRepo.findAllOrderByDate();

        return expenses.stream()
                .map(expense -> mapper.map(expense, ExpensesDto.class))
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (!expensesRepo.existsById(id)) {
            throw new ResourceNotFoundException("Expense does not exist with the given ID: " + id);
        }
        expensesRepo.deleteById(id);
    }
}
