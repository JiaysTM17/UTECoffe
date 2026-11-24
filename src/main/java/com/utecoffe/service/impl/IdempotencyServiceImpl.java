package com.utecoffe.service.impl;

import com.utecoffe.service.IdempotencyService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Instant;
import java.util.HexFormat;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Enterprise Idempotency & Token Bucket Rate Limiting Engine.
 * Formulated to guarantee exact-once execution for financial checkout,
 * loyalty point redemption, and stock deduction.
 */
@Service
public class IdempotencyServiceImpl implements IdempotencyService {

    private static final Logger log = LoggerFactory.getLogger(IdempotencyServiceImpl.class);

    private static class IdempotencyRecord {
        final String payloadHash;
        final Instant createdAt;
        int httpStatus = 200;
        String responsePayload;
        boolean committed;

        IdempotencyRecord(String payloadHash) {
            this.payloadHash = payloadHash;
            this.createdAt = Instant.now();
            this.committed = false;
        }
    }

    private static class TokenBucket {
        final long capacity;
        final double refillRatePerSecond;
        double currentTokens;
        long lastRefillTimestamp;

        TokenBucket(long capacity, double refillRatePerSecond) {
            this.capacity = capacity;
            this.refillRatePerSecond = refillRatePerSecond;
            this.currentTokens = capacity;
            this.lastRefillTimestamp = System.currentTimeMillis();
        }

        synchronized boolean tryConsume(int tokens) {
            refill();
            if (currentTokens >= tokens) {
                currentTokens -= tokens;
                return true;
            }
            return false;
        }

        private void refill() {
            long now = System.currentTimeMillis();
            double secondsElapsed = (now - lastRefillTimestamp) / 1000.0;
            if (secondsElapsed > 0) {
                currentTokens = Math.min(capacity, currentTokens + secondsElapsed * refillRatePerSecond);
                lastRefillTimestamp = now;
            }
        }
    }

    // In-memory concurrent state (Can be swapped with Redis in distributed cluster)
    private final Map<String, IdempotencyRecord> idempotencyStore = new ConcurrentHashMap<>();
    private final Map<String, TokenBucket> rateLimiters = new ConcurrentHashMap<>();

    // Default rate limit: 60 tokens capacity, replenishing 1 token/sec (60 req/min)
    private static final long DEFAULT_BUCKET_CAPACITY = 60;
    private static final double DEFAULT_REFILL_RATE = 1.0;

    @Override
    public IdempotencyCheckResult checkAndLock(String idempotencyKey, String requestHash) {
        if (idempotencyKey == null || idempotencyKey.isBlank()) {
            return IdempotencyCheckResult.acquired();
        }

        IdempotencyRecord newRecord = new IdempotencyRecord(requestHash);
        IdempotencyRecord existing = idempotencyStore.putIfAbsent(idempotencyKey, newRecord);

        if (existing == null) {
            log.info("Idempotency lock acquired for key: {}", idempotencyKey);
            return IdempotencyCheckResult.acquired();
        }

        // Check if hash matches
        if (!existing.payloadHash.equals(requestHash)) {
            log.warn("Idempotency conflict detected for key: {}", idempotencyKey);
            return IdempotencyCheckResult.conflict("IDEMPOTENCY_CONFLICT: Key was previously submitted with different payload parameters.");
        }

        if (existing.committed) {
            log.info("Returning cached idempotent response for key: {}", idempotencyKey);
            return IdempotencyCheckResult.cached(existing.httpStatus, existing.responsePayload);
        }

        log.warn("Concurrent in-flight duplicate request detected for key: {}", idempotencyKey);
        return IdempotencyCheckResult.conflict("IDEMPOTENCY_IN_FLIGHT: A request with this key is currently being processed.");
    }

    @Override
    public void markSuccess(String idempotencyKey, int httpStatus, String responsePayload) {
        if (idempotencyKey == null || idempotencyKey.isBlank()) return;

        IdempotencyRecord record = idempotencyStore.get(idempotencyKey);
        if (record != null) {
            record.httpStatus = httpStatus;
            record.responsePayload = responsePayload;
            record.committed = true;
            log.info("Idempotency marked success for key: {}", idempotencyKey);
        }
    }

    @Override
    public void markFailed(String idempotencyKey) {
        if (idempotencyKey == null || idempotencyKey.isBlank()) return;
        idempotencyStore.remove(idempotencyKey);
        log.info("Idempotency lock released due to failure for key: {}", idempotencyKey);
    }

    @Override
    public boolean acquireIdempotencyLock(String key, String requestPayload) {
        if (key == null || key.isBlank()) {
            return true;
        }

        String hash = computeSha256(requestPayload);
        IdempotencyRecord existing = idempotencyStore.putIfAbsent(key, new IdempotencyRecord(hash));

        if (existing == null) {
            log.info("Idempotency lock acquired successfully for key: {}", key);
            return true;
        }

        if (!existing.payloadHash.equals(hash)) {
            log.warn("Idempotency conflict! Key {} reused with different payload hash.", key);
            throw new IllegalStateException("IDEMPOTENCY_CONFLICT: Key was previously submitted with different request parameters.");
        }

        log.info("Duplicate idempotent request detected for key: {}. Committed: {}", key, existing.committed);
        return false;
    }

    @Override
    public void commitIdempotencyResult(String key, String responsePayload) {
        if (key == null || key.isBlank()) return;

        IdempotencyRecord record = idempotencyStore.get(key);
        if (record != null) {
            record.responsePayload = responsePayload;
            record.committed = true;
            log.info("Idempotency response committed for key: {}", key);
        }
    }

    @Override
    public String getCachedResponse(String key) {
        if (key == null) return null;
        IdempotencyRecord record = idempotencyStore.get(key);
        return (record != null && record.committed) ? record.responsePayload : null;
    }

    @Override
    public boolean tryAcquireRateLimitToken(String clientId) {
        if (clientId == null || clientId.isBlank()) {
            clientId = "anonymous";
        }

        TokenBucket bucket = rateLimiters.computeIfAbsent(clientId, 
                id -> new TokenBucket(DEFAULT_BUCKET_CAPACITY, DEFAULT_REFILL_RATE));

        boolean allowed = bucket.tryConsume(1);
        if (!allowed) {
            log.warn("Token Bucket rate limit exceeded for client: {}", clientId);
        }
        return allowed;
    }

    @Override
    public String computeSha256(String input) {
        if (input == null) input = "";
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = digest.digest(input.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(hashBytes);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }
}
