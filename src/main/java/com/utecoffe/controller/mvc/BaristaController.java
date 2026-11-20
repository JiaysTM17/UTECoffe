package com.utecoffe.controller.mvc;

import com.utecoffe.service.OrderService;
import com.utecoffe.service.StoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class BaristaController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private StoreService storeService;

    @GetMapping("/barista/kds")
    public String kdsScreen(@RequestParam(defaultValue = "1") Long storeId, Model model) {
        model.addAttribute("store", storeService.getStoreById(storeId));
        model.addAttribute("activeOrders", orderService.getKdsOrdersForStore(storeId));
        return "barista/kds";
    }
}
