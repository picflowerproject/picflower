package com.picflower.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.picflower.dao.ImemberDAO;
import com.picflower.dto.memberDTO;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private ImemberDAO dao;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // 1. 시큐리티가 전달해준 username(아이디)으로 DB 조회
        memberDTO dto = dao.findByM_id(username);

        // 2. 사용자가 없으면 예외 발생 (자동으로 loginError=true 리다이렉트됨)
        if (dto == null) {
            throw new UsernameNotFoundException("아이디가 존재하지 않습니다: " + username);
        }

        // 3. 권한에 ROLE_ 접두사 처리 (예: MEMBER -> ROLE_MEMBER)
        String role = dto.getM_auth().startsWith("ROLE_") ? dto.getM_auth() : "ROLE_" + dto.getM_auth();

        // 4. 시큐리티 전용 User 객체 반환 (여기서 내부적으로 비번 비교가 일어남)
        return User.builder()
                .username(dto.getM_id())
                .password(dto.getM_pwd()) // DB에 저장된 $2a$10$...
                .authorities(role)
                .build();
    }
}