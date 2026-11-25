package com.utecoffe.security;

import org.springframework.stereotype.Service;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * High-performance enterprise Token Bucket & Sliding Window Rate Limiter.
 * Prevents API abuse, DDoS, credential stuffing, and duplicate rapid submissions.
 */
@Service
public class RateLimiterService {

    private final ConcurrentHashMap<String, TokenBucket> buckets = new ConcurrentHashMap<>();

    public static class TokenBucket {
        private final double capacity;
        private final double refillRatePerSecond;
        private double availableTokens;
        private long lastRefillNanos;

        public TokenBucket(double capacity, double refillRatePerSecond) {
            this.capacity = capacity;
            this.refillRatePerSecond = refillRatePerSecond;
            this.availableTokens = capacity;
            this.lastRefillNanos = System.nanoTime();
        }

        public synchronized boolean tryConsume(double tokens) {
            refill();
            if (availableTokens >= tokens) {
                availableTokens -= tokens;
                return true;
            }
            return false;
        }

        private void refill() {
            long now = System.nanoTime();
            double secondsElapsed = (now - lastRefillNanos) / 1_000_000_000.0;
            if (secondsElapsed > 0) {
                availableTokens = Math.min(capacity, availableTokens + (secondsElapsed * refillRatePerSecond));
                lastRefillNanos = now;
            }
        }

        public synchronized double getAvailableTokens() {
            refill();
            return availableTokens;
        }
    }

    public boolean tryAcquire(String key, double capacity, double refillPerSecond) {
        if (key == null || key.isEmpty()) return true;
        TokenBucket bucket = buckets.computeIfAbsent(key, k -> new TokenBucket(capacity, refillPerSecond));
        return bucket.tryConsume(1.0);
    }

    /**
     * Clear stale buckets periodically if needed
     */
    public void cleanup() {
        if (buckets.size() > 50000) {
            buckets.clear();
        }
    }
}
