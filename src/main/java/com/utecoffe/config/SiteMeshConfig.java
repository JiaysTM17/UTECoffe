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
                builder.addExcludedPath("/api/*")
                       .addExcludedPath("/ws-utecoffe/*")
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
