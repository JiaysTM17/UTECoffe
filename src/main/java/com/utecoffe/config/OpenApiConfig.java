package com.utecoffe.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI utecoffeOpenAPI() {
        final String securitySchemeName = "bearerAuth";
        return new OpenAPI()
                .servers(java.util.Arrays.asList(
                        new io.swagger.v3.oas.models.servers.Server().url("https://utecoffe.io.vn").description("Production Server (utecoffe.io.vn)"),
                        new io.swagger.v3.oas.models.servers.Server().url("http://localhost:8080").description("Local Development Server")
                ))
                .info(new Info()
                        .title("UTECoffe Platform API Specification")
                        .description("He thong Thuong Mai Dien Tu Chuoi Ban Tra va Ca Phe Dac San UTECoffe - RESTful API Documentation")
                        .version("v1.0.0")
                        .contact(new Contact()
                                .name("UTECoffe Engineering Team")
                                .email("contact@utecoffe.vn")
                                .url("https://github.com/JiaysTM17/UTECoffe"))
                        .license(new License().name("Apache 2.0").url("https://springdoc.org")))
                .addSecurityItem(new SecurityRequirement().addList(securitySchemeName))
                .components(new Components()
                        .addSecuritySchemes(securitySchemeName,
                                new SecurityScheme()
                                        .name(securitySchemeName)
                                        .type(SecurityScheme.Type.HTTP)
                                        .scheme("bearer")
                                        .bearerFormat("JWT")
                                        .description("Nhap ma JWT Token de xac thuc REST API")));
    }
}
