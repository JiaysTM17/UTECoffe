package com.utecoffe.service.impl;

import com.utecoffe.entity.IdempotencyKey;
import com.utecoffe.enums.IdempotencyStatus;
import com.utecoffe.repository.IdempotencyKeyRepository;
import com.utecoffe.service.IdempotencyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class IdempotencyServiceImpl implements IdempotencyService {

    @Autowired
    private IdempotencyKeyRepository idempotencyKeyRepository;

    @Override
    @Transactional(isolation = Isolation.READ_COMMITTED)
    public IdempotencyCheckResult checkAndLock(String keyValue, String requestHash) {
        if (keyValue == null || keyValue.trim().isEmpty()) {
            return IdempotencyCheckResult.builder().action(IdempotencyCheckResult.Action.ACQUIRED).build();
        }

        Optional<IdempotencyKey> existingOpt = idempotencyKeyRepository.findByKeyValue(keyValue.trim());
        if (existingOpt.isPresent()) {
            IdempotencyKey existing = existingOpt.get();

            // If already completed, replay the exact response without re-executing
            if (existing.getStatus() == IdempotencyStatus.COMPLETED) {
                return IdempotencyCheckResult.builder()
                        .action(IdempotencyCheckResult.Action.CACHED)
                        .httpStatus(existing.getHttpStatus() != null ? existing.getHttpStatus() : 200)
                        .responsePayload(existing.getResponsePayload())
                        .build();
            }

            // If processing and within lock TTL (e.g. 2 minutes), reject concurrent duplicate
            if (existing.getStatus() == IdempotencyStatus.PROCESSING) {
                if (existing.getCreatedAt().isAfter(LocalDateTime.now().minusMinutes(2))) {
                    return IdempotencyCheckResult.builder()
                            .action(IdempotencyCheckResult.Action.CONFLICT)
                            .httpStatus(409)
                            .responsePayload("{\"success\":false,\"message\":\"Yêu cầu đang được hệ thống xử lý, vui lòng không nhấn liên tục.\"}")
                            .build();
                } else {
                    // Stale lock, allow retry
                    existing.setStatus(IdempotencyStatus.PROCESSING);
                    existing.setRequestHash(requestHash);
                    existing.setCreatedAt(LocalDateTime.now());
                    idempotencyKeyRepository.save(existing);
                    return IdempotencyCheckResult.builder().action(IdempotencyCheckResult.Action.ACQUIRED).build();
                }
            }

            // If FAILED, reset to processing
            existing.setStatus(IdempotencyStatus.PROCESSING);
            existing.setRequestHash(requestHash);
            existing.setCreatedAt(LocalDateTime.now());
            idempotencyKeyRepository.save(existing);
            return IdempotencyCheckResult.builder().action(IdempotencyCheckResult.Action.ACQUIRED).build();
        }

        // Key not found: atomically acquire lock
        IdempotencyKey newKey = IdempotencyKey.builder()
                .keyValue(keyValue.trim())
                .requestHash(requestHash)
                .status(IdempotencyStatus.PROCESSING)
                .createdAt(LocalDateTime.now())
                .expiresAt(LocalDateTime.now().plusHours(24))
                .build();
        try {
            idempotencyKeyRepository.save(newKey);
            return IdempotencyCheckResult.builder().action(IdempotencyCheckResult.Action.ACQUIRED).build();
        } catch (Exception e) {
            // Concurrent insert race condition caught by unique index
            return IdempotencyCheckResult.builder()
                    .action(IdempotencyCheckResult.Action.CONFLICT)
                    .httpStatus(409)
                    .responsePayload("{\"success\":false,\"message\":\"Giao dịch đang được xử lý đồng thời. Vui lòng kiểm tra lại trạng thái đơn hàng.\"}")
                    .build();
        }
    }

    @Override
    @Transactional
    public void markSuccess(String keyValue, int httpStatus, String responsePayload) {
        if (keyValue == null || keyValue.trim().isEmpty()) return;
        idempotencyKeyRepository.findByKeyValue(keyValue.trim()).ifPresent(record -> {
            record.setStatus(IdempotencyStatus.COMPLETED);
            record.setHttpStatus(httpStatus);
            record.setResponsePayload(responsePayload);
            idempotencyKeyRepository.save(record);
        });
    }

    @Override
    @Transactional
    public void markFailed(String keyValue) {
        if (keyValue == null || keyValue.trim().isEmpty()) return;
        idempotencyKeyRepository.findByKeyValue(keyValue.trim()).ifPresent(record -> {
            record.setStatus(IdempotencyStatus.FAILED);
            idempotencyKeyRepository.save(record);
        });
    }

    @Override
    public String computeSha256(String data) {
        if (data == null) return "";
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            return String.valueOf(data.hashCode());
        }
    }
}
