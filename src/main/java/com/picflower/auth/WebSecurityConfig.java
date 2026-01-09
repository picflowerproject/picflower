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
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception{
		http.csrf((csrf) -> csrf.disable()) // CSRF 보호 비활성화
			.cors((cors) -> cors.disable()) // CORS 비활성화
			.authorizeHttpRequests(request -> request
					.dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll() // 내부 포워드 요청 허용
					.requestMatchers("/","/home","/loginForm").permitAll() // 루트(/)는 모두 허용
					.requestMatchers("/css/**","/js/**","/img/**","/assets/**").permitAll() // 정적 리소스 모두 허용
					.requestMatchers("/","/guest/**","/guest/loginForm","/guest/memberWriteForm").permitAll() // guest 폴더는 모두 허용 (게스트 페이지)
					.requestMatchers("/admin/**").hasRole("ADMIN") // admin 폴더는 ADMIN만 허용 (관리자 페이지)
					.requestMatchers("/member/**").hasAnyRole("MEMBER","ADMIN") // MEMBER 폴더는 USER, ADMIN만 허용 (회원 페이지)
					.requestMatchers("/common/**").authenticated() 
					.anyRequest().authenticated() // 나머지는 모두 인증 필요
			);
		
		//로그인
		http.formLogin((formLogin) -> formLogin
				.loginPage("/guest/loginForm") // 기본값 : /login
				.loginProcessingUrl("/j_spring_security_check")
				.usernameParameter("j_username")
				.passwordParameter("j_password")
				.defaultSuccessUrl("/",true)
				.failureUrl("/loginForm?error") // 기본값: /login?error
				.permitAll()
				);
		
		//로그아웃
		http.logout((logout) -> logout
				.logoutUrl("/logout")
				.logoutSuccessUrl("/home")
				.permitAll()
				);
		
		return http.build();
	}
}

