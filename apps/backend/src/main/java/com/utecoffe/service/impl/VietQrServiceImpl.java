package com.utecoffe.service.impl;

import com.utecoffe.entity.Order;
import com.utecoffe.service.VietQrService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Service
public class VietQrServiceImpl implements VietQrService {

    @Value("${vietqr.bank-id:ICB}")
    private String bankId; // VietinBank (970415 / ICB), VCB, MB, etc.

    @Value("${vietqr.account-no:108868686868}")
    private String accountNo;

    @Value("${vietqr.account-name:UTECOFFE SPECIALTY}")
    private String accountName;

    @Value("${vietqr.template:compact2}")
    private String template;

    @Override
    public String generateVietQrUrl(Order order) {
        String amountStr = order.getFinalAmount().toBigInteger().toString();
        String description = "THANH TOAN DON " + order.getOrderCode();
        String encodedDesc = URLEncoder.encode(description, StandardCharsets.UTF_8);
        String encodedAccountName = URLEncoder.encode(accountName, StandardCharsets.UTF_8);

        return String.format(
                "https://img.vietqr.io/image/%s-%s-%s.png?amount=%s&addInfo=%s&accountName=%s",
                bankId,
                accountNo,
                template,
                amountStr,
                encodedDesc,
                encodedAccountName
        );
    }
}
