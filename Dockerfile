# ============================================================================
# Minimal Production JRE Runtime with Pre-compiled Exploded WAR
# Monorepo compatibility: builds apps/backend/app.war
# ============================================================================
FROM eclipse-temurin:21-jdk-jammy

WORKDIR /app

# Non-root user for security
RUN groupadd -r utecoffe && useradd -r -g utecoffe utecoffe

# Copy production WAR package from apps/backend
COPY apps/backend/app.war /app/app.war
RUN mkdir -p /app/exploded /app/tomcat-work && \
    cd /app/exploded && jar -xf /app/app.war && \
    rm /app/app.war && \
    chown -R utecoffe:utecoffe /app

USER utecoffe
WORKDIR /app/exploded

EXPOSE 10000 8080
ENV PORT=10000
ENV SPRING_PROFILES_ACTIVE=prod
ENV JAVA_OPTS="-XX:+UseSerialGC -XX:MaxRAMPercentage=70.0 -Djava.security.egd=file:/dev/./urandom"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS org.springframework.boot.loader.launch.WarLauncher --server.port=${PORT:-10000} --server.address=0.0.0.0"]
