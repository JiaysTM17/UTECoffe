package com.utecoffe.service.impl;

import com.utecoffe.entity.Order;
import com.utecoffe.entity.OrderItem;
import com.utecoffe.entity.TableReservation;
import com.utecoffe.repository.OrderItemRepository;
import com.utecoffe.service.EmailService;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmailServiceImpl implements EmailService {

    @Autowired(required = false)
    private JavaMailSender mailSender;

    @Autowired
    private OrderItemRepository orderItemRepository;

    @Value("${spring.mail.username:contact@utecoffe.vn}")
    private String fromEmail;

    @Override
    @Async
    public void sendOrderReceipt(Order order) {
        if (mailSender == null || order.getUser() == null || order.getUser().getEmail() == null) {
            return;
        }

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail, "UTECOFFE Specialty Roastery");
            helper.setTo(order.getUser().getEmail());
            helper.setSubject("[UTECOFFE] Xác nhận đơn hàng #" + order.getOrderCode());

            List<OrderItem> items = orderItemRepository.findByOrderId(order.getId());
            StringBuilder itemsHtml = new StringBuilder();
            for (OrderItem item : items) {
                itemsHtml.append("<tr>")
                        .append("<td style='padding: 8px; border-bottom: 1px solid #EEE;'>").append(item.getProduct().getName()).append("</td>")
                        .append("<td style='padding: 8px; border-bottom: 1px solid #EEE; text-align: center;'>").append(item.getQuantity()).append("</td>")
                        .append("<td style='padding: 8px; border-bottom: 1px solid #EEE; text-align: right;'>").append(item.getSubtotal().toBigInteger()).append(" đ</td>")
                        .append("</tr>");
            }

            String htmlContent = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #D4AF37; border-radius: 8px;'>"
                    + "<div style='text-align: center; margin-bottom: 20px;'>"
                    + "<h2 style='color: #1A1715; margin: 0;'>UTE<span style='color: #D4AF37;'>COFFE</span></h2>"
                    + "<p style='color: #7A7268; margin: 5px 0 0; font-size: 13px;'>SPECIALTY TEA & COFFEE ROASTERY</p>"
                    + "</div>"
                    + "<h3 style='color: #2E7D32;'>Cảm ơn bạn đã đặt hàng tại UTECoffe!</h3>"
                    + "<p>Xin chào <strong>" + order.getRecipientName() + "</strong>,</p>"
                    + "<p>Đơn hàng của bạn đã được tiếp nhận và chuyển đến quầy pha chế chi nhánh <strong>" + order.getStore().getName() + "</strong>.</p>"
                    + "<table style='width: 100%; border-collapse: collapse; margin: 20px 0;'>"
                    + "<tr style='background: #F8F5EE;'>"
                    + "<th style='padding: 8px; text-align: left;'>Món</th>"
                    + "<th style='padding: 8px; text-align: center;'>Số Lượng</th>"
                    + "<th style='padding: 8px; text-align: right;'>Thành Tiền</th>"
                    + "</tr>"
                    + itemsHtml
                    + "</table>"
                    + "<p style='text-align: right; font-size: 16px; margin-top: 15px;'>"
                    + "<strong>Tổng thanh toán: <span style='color: #D32F2F;'>" + order.getFinalAmount().toBigInteger() + " đ</span></strong>"
                    + "</p>"
                    + "<hr style='border: none; border-top: 1px solid #DDD; margin: 20px 0;'>"
                    + "<p style='font-size: 12px; color: #888; text-align: center;'>Hotline: 1900 2026 • 01 Võ Văn Ngân, TP. Thủ Đức, TP.HCM</p>"
                    + "</div>";

            helper.setText(htmlContent, true);
            mailSender.send(message);
        } catch (Exception ex) {
            // Log warning without failing order transaction
            System.err.println("Notice: Could not dispatch order receipt email: " + ex.getMessage());
        }
    }

    @Override
    @Async
    public void sendReservationConfirmation(TableReservation reservation) {
        if (mailSender == null || reservation.getUser() == null || reservation.getUser().getEmail() == null) {
            return;
        }

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail, "UTECOFFE Specialty Roastery");
            helper.setTo(reservation.getUser().getEmail());
            helper.setSubject("[UTECOFFE] Xác nhận yêu cầu đặt bàn tại " + reservation.getStore().getName());

            String htmlContent = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #D4AF37; border-radius: 8px;'>"
                    + "<h2 style='color: #1A1715;'>UTE<span style='color: #D4AF37;'>COFFE</span> Đặt Bàn</h2>"
                    + "<p>Xin chào <strong>" + reservation.getUser().getFullName() + "</strong>,</p>"
                    + "<p>Yêu cầu đặt bàn của bạn vào lúc <strong>" + reservation.getReservationTime() + "</strong> tại chi nhánh <strong>" + reservation.getStore().getName() + "</strong> cho <strong>" + reservation.getGuestCount() + " khách</strong> đã được ghi nhận.</p>"
                    + "<p>Nhân viên chi nhánh sẽ liên hệ lại với bạn trong ít phút để xác nhận vị trí bàn tốt nhất.</p>"
                    + "</div>";

            helper.setText(htmlContent, true);
            mailSender.send(message);
        } catch (Exception ex) {
            System.err.println("Notice: Could not dispatch reservation confirmation email: " + ex.getMessage());
        }
    }
}
