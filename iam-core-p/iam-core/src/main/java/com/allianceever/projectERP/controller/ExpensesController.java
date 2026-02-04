package com.allianceever.projectERP.controller;

import com.allianceever.projectERP.model.dto.ExpensesDto;

import com.allianceever.projectERP.model.entity.Expenses;
import com.allianceever.projectERP.service.ExpensesService;

import org.modelmapper.ModelMapper;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static org.springframework.http.HttpStatus.CREATED;

@RestController
@RequestMapping("/api/expenses")
public class ExpensesController {

    private ExpensesService expensesService;
    private ModelMapper mapper;

    @Autowired
    public ExpensesController(ExpensesService expensesService, ModelMapper mapper) {
        this.expensesService = expensesService;
        this.mapper = mapper;
    }

    @GetMapping("/all")
    public ResponseEntity<List<ExpensesDto>> getAllExpenses() {
        return ResponseEntity.ok(expensesService.getAllExpensesOrderedByDate());
    }

    @PostMapping("/create")
    public ResponseEntity<ExpensesDto> create(@ModelAttribute ExpensesDto expensesDto) {
        ExpensesDto createdExpense = expensesService.create(expensesDto);
        return ResponseEntity.ok(createdExpense);
    }

    // Build Delete Employee REST API
    @PostMapping("/delete/{id}")
    public ResponseEntity<String> deleteExpense(@PathVariable("id") Long employeeID) {
        ExpensesDto employeeDto = expensesService.getById(employeeID);
        if (employeeDto != null) {
            expensesService.delete(employeeID);
            return ResponseEntity.ok("Expenses deleted successfully!");
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/getExpense/{expenseId}")
    public Expenses getExpenseById(@PathVariable("expenseId") Long expenseId) {
        // Fetch the expense data by ID
        ExpensesDto expense = expensesService.getById(expenseId); // Replace with your service method

        return mapper.map(expense, Expenses.class);
    }

}
