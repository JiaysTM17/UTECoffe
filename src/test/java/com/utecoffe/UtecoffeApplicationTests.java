package com.utecoffe;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("test")
class UtecoffeApplicationTests {

    @Test
    void contextLoads() {
        // Verifies that the Spring Boot context boots successfully with H2 database
    }
}
