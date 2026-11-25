package com.utecoffe.service;

import com.utecoffe.entity.Order;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

public interface ExcelExportService {
    void exportOrdersToExcel(List<Order> orders, OutputStream outputStream) throws IOException;
}
