package com.picflower.auth;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.http.HttpSession;

@Configuration
public class WebSecurityConfig {
	@Bean
	public WebSecurityCustomizer webSecurityCustomizer() {
	    return (web) -> web.ignoring()
	        .requestMatchers("/css/**", "/js/**", "/img/**", "/assets/**", "/product_img/**", "/favicon.ico", "/error", "/summernote/**");
	}
	
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
   
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.csrf((csrf) -> csrf.disable())
            .cors((cors) -> cors.disable())
            .authorizeHttpRequests(request -> request
                // 1. 카카오 로그인 관련 경로를 명시적으로 허용 (매우 중요)
                .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.INCLUDE, DispatcherType.ERROR).permitAll()
                .requestMatchers("/login/oauth2/**", "/oauth2/**").permitAll() 
                .requestMatchers("/", "/home", "/guest/**", "/productSearch", "/guest/productSearch").permitAll()
                .requestMatchers("/api/chat/**").permitAll() // 챗봇 API 허용.
                .requestMatchers("/qna/**").hasAnyRole("MEMBER", "ADMIN")
                .requestMatchers("/css/**", "/js/**", "/img/**", "/assets/**", "/product_img/**", "/flower_img/**").permitAll()
                .requestMatchers("/admin/**").hasRole("ADMIN")
                .requestMatchers("/member/**").hasAnyAuthority("ROLE_MEMBER", "ROLE_ADMIN", "OAUTH2_USER")
                .anyRequest().authenticated()
            );

        // 폼 로그인
        http.formLogin((formLogin) -> formLogin
                .loginPage("/home")
                .loginProcessingUrl("/login") 
                .usernameParameter("username")
                .passwordParameter("password")
                .defaultSuccessUrl("/", true)
                .failureUrl("/home?loginError=true")
                .permitAll()
        );

     // OAuth2 로그인 (카카오)
        http.oauth2Login((oauth2) -> oauth2
            .loginPage("/home")
            .successHandler((request, response, authentication) -> {
                HttpSession session = request.getSession(true);
                
                Boolean isUpdateMode = (Boolean) session.getAttribute("isUpdateMode");
                
                if (Boolean.TRUE.equals(isUpdateMode)) {
                    session.setAttribute("pwVerified", true);
                    session.removeAttribute("isUpdateMode");
                    response.sendRedirect(request.getContextPath() + "/member/memberUpdateForm");
                } else {
                    session.removeAttribute("loginError");
                    response.sendRedirect(request.getContextPath() + "/home");
                }
            })
        );

        http.sessionManagement(session -> session
        		.sessionFixation().migrateSession() 
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