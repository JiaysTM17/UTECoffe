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

    @Value("${vietqr.bank-bin:970415}")
    private String bankBin;

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

    /**
     * Generates standard EMVCo Merchant-Presented Mode (MPM) QR payload.
     * Includes Tag 00..62 and computes Tag 63 CRC-16 (CCITT-FALSE 0x1021).
     */
    @Override
    public String generateEmvCoPayload(Order order) {
        StringBuilder sb = new StringBuilder();

        // Tag 00: Payload Format Indicator (01)
        appendTlv(sb, "00", "01");

        // Tag 01: Point of Initiation Method (12 = Dynamic QR)
        appendTlv(sb, "01", "12");

        // Tag 38: Merchant Account Information (NAPAS247)
        StringBuilder napas = new StringBuilder();
        appendTlv(napas, "00", "A000000727"); // NAPAS AID
        StringBuilder bankInfo = new StringBuilder();
        appendTlv(bankInfo, "00", bankBin != null ? bankBin : "970415");
        appendTlv(bankInfo, "01", accountNo);
        appendTlv(napas, "01", bankInfo.toString());
        appendTlv(napas, "02", "QRIBFTTA"); // Service Code: Transfer to Account
        appendTlv(sb, "38", napas.toString());

        // Tag 53: Transaction Currency (704 = VND)
        appendTlv(sb, "53", "704");

        // Tag 54: Transaction Amount
        String amountStr = order.getFinalAmount().toBigInteger().toString();
        appendTlv(sb, "54", amountStr);

        // Tag 58: Country Code (VN)
        appendTlv(sb, "58", "VN");

        // Tag 59: Merchant Name
        appendTlv(sb, "59", accountName != null ? accountName : "UTECOFFE");

        // Tag 60: Merchant City
        appendTlv(sb, "60", "HO CHI MINH");

        // Tag 62: Additional Data Field (Purpose of transaction)
        StringBuilder addData = new StringBuilder();
        appendTlv(addData, "08", "THANH TOAN " + order.getOrderCode());
        appendTlv(sb, "62", addData.toString());

        // Tag 63: CRC-16 (Tag + Length + 4-char CRC)
        sb.append("6304");
        String crc = calculateCrc16(sb.toString());
        sb.append(crc);

        return sb.toString();
    }

    private void appendTlv(StringBuilder sb, String tag, String value) {
        if (value == null) return;
        sb.append(tag);
        sb.append(String.format("%02d", value.length()));
        sb.append(value);
    }

    /**
     * Calculates CRC-16/CCITT-FALSE checksum (polynomial 0x1021, initial value 0xFFFF).
     */
    public static String calculateCrc16(String str) {
        int crc = 0xFFFF;
        int polynomial = 0x1021;
        byte[] bytes = str.getBytes(StandardCharsets.US_ASCII);
        for (byte b : bytes) {
            for (int i = 0; i < 8; i++) {
                boolean bit = ((b >> (7 - i) & 1) == 1);
                boolean c15 = ((crc >> 15 & 1) == 1);
                crc <<= 1;
                if (c15 ^ bit) {
                    crc ^= polynomial;
                }
            }
        }
        crc &= 0xFFFF;
        return String.format("%04X", crc);
    }
}
