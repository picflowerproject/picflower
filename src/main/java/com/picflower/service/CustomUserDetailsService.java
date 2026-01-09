package com.picflower.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.picflower.dao.ImemberDAO;
import com.picflower.dto.memberDTO;

@Service
public class CustomUserDetailsService implements UserDetailsService {
	@Autowired
    private ImemberDAO dao;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        memberDTO dto = dao.findByM_id(username);
        if (dto == null) {
            throw new UsernameNotFoundException("사용자 없음");
        }

        return User.builder()
                .username(dto.getM_id())
                .password(dto.getM_pwd())
                .roles(dto.getM_auth()) // DB에 'USER' 또는 'ADMIN'
                .build();
    }
}