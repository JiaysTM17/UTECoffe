package com.utecoffe.service;

public interface IdempotencyService {
    
    /**
     * Checks whether an idempotency key is valid and not currently in-flight or already committed.
     * @param key Client-provided idempotency key (UUID or unique transaction ref).
     * @param requestPayload Request body or serialized parameter string to hash.
     * @return true if safe to proceed, false if duplicate request detected.
     */
    boolean acquireIdempotencyLock(String key, String requestPayload);

    /**
     * Commits the idempotency result and caches the outcome.
     * @param key Client-provided idempotency key.
     * @param responsePayload JSON response payload to cache.
     */
    void commitIdempotencyResult(String key, String responsePayload);

    /**
     * Retrieves cached response if key was previously committed.
     */
    String getCachedResponse(String key);

    /**
     * Checks Token Bucket rate limit for a client identifier.
     * @param clientId Client IP or User ID.
     * @return true if request allowed, false if rate limited (HTTP 429).
     */
    boolean tryAcquireRateLimitToken(String clientId);
}
