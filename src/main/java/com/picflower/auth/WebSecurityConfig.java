package com.picflower.auth;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import jakarta.servlet.DispatcherType;

@Configuration
public class WebSecurityConfig {
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.csrf((csrf) -> csrf.disable())
            .cors((cors) -> cors.disable())
            .authorizeHttpRequests(request -> request
                .dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()
                // 1. 카카오 로그인 관련 경로를 명시적으로 허용 (매우 중요)
                .requestMatchers("/login/oauth2/**", "/oauth2/**").permitAll() 
                .requestMatchers("/", "/home", "/guest/**").permitAll()
                .requestMatchers("/api/chat/**").permitAll() // 챗봇 API 허용
                .requestMatchers("/css/**", "/js/**", "/img/**", "/assets/**", "/product_img/**", "/flower_img/**").permitAll()
                .requestMatchers("/admin/**").hasRole("ADMIN")
                .requestMatchers("/member/**").hasAnyAuthority("MEMBER", "ADMIN")
                .anyRequest().authenticated()
            );

        // 폼 로그인
        http.formLogin((formLogin) -> formLogin
                .loginPage("/guest/loginForm")
                .loginProcessingUrl("/j_spring_security_check")
                .usernameParameter("j_username")
                .passwordParameter("j_password")
                .defaultSuccessUrl("/", true)
                .failureUrl("/guest/loginForm?error") // 경로 수정
                .permitAll()
        );

        // OAuth2 로그인 (카카오)
        http.oauth2Login((oauth2) -> oauth2
                .loginPage("/guest/loginForm")
                .defaultSuccessUrl("/", true)
                .permitAll()
        );

        // 로그아웃
        http.logout((logout) -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/home")
                .permitAll()
        );

        return http.build();
    }
}