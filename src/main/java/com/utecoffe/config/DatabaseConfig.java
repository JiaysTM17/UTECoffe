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
import java.net.URI;

/**
 * Cloud-Native Database Configuration.
 * Automatically handles standard JDBC URLs, Docker Compose,
 * as well as Cloud Provider URI formats (e.g. Render, Railway, Supabase, Neon)
 * where DATABASE_URL is provided in `postgres://` or `postgresql://` URI format.
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

        String rawUrl = System.getenv("DATABASE_URL");
        if (rawUrl == null || rawUrl.isBlank()) {
            rawUrl = datasourceUrl;
        }

        if (rawUrl != null && (rawUrl.startsWith("postgres://") || rawUrl.startsWith("postgresql://"))) {
            try {
                URI uri = new URI(rawUrl);
                String host = uri.getHost();
                int port = uri.getPort() > 0 ? uri.getPort() : 5432;
                String path = uri.getPath();
                String dbName = (path != null && path.length() > 1) ? path.substring(1) : "utecoffe_db";

                String jdbcUrl = "jdbc:postgresql://" + host + ":" + port + "/" + dbName;
                config.setJdbcUrl(jdbcUrl);

                String userInfo = uri.getUserInfo();
                if (userInfo != null && !userInfo.isBlank()) {
                    String[] parts = userInfo.split(":", 2);
                    config.setUsername(parts[0]);
                    if (parts.length > 1) {
                        config.setPassword(parts[1]);
                    }
                } else {
                    config.setUsername(datasourceUsername);
                    config.setPassword(datasourcePassword);
                }
                log.info("Initialized Cloud PostgreSQL DataSource from parsed URI: {}", jdbcUrl);
            } catch (Exception e) {
                log.warn("Failed to parse DATABASE_URL URI, falling back to raw datasource config: {}", e.getMessage());
                config.setJdbcUrl(rawUrl);
                config.setUsername(datasourceUsername);
                config.setPassword(datasourcePassword);
            }
        } else {
            config.setJdbcUrl(rawUrl);
            config.setUsername(datasourceUsername);
            config.setPassword(datasourcePassword);
        }

        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);
        config.setConnectionTimeout(30000);
        config.setIdleTimeout(600000);
        config.setMaxLifetime(1800000);

        return new HikariDataSource(config);
    }
}
