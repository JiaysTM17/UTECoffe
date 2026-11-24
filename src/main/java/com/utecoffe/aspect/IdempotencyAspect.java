package com.utecoffe.aspect;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.utecoffe.dto.response.ApiResponse;
import com.utecoffe.service.IdempotencyService;
import com.utecoffe.service.IdempotencyService.IdempotencyCheckResult;
import jakarta.servlet.http.HttpServletRequest;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Aspect
@Component
public class IdempotencyAspect {

    @Autowired
    private IdempotencyService idempotencyService;

    @Autowired
    private ObjectMapper objectMapper;

    @Around("@annotation(idempotent)")
    public Object handleIdempotency(ProceedingJoinPoint joinPoint, Idempotent idempotent) throws Throwable {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes == null) {
            return joinPoint.proceed();
        }

        HttpServletRequest request = attributes.getRequest();
        String idempotencyKey = request.getHeader(idempotent.headerName());

        // If no idempotency header is provided, proceed normally without locking
        if (idempotencyKey == null || idempotencyKey.trim().isEmpty()) {
            return joinPoint.proceed();
        }

        // Calculate payload hash
        StringBuilder payloadBuilder = new StringBuilder();
        for (Object arg : joinPoint.getArgs()) {
            if (arg != null) {
                try {
                    payloadBuilder.append(objectMapper.writeValueAsString(arg));
                } catch (Exception e) {
                    payloadBuilder.append(arg.toString());
                }
            }
        }
        String requestHash = idempotencyService.computeSha256(payloadBuilder.toString());

        // Check & lock
        IdempotencyCheckResult checkResult = idempotencyService.checkAndLock(idempotencyKey, requestHash);

        if (checkResult.getAction() == IdempotencyCheckResult.Action.CONFLICT) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(ApiResponse.error(checkResult.getResponsePayload()));
        }

        if (checkResult.getAction() == IdempotencyCheckResult.Action.CACHED) {
            // Replay cached response
            int status = checkResult.getHttpStatus() != null ? checkResult.getHttpStatus() : 200;
            return ResponseEntity.status(status).body(objectMapper.readValue(checkResult.getResponsePayload(), Object.class));
        }

        // Action == ACQUIRED: Proceed with real execution
        try {
            Object result = joinPoint.proceed();

            int httpStatus = 200;
            String jsonPayload = "";
            if (result instanceof ResponseEntity<?> responseEntity) {
                httpStatus = responseEntity.getStatusCode().value();
                jsonPayload = objectMapper.writeValueAsString(responseEntity.getBody());
            } else {
                jsonPayload = objectMapper.writeValueAsString(result);
            }

            idempotencyService.markSuccess(idempotencyKey, httpStatus, jsonPayload);
            return result;
        } catch (Throwable t) {
            idempotencyService.markFailed(idempotencyKey);
            throw t;
        }
    }
}
