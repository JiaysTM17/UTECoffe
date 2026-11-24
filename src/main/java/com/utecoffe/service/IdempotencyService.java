package com.utecoffe.service;

public interface IdempotencyService {

    class IdempotencyCheckResult {
        public enum Action {
            ACQUIRED,
            CACHED,
            CONFLICT
        }

        private final Action action;
        private final Integer httpStatus;
        private final String responsePayload;

        public IdempotencyCheckResult(Action action, Integer httpStatus, String responsePayload) {
            this.action = action;
            this.httpStatus = httpStatus;
            this.responsePayload = responsePayload;
        }

        public static IdempotencyCheckResult acquired() {
            return new IdempotencyCheckResult(Action.ACQUIRED, null, null);
        }

        public static IdempotencyCheckResult cached(int httpStatus, String responsePayload) {
            return new IdempotencyCheckResult(Action.CACHED, httpStatus, responsePayload);
        }

        public static IdempotencyCheckResult conflict(String errorMessage) {
            return new IdempotencyCheckResult(Action.CONFLICT, 409, errorMessage);
        }

        public Action getAction() {
            return action;
        }

        public Integer getHttpStatus() {
            return httpStatus;
        }

        public String getResponsePayload() {
            return responsePayload;
        }
    }

    String computeSha256(String input);

    IdempotencyCheckResult checkAndLock(String idempotencyKey, String requestHash);

    void markSuccess(String idempotencyKey, int httpStatus, String responsePayload);

    void markFailed(String idempotencyKey);

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
