package com.utecoffe.aspect;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Enterprise Rate Limiting annotation backed by Token Bucket Algorithm.
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface RateLimited {
    String keyPrefix() default "api_rl";
    double capacity() default 20.0;
    double refillTokensPerSecond() default 2.0;
    String message() default "Tần suất thao tác quá nhanh. Quý khách vui lòng chờ giây lát trước khi thử lại.";
}
