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

        // 2. Parse and normalize Cloud URI (postgres://, postgresql://, or jdbc:postgresql:// with user:pass@)
        if (rawUrl != null) {
            String clean = rawUrl.trim();
            java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("^(?:(?:postgres|postgresql|jdbc:postgresql)://)?(?:([^:@]+)(?::([^@]+))?@)?([^:/]+)(?::(\\d+))?(?:/([^?]+))?(?:\\?(.*))?$");
            java.util.regex.Matcher m = pattern.matcher(clean);
            if (m.matches()) {
                String u = m.group(1);
                String p = m.group(2);
                String h = m.group(3);
                String port = m.group(4);
                String db = m.group(5);
                String query = m.group(6);

                if (u != null && !u.isBlank() && (envUser == null || envUser.isBlank() || "postgres".equals(envUser))) {
                    envUser = u;
                }
                if (p != null && !p.isBlank() && (envPass == null || envPass.isBlank() || "postgres".equals(envPass))) {
                    envPass = p;
                }

                if (h != null && !h.isBlank()) {
                    rawUrl = "jdbc:postgresql://" + h + ":" + (port != null && !port.isBlank() ? port : "5432") + "/" + (db != null && !db.isBlank() ? db : "utecoffe_db");
                    if (query != null && !query.isBlank()) {
                        rawUrl += "?" + query;
                    }
                }
            }
        }

        // 3. Ensure SSL mode ONLY for remote cloud PostgreSQL databases (Render external / Neon / Supabase)
        // CRITICAL FOR RENDER INTERNAL DB:
        // Hostnames starting with "dpg-" or ending with ".render.com" / ".render.internal" inside Render VPC
        // run on plaintext TCP (no SSL). Any SSL handshake (prefer/require) will hang for 30s causing Hikari timeout!
        boolean isInternalRenderHost = (rawUrl != null && (rawUrl.contains("dpg-") || rawUrl.contains("render.internal") || rawUrl.contains("utecoffe-db") || rawUrl.contains("singapore-postgres")));
        
        if (rawUrl != null && rawUrl.startsWith("jdbc:postgresql://")) {
            if (isInternalRenderHost) {
                // Explicitly disable SSL for Render internal network
                if (!rawUrl.contains("sslmode=")) {
                    rawUrl += (rawUrl.contains("?") ? "&" : "?") + "sslmode=disable";
                }
            } else if (!rawUrl.contains("sslmode=") && !rawUrl.contains("localhost") && !rawUrl.contains("127.0.0.1")) {
                rawUrl += (rawUrl.contains("?") ? "&" : "?") + "sslmode=prefer";
            }
        }

        config.setJdbcUrl(rawUrl);

        if (envUser != null && !envUser.isBlank()) {
            config.setUsername(envUser);
        }
        if (envPass != null && !envPass.isBlank()) {
            config.setPassword(envPass);
        }

        // 5. Connection pool settings for Cloud Production
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(1);
        config.setConnectionTimeout(10000); // 10 seconds timeout so user doesn't wait 30s
        config.setInitializationFailTimeout(-1); // Do not fail Spring Boot startup if DB takes time to connect
        config.setIdleTimeout(300000);
        config.setMaxLifetime(900000);
        config.setLeakDetectionThreshold(15000); // Log leak warning after 15s

        log.info("Initialized Cloud HikariDataSource with JDBC URL: {}", rawUrl != null && rawUrl.contains("@") ? rawUrl.replaceAll(":[^:@]+@", ":****@") : rawUrl);

        return new HikariDataSource(config);
    }
}
