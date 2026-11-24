# ============================================================================
# Stage 1: Build with Maven 3.9 and JDK 21 (Optimized for Cloud 512MB RAM)
# ============================================================================
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /build

# Constrain Maven heap memory to prevent container OOM on Cloud Free tiers
ENV MAVEN_OPTS="-Xmx384m -XX:+UseSerialGC"

# Create directories before copying settings
RUN mkdir -p /root/.m2 /usr/share/maven/conf

# Copy Google Cloud mirror settings to system and user Maven directories
COPY settings.xml /root/.m2/settings.xml
COPY settings.xml /usr/share/maven/conf/settings.xml

# Copy Maven POM and source files
COPY pom.xml .
COPY settings.xml .
COPY src ./src

# Build production WAR package skipping tests using Google Cloud mirror
RUN mvn clean package -s settings.xml -DskipTests -B

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
ENV JAVA_OPTS="-XX:+UseSerialGC -XX:MaxRAMPercentage=70.0 -Djava.security.egd=file:/dev/./urandom"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.war --server.port=${PORT}"]
