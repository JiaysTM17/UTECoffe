package com.utecoffe.aspect;

import com.utecoffe.entity.AuditLog;
import com.utecoffe.entity.User;
import com.utecoffe.repository.AuditLogRepository;
import com.utecoffe.repository.UserRepository;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.time.LocalDateTime;

@Aspect
@Component
@Slf4j
public class AuditLogAspect {

    @Autowired
    private AuditLogRepository auditLogRepository;

    @Autowired
    private UserRepository userRepository;

    @Around("@annotation(auditable)")
    public Object auditOperation(ProceedingJoinPoint joinPoint, Auditable auditable) throws Throwable {
        long startTime = System.currentTimeMillis();
        String methodName = joinPoint.getSignature().toShortString();
        String action = auditable.action();
        String entityName = auditable.entityName();

        HttpServletRequest request = null;
        try {
            ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attributes != null) {
                request = attributes.getRequest();
            }
        } catch (Exception ignored) {}

        String ipAddress = (request != null) ? getClientIp(request) : "127.0.0.1";
        String userAgent = (request != null) ? request.getHeader("User-Agent") : "Unknown";
        if (userAgent != null && userAgent.length() > 250) {
            userAgent = userAgent.substring(0, 250);
        }

        User currentUser = null;
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
                String principalName = auth.getName();
                currentUser = userRepository.findByEmailOrPhoneNumber(principalName, principalName).orElse(null);
            }
        } catch (Exception ignored) {}

        Object result;
        boolean success = true;
        String errorMessage = null;

        try {
            result = joinPoint.proceed();
        } catch (Throwable ex) {
            success = false;
            errorMessage = ex.getMessage();
            throw ex;
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            String details = String.format("Method: %s, Success: %s, Duration: %d ms", methodName, success, duration);
            if (!success && errorMessage != null) {
                details += ", Error: " + errorMessage;
            }

            try {
                AuditLog auditLog = AuditLog.builder()
                        .user(currentUser)
                        .action(action)
                        .entityName(entityName)
                        .ipAddress(ipAddress)
                        .userAgent(userAgent)
                        .details(details)
                        .timestamp(LocalDateTime.now())
                        .build();

                auditLogRepository.save(auditLog);
                log.info("[AUDIT] Action: {} | Entity: {} | IP: {} | Duration: {}ms", action, entityName, ipAddress, duration);
            } catch (Exception logEx) {
                log.warn("[AUDIT FAILED] Could not record audit log: {}", logEx.getMessage());
            }
        }

        return result;
    }

    private String getClientIp(HttpServletRequest request) {
        String xf = request.getHeader("X-Forwarded-For");
        if (xf != null && !xf.isEmpty()) {
            return xf.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }
}
