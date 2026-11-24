package com.utecoffe.service;

import com.utecoffe.enums.IdempotencyStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

public interface IdempotencyService {

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    class IdempotencyCheckResult {
        public enum Action {
            ACQUIRED,
            CACHED,
            CONFLICT
        }

        private Action action;
        private Integer httpStatus;
        private String responsePayload;
    }

    IdempotencyCheckResult checkAndLock(String keyValue, String requestHash);

    void markSuccess(String keyValue, int httpStatus, String responsePayload);

    void markFailed(String keyValue);

    String computeSha256(String data);
}
