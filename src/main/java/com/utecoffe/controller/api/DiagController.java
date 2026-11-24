package com.utecoffe.controller.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.LinkedHashMap;
import java.util.Map;

@RestController
public class DiagController {

    @Autowired(required = false)
    private DataSource dataSource;

    @GetMapping("/ping")
    public String ping() {
        return "PONG - UTECoffe Platform Online (Build 2026-11-25.01)";
    }

    @GetMapping("/diag")
    public Map<String, Object> diag() {
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("status", "UP");
        res.put("timestamp", System.currentTimeMillis());

        Map<String, String> env = new LinkedHashMap<>();
        env.put("PORT", System.getenv("PORT"));
        env.put("SPRING_PROFILES_ACTIVE", System.getenv("SPRING_PROFILES_ACTIVE"));
        env.put("DB_HOST", System.getenv("DB_HOST"));
        env.put("DB_PORT", System.getenv("DB_PORT"));
        env.put("DB_NAME", System.getenv("DB_NAME"));
        env.put("DB_USERNAME", System.getenv("DB_USERNAME"));
        env.put("DB_PASSWORD_SET", String.valueOf(System.getenv("DB_PASSWORD") != null && !System.getenv("DB_PASSWORD").isBlank()));
        
        String dbUrl = System.getenv("DATABASE_URL");
        if (dbUrl == null) dbUrl = System.getenv("DB_URL");
        if (dbUrl != null) {
            env.put("DATABASE_URL_MASKED", dbUrl.replaceAll(":[^:@]+@", ":****@"));
        } else {
            env.put("DATABASE_URL_MASKED", "null");
        }
        res.put("environment", env);

        // Test direct JDBC connection with 5s timeout to catch real exception
        Map<String, Object> dbTest = new LinkedHashMap<>();
        String testUrl = null;
        String testUser = System.getenv("DB_USERNAME");
        String testPass = System.getenv("DB_PASSWORD");

        if (System.getenv("DB_HOST") != null && !System.getenv("DB_HOST").isBlank()) {
            testUrl = "jdbc:postgresql://" + System.getenv("DB_HOST").trim() + ":5432/" + 
                      (System.getenv("DB_NAME") != null ? System.getenv("DB_NAME").trim() : "utecoffe_db") + "?sslmode=disable";
        } else if (dbUrl != null && !dbUrl.isBlank()) {
            testUrl = dbUrl;
            if (testUrl.startsWith("postgres://")) {
                testUrl = "jdbc:postgresql://" + testUrl.substring("postgres://".length());
            } else if (testUrl.startsWith("postgresql://")) {
                testUrl = "jdbc:postgresql://" + testUrl.substring("postgresql://".length());
            }
            if (!testUrl.contains("sslmode=")) {
                testUrl += (testUrl.contains("?") ? "&" : "?") + "sslmode=disable";
            }
        } else {
            testUrl = "jdbc:postgresql://localhost:5432/utecoffe_db?sslmode=disable";
        }
        
        dbTest.put("targetJdbcUrl", testUrl.replaceAll(":[^:@]+@", ":****@"));
        dbTest.put("targetUser", testUser != null ? testUser : "postgres");

        try {
            DriverManager.setLoginTimeout(5);
            try (Connection conn = DriverManager.getConnection(testUrl, testUser != null ? testUser : "postgres", testPass != null ? testPass : "postgres")) {
                dbTest.put("directConnectSuccess", true);
                dbTest.put("dbProduct", conn.getMetaData().getDatabaseProductName());
                dbTest.put("dbVersion", conn.getMetaData().getDatabaseProductVersion());
            }
        } catch (Throwable t) {
            dbTest.put("directConnectSuccess", false);
            dbTest.put("errorClass", t.getClass().getName());
            dbTest.put("errorMessage", t.getMessage());
        }
        res.put("dbDirectTest", dbTest);

        return res;
    }
}
