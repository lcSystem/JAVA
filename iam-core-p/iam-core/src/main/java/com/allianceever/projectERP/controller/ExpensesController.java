package com.allianceever.projectERP.controller;

import com.allianceever.projectERP.model.dto.ExpensesDto;
import com.allianceever.projectERP.service.ExpensesService;
import lombok.AllArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static com.allianceever.projectERP.controller.EmployeeController.getNullPropertyNames;
import static org.springframework.http.HttpStatus.CREATED;

@RestController
@RequestMapping("/api/expenses")
@AllArgsConstructor
public class ExpensesController {

    private ExpensesService expensesService;

    @GetMapping("/all")
    public ResponseEntity<List<ExpensesDto>> getAllExpenses() {
        return ResponseEntity.ok(expensesService.getAllExpensesOrderedByDate());
    }

    @PostMapping("/create")
    public ResponseEntity<ExpensesDto> create(@ModelAttribute ExpensesDto expensesDto) {
        ExpensesDto createdExpense = expensesService.create(expensesDto);
        return new ResponseEntity<>(createdExpense, CREATED);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ExpensesDto> getExpenseById(@PathVariable("id") Long id) {
        ExpensesDto expense = expensesService.getById(id);
        if (expense != null) {
            return ResponseEntity.ok(expense);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping("/updateExpenses")
    @SuppressWarnings("null")
    public ResponseEntity<ExpensesDto> updateExpenses(@ModelAttribute ExpensesDto expensesDto) {
        Long expenseId = expensesDto.getId();
        if (expenseId == null) {
            return ResponseEntity.badRequest().build();
        }
        ExpensesDto existingExpense = expensesService.getById(expenseId);
        if (existingExpense == null) {
            return ResponseEntity.notFound().build();
        }

        BeanUtils.copyProperties(expensesDto, existingExpense, getNullPropertyNames(expensesDto));

        ExpensesDto updatedExpense = expensesService.update(expenseId, existingExpense);
        return ResponseEntity.ok(updatedExpense);
    }

    @PostMapping("/delete/{id}")
    public ResponseEntity<String> deleteExpense(@PathVariable("id") Long id) {
        ExpensesDto expense = expensesService.getById(id);
        if (expense != null) {
            expensesService.delete(id);
            return ResponseEntity.ok("Expenses deleted successfully!");
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}
