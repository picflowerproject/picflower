package com.picflower.service;

import java.io.IOException;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class MyAuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {
    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, 
                                        Authentication authentication) throws IOException, ServletException {
        
        HttpSession session = request.getSession();
        
        // 1. 세션에서 '수정 모드' 플래그 확인
        Boolean isUpdateMode = (Boolean) session.getAttribute("isUpdateMode");
        
        if (Boolean.TRUE.equals(isUpdateMode)) {
            // [A] 정보 수정을 위해 버튼을 누르고 재인증한 경우
            session.setAttribute("pwVerified", true); // 수정 폼 접근 권한 부여
            session.removeAttribute("isUpdateMode");  // 사용한 플래그 삭제
            response.sendRedirect("/member/memberUpdateForm"); 
        } else {
            // [B] 그냥 로그인을 한 경우 (이 부분이 누락되어 계속 수정폼으로 가는 것임)
            // home 컨트롤러로 보내서 가입 여부 등을 체크하게 함
            response.sendRedirect("/home"); 
        }
    }
}