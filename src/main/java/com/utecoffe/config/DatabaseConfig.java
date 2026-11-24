package com.utecoffe.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

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

        // 1. Resolve raw URL from environment or properties
        String rawUrl = System.getenv("DATABASE_URL");
        if (rawUrl == null || rawUrl.isBlank()) {
            rawUrl = System.getenv("DB_URL");
        }
        if (rawUrl == null || rawUrl.isBlank()) {
            rawUrl = datasourceUrl;
        }

        // 2. Normalize Cloud URI formats (postgres:// or postgresql://) to jdbc:postgresql://
        if (rawUrl != null) {
            String trimmed = rawUrl.trim();
            if (trimmed.startsWith("postgres://")) {
                rawUrl = "jdbc:postgresql://" + trimmed.substring("postgres://".length());
            } else if (trimmed.startsWith("postgresql://")) {
                rawUrl = "jdbc:postgresql://" + trimmed.substring("postgresql://".length());
            }
        }

        config.setJdbcUrl(rawUrl);

        // 3. User & Password fallback
        String envUser = System.getenv("DB_USERNAME");
        if (envUser == null || envUser.isBlank()) {
            envUser = datasourceUsername;
        }
        String envPass = System.getenv("DB_PASSWORD");
        if (envPass == null || envPass.isBlank()) {
            envPass = datasourcePassword;
        }

        if (envUser != null && !envUser.isBlank()) {
            config.setUsername(envUser);
        }
        if (envPass != null && !envPass.isBlank()) {
            config.setPassword(envPass);
        }

        // 4. Memory-efficient connection pool settings for 512MB Cloud Tier (Render Free)
        config.setMaximumPoolSize(5);
        config.setMinimumIdle(1);
        config.setConnectionTimeout(30000);
        config.setIdleTimeout(300000);
        config.setMaxLifetime(900000);

        log.info("Initialized Cloud HikariDataSource with JDBC URL: {}", rawUrl != null && rawUrl.contains("@") ? rawUrl.replaceAll(":[^:@]+@", ":****@") : rawUrl);

        return new HikariDataSource(config);
    }
}
