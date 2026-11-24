package com.utecoffe.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import java.net.URI;
import javax.sql.DataSource;

/**
 * Cloud-Native Database Configuration.
 * Automatically normalizes Render / Railway / Supabase connection strings
 * (e.g. postgres:// or postgresql://) to standard JDBC format (jdbc:postgresql://)
 * and configures an optimal HikariCP pool for cloud container runtimes.
 */
@Configuration
public class DatabaseConfig {

    private static final Logger log = LoggerFactory.getLogger(DatabaseConfig.class);

    @Value("${spring.datasource.url:jdbc:postgresql://localhost:5432/utecoffe_db}")
    private String datasourceUrl;

    @Value("${spring.datasource.username:postgres}")
    private String datasourceUsername;

    @Value("${spring.datasource.password:postgres}")
    private String datasourcePassword;

    @Value("${spring.datasource.driver-class-name:org.postgresql.Driver}")
    private String driverClassName;

    @Bean
    @Primary
    public DataSource dataSource() {
        HikariConfig config = new HikariConfig();
        config.setDriverClassName(driverClassName);

        String envUser = System.getenv("DB_USERNAME");
        if (envUser == null || envUser.isBlank()) {
            envUser = datasourceUsername;
        }
        String envPass = System.getenv("DB_PASSWORD");
        if (envPass == null || envPass.isBlank()) {
            envPass = datasourcePassword;
        }

        // 0. Direct Render fromDatabase parameters (100% reliable, no regex or URI parsing needed)
        String directHost = System.getenv("DB_HOST");
        String directPort = System.getenv("DB_PORT");
        String directName = System.getenv("DB_NAME");
        String rawUrl = null;

        if (directHost != null && !directHost.isBlank()) {
            int portNum = 5432;
            if (directPort != null && !directPort.isBlank()) {
                try { portNum = Integer.parseInt(directPort.trim()); } catch (Exception ignored) {}
            }
            rawUrl = "jdbc:postgresql://" + directHost.trim() + ":" + portNum + "/" + (directName != null && !directName.isBlank() ? directName.trim() : "utecoffe_db");
            log.info("Constructed direct Cloud PostgreSQL JDBC URL from DB_HOST={}", directHost);
        }

        // 1. Fallback: Resolve raw URL from environment or properties
        if (rawUrl == null || rawUrl.isBlank()) {
            rawUrl = System.getenv("DATABASE_URL");
        }
        if (rawUrl == null || rawUrl.isBlank()) {
            rawUrl = System.getenv("DB_URL");
        }
        if (rawUrl == null || rawUrl.isBlank()) {
            rawUrl = datasourceUrl;
        }

        // 2. Normalize Cloud URI formats (postgres:// or postgresql://) to clean JDBC format
        if (rawUrl != null && (rawUrl.startsWith("postgres://") || rawUrl.startsWith("postgresql://"))) {
            try {
                URI uri = new URI(rawUrl);
                String host = uri.getHost();
                int port = uri.getPort() > 0 ? uri.getPort() : 5432;
                String path = uri.getPath() != null ? uri.getPath() : "/utecoffe_db";
                String query = uri.getQuery();

                if (uri.getUserInfo() != null) {
                    String[] userInfo = uri.getUserInfo().split(":", 2);
                    if (userInfo.length > 0 && (envUser == null || envUser.isBlank() || "postgres".equals(envUser))) {
                        envUser = userInfo[0];
                    }
                    if (userInfo.length > 1 && (envPass == null || envPass.isBlank() || "postgres".equals(envPass))) {
                        envPass = userInfo[1];
                    }
                }

                rawUrl = "jdbc:postgresql://" + host + ":" + port + path;
                if (query != null && !query.isBlank()) {
                    rawUrl += "?" + query;
                }
            } catch (Exception e) {
                log.warn("Failed to parse raw cloud database URL as URI: {}", e.getMessage());
                String trimmed = rawUrl.trim();
                if (trimmed.startsWith("postgres://")) {
                    rawUrl = "jdbc:postgresql://" + trimmed.substring("postgres://".length());
                } else if (trimmed.startsWith("postgresql://")) {
                    rawUrl = "jdbc:postgresql://" + trimmed.substring("postgresql://".length());
                }
            }
        }

        // 3. Ensure SSL mode ONLY for remote cloud PostgreSQL databases (Render external / Neon / Supabase)
        if (rawUrl != null && rawUrl.startsWith("jdbc:postgresql://") && !rawUrl.contains("sslmode=") && !rawUrl.contains("localhost") && !rawUrl.contains("127.0.0.1") && !rawUrl.contains("utecoffe-db")) {
            rawUrl += (rawUrl.contains("?") ? "&" : "?") + "sslmode=prefer";
        }

        config.setJdbcUrl(rawUrl);

        if (envUser != null && !envUser.isBlank()) {
            config.setUsername(envUser);
        }
        if (envPass != null && !envPass.isBlank()) {
            config.setPassword(envPass);
        }

        // 5. Connection pool settings for Cloud Production
        config.setMaximumPoolSize(15);
        config.setMinimumIdle(2);
        config.setConnectionTimeout(30000);
        config.setIdleTimeout(300000);
        config.setMaxLifetime(900000);
        config.setLeakDetectionThreshold(60000);

        log.info("Initialized Cloud HikariDataSource with JDBC URL: {}", rawUrl != null && rawUrl.contains("@") ? rawUrl.replaceAll(":[^:@]+@", ":****@") : rawUrl);

        return new HikariDataSource(config);
    }
}
