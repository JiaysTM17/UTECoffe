package com.utecoffe.controller.mvc;

import com.utecoffe.service.StoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class StoreMvcController {

    @Autowired
    private StoreService storeService;

    @GetMapping("/stores")
    public String stores(Model model) {
        model.addAttribute("stores", storeService.getAllActiveStores());
        return "customer/stores";
    }

    @GetMapping("/reservation")
    public String reservation(Model model) {
        model.addAttribute("stores", storeService.getAllActiveStores());
        return "customer/reservation";
    }
}
