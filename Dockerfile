# ============================================================================
# Stage 1: Build with Maven 3.9 and JDK 21
# ============================================================================
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /build

# Copy Maven POM and source files
COPY pom.xml .
COPY src ./src

# Build production WAR package skipping tests for fast and reliable CI/CD
RUN mvn clean package -DskipTests -B -q

# ============================================================================
# Stage 2: Minimal Production JRE Runtime
# ============================================================================
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

# Non-root user for security
RUN groupadd -r utecoffe && useradd -r -g utecoffe utecoffe

# Copy compiled WAR artifact from builder stage
COPY --from=builder /build/target/utecoffe-platform-1.0.0-SNAPSHOT.war /app/app.war

RUN chown -R utecoffe:utecoffe /app
USER utecoffe

EXPOSE 8080
ENV PORT=8080
ENV SPRING_PROFILES_ACTIVE=prod
ENV JAVA_OPTS="-XX:+UseG1GC -XX:MaxRAMPercentage=75.0 -Djava.security.egd=file:/dev/./urandom"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.war --server.port=${PORT}"]
