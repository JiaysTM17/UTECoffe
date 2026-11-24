package com.utecoffe.config;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SiteMeshConfig {

    @Bean
    public FilterRegistrationBean<ConfigurableSiteMeshFilter> siteMeshFilter() {
        FilterRegistrationBean<ConfigurableSiteMeshFilter> filter = new FilterRegistrationBean<>();
        filter.setFilter(new ConfigurableSiteMeshFilter() {
            @Override
            protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
                builder.setDecoratorPrefix("")
                       .addExcludedPath("/ping")
                       .addExcludedPath("/ping/*")
                       .addExcludedPath("/diag")
                       .addExcludedPath("/diag/*")
                       .addExcludedPath("/favicon.ico")
                       .addExcludedPath("/WEB-INF/*")
                       .addExcludedPath("/api/*")
                       .addExcludedPath("/ws-utecoffe/*")
                       .addExcludedPath("/actuator/*")
                       .addExcludedPath("/swagger-ui/*")
                       .addExcludedPath("/v3/api-docs/*")
                       .addExcludedPath("/h2-console/*")
                       .addExcludedPath("/static/*")
                       .addExcludedPath("/assets/*")
                       .addExcludedPath("/css/*")
                       .addExcludedPath("/js/*")
                       .addExcludedPath("/images/*")
                       .addDecoratorPath("/admin/*", "/WEB-INF/views/layouts/admin.jsp")
                       .addDecoratorPath("/barista/*", "/WEB-INF/views/layouts/barista.jsp")
                       .addDecoratorPath("/*", "/WEB-INF/views/layouts/default.jsp");
            }
        });
        filter.addUrlPatterns("/*");
        filter.setOrder(1);
        return filter;
    }
}
