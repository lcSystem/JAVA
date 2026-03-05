package com.reportes.infrastructure.adapters;

import com.reportes.domain.model.dynamic.ReportTemplate;
import com.reportes.domain.model.dynamic.ReportColumn;
import com.reportes.domain.ports.out.DynamicExcelGeneratorPort;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Component;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
@Slf4j
public class ApachePoiExcelGeneratorAdapter implements DynamicExcelGeneratorPort {

    @Override
    public byte[] generateExcel(ReportTemplate template, List<Map<String, Object>> dataList,
            Map<String, Object> parameters) {
        try (Workbook workbook = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {

            Sheet sheet = workbook.createSheet(template.getName().replaceAll("[^a-zA-Z0-9.\\-]", "_"));

            // Filter visible columns and sort by orderIndex
            List<ReportColumn> visibleColumns = template.getColumns().stream()
                    .filter(ReportColumn::isVisible)
                    .sorted((c1, c2) -> Integer.compare(c1.getOrderIndex(), c2.getOrderIndex()))
                    .collect(Collectors.toList());

            // Create Header Row
            Row headerRow = sheet.createRow(0);

            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);

            for (int i = 0; i < visibleColumns.size(); i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(visibleColumns.get(i).getTitle());
                cell.setCellStyle(headerStyle);
                // Set width approx (width multiplier)
                sheet.setColumnWidth(i, visibleColumns.get(i).getWidth() * 256);
            }

            // Populate Data Rows
            int rowIdx = 1;
            for (Map<String, Object> dataItem : dataList) {
                Row row = sheet.createRow(rowIdx++);
                for (int colIdx = 0; colIdx < visibleColumns.size(); colIdx++) {
                    ReportColumn col = visibleColumns.get(colIdx);
                    Cell cell = row.createCell(colIdx);

                    Object value = dataItem.get(col.getDataKey());
                    if (value != null) {
                        if (value instanceof Number) {
                            cell.setCellValue(((Number) value).doubleValue());
                        } else if (value instanceof Boolean) {
                            cell.setCellValue((Boolean) value);
                        } else {
                            cell.setCellValue(value.toString());
                        }
                    }
                }
            }

            workbook.write(out);
            return out.toByteArray();

        } catch (IOException e) {
            log.error("Excel generation failed", e);
            throw new RuntimeException("Error writing Excel file", e);
        }
    }
}
