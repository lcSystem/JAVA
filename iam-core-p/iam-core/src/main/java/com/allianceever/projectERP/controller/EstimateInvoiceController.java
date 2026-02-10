package com.allianceever.projectERP.controller;

import com.allianceever.projectERP.AuthenticatedBackend.utils.RSAKeyProperties;
import com.allianceever.projectERP.model.dto.EstimatesInvoicesDto;
import com.allianceever.projectERP.model.dto.ItemDto;
import com.allianceever.projectERP.service.EstimatesInvoicesService;
import com.allianceever.projectERP.service.ItemService;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import lombok.AllArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import static com.allianceever.projectERP.controller.EmployeeController.getStrings;

@RestController
@RequestMapping("/createEstimateInvoice")
@ComponentScan(basePackages = "com.allianceever.projectERP")
@AllArgsConstructor
public class EstimateInvoiceController {

    private EstimatesInvoicesService estimatesInvoicesService;
    private ItemService itemService;
    private final RSAKeyProperties rsaKeyProperties;

    @PostMapping("/create")
    public ModelAndView createEstimatesInvoices(@RequestBody EstimatesInvoicesDto estimatesInvoicesDto) {
        estimatesInvoicesService.create(estimatesInvoicesDto);

        for (ItemDto itemDto : estimatesInvoicesDto.getItems()) {
            itemService.create(itemDto);
        }

        return new ModelAndView("redirect:/estimates.html");
    }

    @GetMapping("/view/{id}")
    public ModelAndView viewEstimatesInvoices(@PathVariable("id") Long id, RedirectAttributes redirectAttributes,
            @CookieValue(value = "jwtToken", defaultValue = "") String jwtToken) {
        String role = "";
        try {
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(rsaKeyProperties.getPublicKey())
                    .build()
                    .parseClaimsJws(jwtToken)
                    .getBody();

            role = (String) claims.get("roles");

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (role.equals("ADMIN") || role.equals("Marketing") || role.equals("Business_Development")) {
            EstimatesInvoicesDto estimatesInvoicesDto = estimatesInvoicesService.getById(id);

            String type = estimatesInvoicesDto.getType();
            if ("estimate".equals(type)) {
                redirectAttributes.addFlashAttribute("estimate", estimatesInvoicesDto);
                return new ModelAndView("redirect:/estimate-view.html");
            } else {
                redirectAttributes.addFlashAttribute("estimate", estimatesInvoicesDto);
                return new ModelAndView("redirect:/invoice-view.html");
            }
        } else {
            return new ModelAndView("redirect:/error-404.html");
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteEstimatesInvoices(@PathVariable("id") Long id) {
        EstimatesInvoicesDto estimatesInvoicesDto = estimatesInvoicesService.getById(id);

        if (estimatesInvoicesDto != null) {
            estimatesInvoicesService.delete(id);
            return ResponseEntity.ok("Estimate/invoice deleted successfully!");
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/edit/{id}")
    public ModelAndView editEstimate(@PathVariable("id") Long id, RedirectAttributes redirectAttributes,
            @CookieValue(value = "jwtToken", defaultValue = "") String jwtToken) {
        String role = "";
        try {
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(rsaKeyProperties.getPublicKey())
                    .build()
                    .parseClaimsJws(jwtToken)
                    .getBody();

            role = (String) claims.get("roles");

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (role.equals("ADMIN") || role.equals("Marketing") || role.equals("Business_Development")) {
            EstimatesInvoicesDto estimatesInvoicesDto = estimatesInvoicesService.getById(id);
            String type = estimatesInvoicesDto.getType();

            if ("estimate".equals(type)) {
                redirectAttributes.addFlashAttribute("estimate", estimatesInvoicesDto);
                return new ModelAndView("redirect:/edit-estimate.html");
            } else {
                redirectAttributes.addFlashAttribute("estimate", estimatesInvoicesDto);
                return new ModelAndView("redirect:/edit-invoice.html");
            }
        } else {
            return new ModelAndView("redirect:/error-404.html");
        }
    }

    @PutMapping("/updateEstimatesInvoices")
    @SuppressWarnings("null")
    public ResponseEntity<EstimatesInvoicesDto> updateEstimatesInvoices(
            @RequestBody EstimatesInvoicesDto estimatesInvoicesDto) {
        Long id = estimatesInvoicesDto.getId();
        EstimatesInvoicesDto existingEstimatesInvoices = estimatesInvoicesService.getById(id);
        if (existingEstimatesInvoices == null) {
            return ResponseEntity.notFound().build();
        }

        BeanUtils.copyProperties(estimatesInvoicesDto, existingEstimatesInvoices,
                getNullPropertyNames(estimatesInvoicesDto));

        EstimatesInvoicesDto updatedEstimatesInvoices = estimatesInvoicesService.update(id, existingEstimatesInvoices);
        return ResponseEntity.ok(updatedEstimatesInvoices);
    }

    @SuppressWarnings("null")
    public static String[] getNullPropertyNames(Object source) {
        return getStrings(source);
    }
}