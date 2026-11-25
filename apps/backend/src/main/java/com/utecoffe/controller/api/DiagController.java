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

    @Autowired(required = false)
    private com.utecoffe.config.DatabaseSeeder databaseSeeder;

    @Autowired(required = false)
    private com.utecoffe.repository.ProductRepository productRepository;

    @Autowired(required = false)
    private com.utecoffe.repository.CategoryRepository categoryRepository;

    @GetMapping("/ping")
    public String ping() {
        return "PONG - UTECoffe Platform Online (Build 2026-11-25.03)";
    }

    @GetMapping("/sync-catalog")
    public Map<String, Object> syncCatalog() {
        Map<String, Object> res = new LinkedHashMap<>();
        if (databaseSeeder != null) {
            try {
                databaseSeeder.seedCatalogAndBOM();
                res.put("status", "SUCCESS");
                res.put("totalProducts", productRepository != null ? productRepository.count() : -1);
                res.put("totalCategories", categoryRepository != null ? categoryRepository.count() : -1);
            } catch (Exception e) {
                res.put("status", "ERROR");
                res.put("error", e.getMessage());
            }
        } else {
            res.put("status", "ERROR");
            res.put("message", "DatabaseSeeder bean not found");
        }
        return res;
    }

    @GetMapping("/threads")
    public Map<String, Object> threads() {
        Map<String, Object> res = new LinkedHashMap<>();
        java.lang.management.ThreadMXBean bean = java.lang.management.ManagementFactory.getThreadMXBean();
        java.lang.management.ThreadInfo[] infos = bean.dumpAllThreads(true, true);
        for (java.lang.management.ThreadInfo info : infos) {
            String name = info.getThreadName();
            if (name.contains("exec") || name.contains("http") || name.contains("Hikari") || name.contains("main")) {
                java.util.List<String> stack = new java.util.ArrayList<>();
                for (StackTraceElement elem : info.getStackTrace()) {
                    stack.add(elem.toString());
                    if (stack.size() >= 20) break;
                }
                Map<String, Object> t = new LinkedHashMap<>();
                t.put("state", info.getThreadState().toString());
                t.put("lockName", info.getLockName());
                t.put("lockOwner", info.getLockOwnerName());
                t.put("stack", stack);
                res.put(name, t);
            }
        }
        return res;
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
        String testUrl = dbUrl != null && !dbUrl.isBlank() ? dbUrl : "jdbc:postgresql://localhost:5432/utecoffe_db";
        String testUser = System.getenv("DB_USERNAME");
        String testPass = System.getenv("DB_PASSWORD");

        java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("^(?:(?:postgres|postgresql|jdbc:postgresql)://)?(?:([^:@]+)(?::([^@]+))?@)?([^:/]+)(?::(\\d+))?(?:/([^?]+))?(?:\\?(.*))?$");
        java.util.regex.Matcher m = pattern.matcher(testUrl.trim());
        if (m.matches()) {
            String u = m.group(1);
            String p = m.group(2);
            String h = m.group(3);
            String port = m.group(4);
            String db = m.group(5);
            String query = m.group(6);

            if (u != null && !u.isBlank()) testUser = u;
            if (p != null && !p.isBlank()) testPass = p;
            if (h != null && !h.isBlank()) {
                testUrl = "jdbc:postgresql://" + h + ":" + (port != null && !port.isBlank() ? port : "5432") + "/" + (db != null && !db.isBlank() ? db : "utecoffe_db");
                if (query != null && !query.isBlank()) {
                    testUrl += "?" + query;
                }
            }
        }

        if (!testUrl.contains("sslmode=")) {
            testUrl += (testUrl.contains("?") ? "&" : "?") + "sslmode=disable";
        }
        
        dbTest.put("targetJdbcUrl", testUrl.replaceAll(":[^:@]+@", ":****@"));
        dbTest.put("targetUser", testUser != null ? testUser : "postgres");

        try {
            DriverManager.setLoginTimeout(5);
            try (Connection conn = DriverManager.getConnection(testUrl, testUser != null ? testUser : "postgres", testPass != null ? testPass : "postgres")) {
                dbTest.put("directConnectSuccess", true);
                dbTest.put("dbProduct", conn.getMetaData().getDatabaseProductName());
                dbTest.put("dbVersion", conn.getMetaData().getDatabaseProductVersion());

                // Check active queries and locks in PostgreSQL
                java.util.List<Map<String, Object>> activities = new java.util.ArrayList<>();
                try (java.sql.Statement stmt = conn.createStatement();
                     java.sql.ResultSet rs = stmt.executeQuery("SELECT pid, state, wait_event_type, wait_event, query FROM pg_stat_activity WHERE datname = 'utecoffe_db'")) {
                    while (rs.next()) {
                        Map<String, Object> act = new LinkedHashMap<>();
                        act.put("pid", rs.getInt("pid"));
                        act.put("state", rs.getString("state"));
                        act.put("wait_event_type", rs.getString("wait_event_type"));
                        act.put("wait_event", rs.getString("wait_event"));
                        act.put("query", rs.getString("query"));
                        activities.add(act);
                    }
                }
                dbTest.put("pg_stat_activity", activities);
            }
        } catch (Throwable t) {
            dbTest.put("directConnectSuccess", false);
            dbTest.put("errorClass", t.getClass().getName());
            dbTest.put("errorMessage", t.getMessage());
        }
        res.put("dbDirectTest", dbTest);

        Map<String, Object> poolInfo = new LinkedHashMap<>();
        if (dataSource instanceof com.zaxxer.hikari.HikariDataSource hikari) {
            poolInfo.put("jdbcUrl", hikari.getJdbcUrl() != null ? hikari.getJdbcUrl().replaceAll(":[^:@]+@", ":****@") : null);
            poolInfo.put("username", hikari.getUsername());
            poolInfo.put("maximumPoolSize", hikari.getMaximumPoolSize());
            poolInfo.put("isClosed", hikari.isClosed());
            try (Connection c = dataSource.getConnection()) {
                poolInfo.put("poolConnectionSuccess", true);
            } catch (Throwable t) {
                poolInfo.put("poolConnectionSuccess", false);
                poolInfo.put("error", t.getClass().getSimpleName() + ": " + t.getMessage());
            }
        }
        res.put("hikariPoolInfo", poolInfo);

        return res;
    }
}
