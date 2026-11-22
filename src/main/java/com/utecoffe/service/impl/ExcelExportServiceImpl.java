package com.utecoffe.service.impl;

import com.utecoffe.entity.Order;
import com.utecoffe.service.ExcelExportService;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.OutputStream;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class ExcelExportServiceImpl implements ExcelExportService {

    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    @Override
    public void exportOrdersToExcel(List<Order> orders, OutputStream outputStream) throws IOException {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Danh Sach Don Hang");

            // Header Style
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setColor(IndexedColors.WHITE.getIndex());
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);

            // Currency / Numeric Style
            CellStyle numberStyle = workbook.createCellStyle();
            DataFormat dataFormat = workbook.createDataFormat();
            numberStyle.setDataFormat(dataFormat.getFormat("#,##0 ₫"));

            // Header Row
            Row headerRow = sheet.createRow(0);
            String[] columns = {"STT", "Ma Don Hang", "Khach Hang", "So Dien Thoai", "Hinh Thuc", "Chi Nhanh", "Trang Thai", "Tong Tien", "Ngay Tao"};
            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(columns[i]);
                cell.setCellStyle(headerStyle);
            }

            // Data Rows
            int rowIdx = 1;
            for (Order order : orders) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(rowIdx - 1);
                row.createCell(1).setCellValue(order.getOrderCode() != null ? order.getOrderCode() : "N/A");
                row.createCell(2).setCellValue(order.getRecipientName() != null ? order.getRecipientName() : (order.getUser() != null ? order.getUser().getFullName() : "Khach vang lai"));
                row.createCell(3).setCellValue(order.getRecipientPhone() != null ? order.getRecipientPhone() : "N/A");
                row.createCell(4).setCellValue(order.getOrderType() != null ? order.getOrderType().name() : "N/A");
                row.createCell(5).setCellValue(order.getStore() != null ? order.getStore().getName() : "N/A");
                row.createCell(6).setCellValue(order.getStatus() != null ? order.getStatus().name() : "N/A");

                Cell amountCell = row.createCell(7);
                amountCell.setCellValue(order.getFinalAmount() != null ? order.getFinalAmount().doubleValue() : 0.0);
                amountCell.setCellStyle(numberStyle);

                row.createCell(8).setCellValue(order.getCreatedAt() != null ? order.getCreatedAt().format(DATE_FMT) : "");
            }

            // Auto-size columns
            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(outputStream);
        }
    }
}
