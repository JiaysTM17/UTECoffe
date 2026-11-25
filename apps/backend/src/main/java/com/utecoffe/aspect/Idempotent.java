package com.utecoffe.aspect;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Ensures strict HTTP Idempotency for critical operations (e.g. Order Creation, Payment).
 * Extracts 'Idempotency-Key' from HTTP headers. If replayed, serves the cached result directly.
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Idempotent {
    String headerName() default "Idempotency-Key";
    long ttlHours() default 24;
}
