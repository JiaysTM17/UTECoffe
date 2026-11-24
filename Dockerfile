# ============================================================================
# Minimal Production JRE Runtime with Pre-compiled WAR
# Bypasses all Maven Central HTTP 429 rate limits and Cloud OOM constraints
# ============================================================================
FROM eclipse-temurin:21-jdk-jammy

WORKDIR /app

# Non-root user for security
RUN groupadd -r utecoffe && useradd -r -g utecoffe utecoffe

# Copy production WAR package directly (Instant 5-second Docker build on Cloud)
COPY app.war /app/app.war

RUN chown -R utecoffe:utecoffe /app
USER utecoffe

EXPOSE 10000 8080
ENV PORT=10000
ENV SPRING_PROFILES_ACTIVE=prod
ENV JAVA_OPTS="-XX:+UseSerialGC -XX:MaxRAMPercentage=70.0 -Djava.security.egd=file:/dev/./urandom"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.war --server.port=${PORT:-10000} --server.address=0.0.0.0"]
