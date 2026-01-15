package com.picflower.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.picflower.dao.ImemberDAO;
import com.picflower.dao.IorderDAO;
import com.picflower.dto.memberDTO;
import com.picflower.dto.orderRequestDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class memberController {
	@Autowired
	ImemberDAO dao;
	
	@Autowired private PasswordEncoder passwordEncoder;
	
	@RequestMapping("/")
	public String root() {
		return "redirect:/home";
	}
	
	@RequestMapping("/home")
	public String home(@AuthenticationPrincipal Object principal, Model model, HttpSession session) {
	    if (principal instanceof OAuth2User) {
	        OAuth2User oauth2User = (OAuth2User) principal;
	        
	        String kakaoId = oauth2User.getAttribute("id").toString(); 
	        Map<String, Object> properties = (Map<String, Object>) oauth2User.getAttributes().get("properties");
	        String nickname = (String) properties.get("nickname");

	        memberDTO dto = dao.findByM_id(kakaoId);

	        if (dto == null) {
	            dto = new memberDTO();
	            dto.setM_id(kakaoId);
	            dto.setM_name(nickname);
	            dto.setM_pwd(passwordEncoder.encode("kakao_user_" + kakaoId));
	            
	            // 필수값(NOT NULL) 에러 방지를 위해 기본값 세팅
	            dto.setM_gender("N");        // 미선택
	            dto.setM_tel("010-0000-0000"); // 임시 번호
	            dto.setM_birth("1900-01-01");
	            dto.setM_addr(" ");
	            dto.setM_flower("없음");
	            dto.setM_email("kakao@user.com");
	            dto.setM_auth("MEMBER");  // 시큐리티 권한 (WebSecurityConfig와 맞출 것)
	            
	            dao.memberWriteDao(dto);
	            // 가입 후 다시 조회하여 m_no 등 자동 생성된 값을 포함한 완전한 객체 확보
	            dto = dao.findByM_id(kakaoId);
	         // 가입 즉시 수정 페이지로 보내려면 여기서 리다이렉트
	        }
	        
	     // 2. 권한 강제 갱신 (리다이렉트보다 먼저 실행되어야 함!)
	        String role = dto.getM_auth().startsWith("ROLE_") ? dto.getM_auth() : "ROLE_" + dto.getM_auth();
	        List<GrantedAuthority> authorities = AuthorityUtils.createAuthorityList(role);
	        
	        // OAuth2User 타입을 유지해야 403 에러가 발생하지 않음
	        Authentication newAuth = new OAuth2AuthenticationToken(oauth2User, authorities, "kakao");
	        SecurityContextHolder.getContext().setAuthentication(newAuth);
	        
	        // 세션에 정보 저장
	        session.setAttribute("m_id", dto.getM_id());
	        session.setAttribute("m_name", dto.getM_name());
	        session.setAttribute("m_auth", dto.getM_auth());
	        session.setAttribute("SPRING_SECURITY_CONTEXT", SecurityContextHolder.getContext());

	        // 3. 추가 정보 입력 여부 체크 (이제 권한이 갱신되었으므로 403이 나지 않음)
	        if (" ".equals(dto.getM_addr()) || "010-0000-0000".equals(dto.getM_tel())) {
	            return "redirect:/member/memberUpdateForm?m_no=" + dto.getM_no();
	        }

	        model.addAttribute("userName", nickname);

	    } else if (principal instanceof UserDetails) {
	        // 일반 로그인 처리
	        UserDetails userDetails = (UserDetails) principal;
	        model.addAttribute("userName", userDetails.getUsername());
	        session.setAttribute("m_id", userDetails.getUsername());
	    }
	    
	    return "home";
	}
	
	@RequestMapping("/guest/loginForm")
	public String loginForm() {
		return "guest/loginForm";
	}
	
	@RequestMapping("/guest/findPassword")
	public String findPasswordForm() {
	    return "guest/findPasswordForm";
	}
	
	@RequestMapping("/guest/findPasswordResult")
	public String findPasswordResult(HttpServletRequest request, Model model) {

	    String m_id = request.getParameter("m_id");
	    String m_pwd = request.getParameter("m_pwd");

	    int count = dao.checkMemberFindPasswd(m_id, m_pwd);

	    if (count > 0) {
	        model.addAttribute(
	            "message",
	            "회원 정보가 확인되었습니다.<br>아이디 : " + m_id
	        );
	    } else {
	        model.addAttribute(
	            "message",
	            "일치하는 회원 정보가 없습니다."
	        );
	    }

	    return "guest/findPasswordResult";
	}
	
	@RequestMapping("/guest/memberWriteForm")
	public String memberWriteForm() {
		return "guest/memberWriteForm";
	}
	
	 @RequestMapping("/guest/jusoPopup") // GET, POST 모두 받아야 함
	    public String jusoPopup() {
	        return "guest/jusoPopup"; // 실제 경로: /WEB-INF/views/guest/jusoPopup.jsp
	    }
	
	@RequestMapping("/guest/memberWrite")
	public String memberWrite(HttpServletRequest request, memberDTO dto) {
		String m_email1 = request.getParameter("m_email1");
		String m_email2 = request.getParameter("m_email2");
		dto.setM_email(m_email1+"@"+m_email2);
		
		String m_tel1 = request.getParameter("m_tel1");
		String m_tel2 = request.getParameter("m_tel2");
		String m_tel3 = request.getParameter("m_tel3");
		dto.setM_tel(m_tel1+"-"+m_tel2+"-"+m_tel3);
		
		// 3. [추가] 주소 합치기 (우편번호 + 기본주소 + 상세주소)
	    String m_zipcode = request.getParameter("m_zipcode"); // JSP의 name 속성과 일치해야 함
	    String m_addr_base = request.getParameter("m_addr_base");       // JSP의 name 속성과 일치해야 함
	    String m_addr_detail = request.getParameter("m_addr_detail");
	    
	    // 형식 예: [12345] 서울시 강남구 테헤란로 123 4층
	    String fullAddr = "[" + m_zipcode + "] " + m_addr_base + "," + m_addr_detail;
	    dto.setM_addr(fullAddr);
		
		String encodedPassword = passwordEncoder.encode(dto.getM_pwd());
		dto.setM_pwd(encodedPassword);
		
		dao.memberWriteDao(dto); 
		
		return "redirect:/home";
	}
	
	@RequestMapping("/admin/memberList") 
	public String memberList(Model model) {
		model.addAttribute("list", dao.memberListDao());
		
		return "admin/memberList"; 
	}
	
	
	@Autowired
	IorderDAO orderDao; 
	
	@RequestMapping("/member/memberDetail") 
	public String memberDetail(HttpServletRequest request, Model model) {
	    int m_no = Integer.parseInt(request.getParameter("m_no"));
	    
	    // 1. 회원 정보 조회
	    model.addAttribute("detail", dao.memberViewDao(m_no));
	    
	    // 2. 주문 내역 조회 (IorderDAO의 selectMyOrderList 사용)
	    // 2026년 표준에 따라 m_no를 파라미터로 넘겨 해당 회원의 내역만 가져옵니다.
	    List<orderRequestDTO> orderList = orderDao.selectMyOrderList(m_no);
	    model.addAttribute("orderList", orderList);
	    
	    return "member/memberDetail"; 
	}
	
	@GetMapping("/member/memberDetailId")
	public String memberDetail(Principal principal, Model model) {
	    if (principal == null) return "redirect:/guest/loginForm";

	    // 1. principal.getName()은 일반 로그인은 아이디, 카카오는 고유번호를 반환함
	    String loginId = principal.getName(); 
	    System.out.println("로그인 아이디: " + loginId);
	    
	    // 2. DB에서 회원 정보 조회 (카카오 ID도 m_id 컬럼에 저장되어 있음)
	    memberDTO detail = dao.findByM_id(loginId);
	    
	    if (detail != null) {
	        model.addAttribute("detail", detail);
	        
	        // 3. m_no를 사용하여 주문 내역 조회
	        int m_no = detail.getM_no();
	        List<orderRequestDTO> orderList = orderDao.selectMyOrderList(m_no);
	        model.addAttribute("orderList", orderList);
	    } else {
	        // 혹시라도 DB에 정보가 없으면 가입 유도
	        return "redirect:/guest/loginForm";
	    }

	    return "member/memberDetail"; 
	}
	
	@PostMapping("/member/checkPassword")
	@ResponseBody
	public Map<String, Object> checkPassword(@RequestParam("m_pwd") String inputPw, HttpSession session) {
	    Map<String, Object> response = new HashMap<>();
	    
	    // Principal 매개변수 대신 SecurityContext에서 직접 추출 (에러 방지)
	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    
	    if (auth == null || !auth.isAuthenticated()) {
	        response.put("success", false);
	        return response;
	    }
	    
	 // 1. 카카오 로그인 유저인지 확인
	    if (auth.getPrincipal() instanceof OAuth2User) {
	        // 카카오 유저는 비밀번호 확인 절차 없이 즉시 성공 처리
	        response.put("success", true);
	        response.put("isSocial", true); // 프론트에서 알림창 띄울 때 활용 가능
	        session.setAttribute("pwVerified", true);
	        return response;
	    }
	    
	    String loginId = auth.getName(); 
	    memberDTO member = dao.findByM_id(loginId);
	    
	    if (member != null && passwordEncoder.matches(inputPw, member.getM_pwd())) {
	        response.put("success", true);
	        session.setAttribute("pwVerified", true);
	    } else {
	        response.put("success", false);
	    }
	    
	    return response;
	}

	@PostMapping("/member/updatePwOnly")
	@ResponseBody
	public Map<String, Object> updatePwOnly(@RequestParam("m_pwd") String newPw, 
	                                        @RequestParam("m_no") int m_no) {
	    Map<String, Object> response = new HashMap<>();
	    
	    // 1. 새 비밀번호 암호화
	    String encodedPw = passwordEncoder.encode(newPw);
	    
	    // 2. DB 업데이트 (dao에 해당 기능을 수행하는 메서드 필요)
	    // 예: dao.updatePassword(m_no, encodedPw);
	    int result = dao.updatePassword(m_no, encodedPw); 
	    
	    if(result > 0) {
	        response.put("success", true);
	    } else {
	        response.put("success", false);
	    }
	    
	    return response;
	}
	
	@RequestMapping("/member/memberUpdateForm")
	public String memberUpdateForm(HttpSession session, HttpServletRequest request, Model model, Authentication auth) {
	    // 1. 접근 권한 확인 (소셜 로그인 유저거나 비밀번호 검증을 마친 일반 유저여야 함)
	    Boolean isVerified = (Boolean) session.getAttribute("pwVerified");
	    boolean isSocialUser = auth.getPrincipal() instanceof OAuth2User;

	    // 소셜 유저도 아니고 비밀번호 확인도 안 됐다면 차단
	    if (!isSocialUser && (isVerified == null || !isVerified)) {
	        String m_no = request.getParameter("m_no");
	        return "redirect:/member/memberDetailId"; // ID 기반 상세페이지로 유도
	    }
	    
	    // 일반 유저인 경우에만 1회성 세션 제거
	    if (!isSocialUser) {
	        session.removeAttribute("pwVerified");
	    }

	    // 2. 데이터 조회 및 파싱 (기존 로직 유지)
	    int m_no = Integer.parseInt(request.getParameter("m_no"));
	    memberDTO dto = dao.memberViewDao(m_no);
	    
	    if (dto != null && dto.getM_addr() != null && dto.getM_addr().contains("]")) {
	        try {
	            String fullAddr = dto.getM_addr();
	            String zipcode = fullAddr.substring(1, fullAddr.indexOf("]"));
	            String addrPart = fullAddr.substring(fullAddr.indexOf("]") + 2);
	            
	            if (addrPart.contains(",")) {
	                String[] addrSplit = addrPart.split(",", 2); 
	                model.addAttribute("zipcode", zipcode);
	                model.addAttribute("address", addrSplit[0].trim());
	                if (addrSplit.length > 1) {
	                    model.addAttribute("addrDetail", addrSplit[1].trim()); 
	                }
	            } else {
	                model.addAttribute("zipcode", zipcode);
	                model.addAttribute("address", addrPart.trim());
	            }
	        } catch (Exception e) {
	            // 주소 형식이 [우편번호] 주소 형태가 아닐 경우의 예외 처리
	            model.addAttribute("address", dto.getM_addr());
	        }
	    }

	    model.addAttribute("edit", dto);
	    return "member/memberUpdateForm"; 
	}
	
	@RequestMapping("/member/memberUpdate")
	public String memberUpdate(HttpServletRequest request, memberDTO dto) {
		String m_email1 = request.getParameter("m_email1");
		String m_email2 = request.getParameter("m_email2");
		dto.setM_email(m_email1+"@"+m_email2);
		
		String m_tel1 = request.getParameter("m_tel1");
		String m_tel2 = request.getParameter("m_tel2");
		String m_tel3 = request.getParameter("m_tel3");
		dto.setM_tel(m_tel1+"-"+m_tel2+"-"+m_tel3);
		
		// 3. 주소 합치기 (회원가입 로직과 동일하게 적용)
	    String m_zipcode = request.getParameter("m_zipcode"); 
	    String m_addr_base = request.getParameter("m_addr_base"); 
	    String m_addr_detail = request.getParameter("m_addr_detail");
	    
	    if (m_zipcode != null && !m_zipcode.isEmpty()) {
	        String fullAddr = "[" + m_zipcode + "] " + m_addr_base + "," + (m_addr_detail != null ? m_addr_detail : "");
	        dto.setM_addr(fullAddr.trim());
	    }
	    
		dao.memberUpdateDao(dto); 
		
	    // [중요] 수정 후에도 세션에 바뀐 정보를 갱신해줘야 합니다.
	    HttpSession session = request.getSession();
	    session.setAttribute("m_name", dto.getM_name());
	    
		
		
		 return "redirect:/home";
	}
	
	@RequestMapping("/member/memberDelete")
	public String memberDelete(HttpServletRequest request) {
		int m_no = Integer.parseInt(request.getParameter("m_no"));
		dao.memberDeleteDao(m_no);
		return "redirect:/home";
	}
	
	@RequestMapping("/member/deleteMembers") // JSP의 form action과 맞춤
	   public String deleteMembers(HttpServletRequest request) {
	       // name="m_nos"로 전송된 모든 체크박스 값을 배열로 받음
	       String[] m_nos = request.getParameterValues("m_nos");
	       
	       if (m_nos != null) {
	           for (String m_no_str : m_nos) {
	               int m_no = Integer.parseInt(m_no_str);
	               // 기존에 만드신 단일 삭제 DAO를 반복문으로 호출
	               dao.memberDeleteDao(m_no);
	           }
	       }
	       
	       return "redirect:/admin/memberList"; // 삭제 후 목록으로 이동
	}
}
