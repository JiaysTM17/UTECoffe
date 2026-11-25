package com.utecoffe.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private JwtAuthenticationFilter jwtAuthenticationFilter;


    @Bean
    public org.springframework.security.web.firewall.HttpFirewall httpFirewall() {
        org.springframework.security.web.firewall.StrictHttpFirewall firewall = new org.springframework.security.web.firewall.StrictHttpFirewall();
        firewall.setAllowUrlEncodedSlash(true);
        firewall.setAllowUrlEncodedDoubleSlash(true);
        firewall.setAllowUrlEncodedPercent(true);
        firewall.setAllowBackSlash(true);
        firewall.setAllowUrlEncodedPeriod(true);
        return firewall;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(Arrays.asList(
            "https://utecoffe.io.vn",
            "https://www.utecoffe.io.vn",
            "http://utecoffe.io.vn",
            "http://www.utecoffe.io.vn",
            "http://localhost:8080",
            "http://127.0.0.1:8080"
        ));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"));
        configuration.setAllowedHeaders(Arrays.asList("*"));
        configuration.setAllowCredentials(true);
        configuration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    // 1. REST API Security (Stateless JWT Filter for /api/**)
    @Bean
    @Order(1)
    public SecurityFilterChain apiSecurityFilterChain(HttpSecurity http) throws Exception {
        http
            .securityMatcher("/api/**")
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .csrf(csrf -> csrf.disable())
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/auth/**").permitAll()
                .requestMatchers("/api/products/**", "/api/categories/**", "/api/stores/**", "/api/orders/**", "/api/payments/**", "/api/kds/**", "/api/inventory/**", "/api/reservations/**", "/api/v1/algorithms/**").permitAll()
                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                .requestMatchers("/api/barista/**").hasAnyRole("BARISTA", "STORE_MANAGER", "ADMIN")
                .anyRequest().authenticated()
            )
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    // 2. Web MVC Security (Session-based Cookie Auth for Storefront, Admin & Barista KDS)
    @Bean
    @Order(2)
    public SecurityFilterChain webSecurityFilterChain(HttpSecurity http) throws Exception {
        http
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .csrf(csrf -> csrf.ignoringRequestMatchers("/ws-utecoffe/**", "/h2-console/**", "/auth/login-process", "/barista/orders/**", "/admin/**", "/cart/**", "/checkout/**", "/reservation/**"))
            .headers(headers -> headers.frameOptions(frame -> frame.sameOrigin()))
            .authorizeHttpRequests(auth -> auth
                // Static resources
                .requestMatchers("/actuator/health", "/actuator/info").permitAll()
                .requestMatchers("/h2-console/**").permitAll()
                .requestMatchers("/swagger-ui/**", "/swagger-ui.html", "/v3/api-docs/**").permitAll()
                .requestMatchers("/static/**", "/assets/**", "/css/**", "/js/**", "/images/**", "/favicon.ico", "/robots.txt", "/sitemap.xml").permitAll()
                // Public storefront pages
                .requestMatchers("/", "/ping", "/diag", "/menu/**", "/stores/**", "/story/**", "/reservation/**", "/cart/**", "/checkout/**", "/orders/tracking/**").permitAll()
                .requestMatchers("/auth/**").permitAll()
                .requestMatchers("/ws-utecoffe/**").permitAll()
                // Role-restricted areas
                .requestMatchers("/admin/**").hasAnyRole("ADMIN", "STORE_MANAGER")
                .requestMatchers("/barista/**").hasAnyRole("BARISTA", "STORE_MANAGER", "ADMIN")
                .requestMatchers("/profile/**", "/orders/my-orders/**").authenticated()
                .anyRequest().permitAll()
            )
            .formLogin(form -> form
                .loginPage("/auth/login")
                .loginProcessingUrl("/auth/login-process")
                .defaultSuccessUrl("/", false)
                .failureUrl("/auth/login?error=true")
                .permitAll()
            )
            .logout(logout -> logout
                .logoutUrl("/auth/logout")
                .logoutSuccessUrl("/auth/login?logout=true")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .permitAll()
            );

        return http.build();
    }
}
