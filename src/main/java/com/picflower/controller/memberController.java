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
import org.springframework.transaction.annotation.Transactional;
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
import jakarta.servlet.http.HttpServletResponse;
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
	        boolean isNewMember = false; // 최초 가입 여부 플래그

	        if (dto == null) {
	        	 isNewMember = true; 
	            dto = new memberDTO();
	            dto.setM_id(kakaoId);
	            dto.setM_name(nickname);
	            dto.setM_pwd(passwordEncoder.encode("kakao_user_" + kakaoId));
	            
	            dto.setM_gender("N");       
	            dto.setM_tel("010-0000-0000");
	            dto.setM_birth("1900-01-01");
	            dto.setM_addr(" ");
	            dto.setM_flower("없음");
	            dto.setM_email("kakao@user.com");
	            dto.setM_auth("MEMBER");
	            
	            dao.memberWriteDao(dto);
	            dto = dao.findByM_id(kakaoId);
	        }
	        
	        String role = dto.getM_auth().startsWith("ROLE_") ? dto.getM_auth() : "ROLE_" + dto.getM_auth();
	        List<GrantedAuthority> authorities = AuthorityUtils.createAuthorityList(role);
	        
	        Authentication newAuth = new OAuth2AuthenticationToken(oauth2User, authorities, "kakao");
	        SecurityContextHolder.getContext().setAuthentication(newAuth);
	        
	        session.setAttribute("m_id", dto.getM_id());
	        session.setAttribute("m_name", dto.getM_name());
	        session.setAttribute("m_auth", dto.getM_auth());
	        session.setAttribute("SPRING_SECURITY_CONTEXT", SecurityContextHolder.getContext());

	        if (isNewMember) {
	            session.setAttribute("pwVerified", true);
	            return "redirect:/member/memberUpdateForm?m_no=" + dto.getM_no();
	        }

	        model.addAttribute("userName", nickname);
	        
	    } else if (principal instanceof UserDetails) {
	        UserDetails userDetails = (UserDetails) principal;
	        model.addAttribute("userName", userDetails.getUsername());
	        session.setAttribute("m_id", userDetails.getUsername());
	    }
	    
	    return "home";
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
	
	// 아이디 중복 체크 
	@RequestMapping("/guest/idCheck")
	@ResponseBody // 데이터를 그대로 반환하기 위해 필요
	public int idCheck(@RequestParam("m_id") String m_id) {
	    // 0이면 사용 가능, 1이면 중복
	    return dao.checkIdDao(m_id); 
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
	    if (principal == null) return "redirect:/home";

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
	        return "redirect:/home";
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
	    	session.setAttribute("pwVerified", true);
	    	response.put("success", true);
	       // session.setAttribute("pwVerified", true);
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
	
	@GetMapping("/member/goSocialReauth")
	public String goSocialReauth(HttpServletRequest request) {
	    // 세션을 강제로 새로 생성하여 신선한 상태로 카카오에 보냅니다.
	    HttpSession session = request.getSession(true);
	    session.setAttribute("isUpdateMode", true);
	    return "redirect:/oauth2/authorization/kakao?prompt=login";
	}
	
	@RequestMapping("/member/memberUpdateForm")
	public String memberUpdateForm(HttpSession session, Model model, Authentication auth) {
	    // 1. 보안 세션 확인
	    Boolean isVerified = (Boolean) session.getAttribute("pwVerified");

	    if (isVerified == null || !isVerified) {
	        return "redirect:/member/memberDetailId?m_id=" + auth.getName(); 
	    }
	    
	    // 1회성 세션 즉시 파기
	    session.removeAttribute("pwVerified"); 

	    // 2. 데이터 조회
	    // [보안 강화] 파라미터(request) 대신 로그인된 인증 정보(auth)로 ID를 가져와 DB 조회
	    String loginId = auth.getName();
	    memberDTO dto = dao.findByM_id(loginId); // ID로 회원 정보를 가져오는 메서드 사용

	    if (dto == null) {
	        return "redirect:/"; // 회원이 없으면 홈으로
	    }

	    // 3. 주소 파싱 (기존 로직 유지)
	    if (dto.getM_addr() != null && dto.getM_addr().contains("]")) {
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
	            model.addAttribute("address", dto.getM_addr());
	        }
	    }

	    // 4. 연락처 파싱 (기존 로직 유지)
	    if (dto.getM_tel() != null && dto.getM_tel().contains("-")) {
	        String[] parts = dto.getM_tel().split("-");
	        if(parts.length >= 3) {
	            model.addAttribute("phone1", parts[0]);
	            model.addAttribute("phone2", parts[1]);
	            model.addAttribute("phone3", parts[2]);
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
	    
	    return "redirect:/member/memberDetail?m_no=" + dto.getM_no();
	}
	
	@RequestMapping("/member/memberDelete")
	@Transactional
	public String memberDelete(HttpServletRequest request, HttpSession session, Principal principal) {
	    // 1. 파라미터로 삭제할 번호 가져오기
	    int m_no = Integer.parseInt(request.getParameter("m_no"));
	    
	    // 2. Principal을 통해 현재 로그인한 사용자 아이디 가져오기
	    String loginId = (principal != null) ? principal.getName() : "";
	    
	    // 3. 자식 테이블 데이터 이관 및 회원 삭제 로직
	    dao.updateChildRecords(m_no);
	    dao.memberDeleteDao(m_no);
	    
	    // 4. 권한에 따른 분기 처리
	    if ("admin".equalsIgnoreCase(loginId)) {
	        // 관리자가 삭제한 경우: 세션을 유지하고 회원 리스트로 이동
	        return "redirect:/member/memberList";
	    } else {
	        // 일반 사용자가 본인 탈퇴한 경우: 세션 무효화 후 홈으로 이동
	        session.invalidate(); 
	        return "redirect:/home";
	    }
	}
	
	@RequestMapping("/member/deleteMembers") // JSP의 form action과 맞춤
	@Transactional
	   public String deleteMembers(HttpServletRequest request) {
	       // name="m_nos"로 전송된 모든 체크박스 값을 배열로 받음
	       String[] m_nos = request.getParameterValues("m_nos");
	       
	       if (m_nos != null) {
	           for (String m_no_str : m_nos) {
	               int m_no = Integer.parseInt(m_no_str);
	               
	               // 1. 해당 유저의 자식 데이터들 처리
	               dao.updateChildRecords(m_no);
	               // 기존에 만드신 단일 삭제 DAO를 반복문으로 호출
	               dao.memberDeleteDao(m_no);
	           }
	       }
	       
	       return "redirect:/admin/memberList"; // 삭제 후 목록으로 이동
	}
}
