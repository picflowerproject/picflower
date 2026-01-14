package com.picflower.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
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
	public String home() {
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
	public String memberDetail(@RequestParam(value="m_id", required=false) String m_id, Principal principal, Model model) {
	    System.out.println("=== 요청된 m_id 파라미터: " + m_id + " ===");
	    System.out.println("=== 접속한 사용자(Principal): " + (principal != null ? principal.getName() : "비로그인") + " ===");
	    // 1. 세션에서 로그인한 사용자의 아이디를 가져옵니다.
	    String loginId = principal.getName(); 
	    
	    // 2. 위에서 정의한 loginId 변수를 사용하여 DB에서 정보를 조회합니다.
	    // (기존 m_id에서 loginId로 변경)
	    memberDTO detail = dao.findByM_id(loginId);
	    
	    // 3. 모델에 회원 정보 담기
	    model.addAttribute("detail", detail);
	    
	    // 4. 찾아낸 회원 정보에서 m_no를 꺼내 주문 내역을 조회함
	    if (detail != null) {
	        int m_no = detail.getM_no();
	        List<orderRequestDTO> orderList = orderDao.selectMyOrderList(m_no);
	        model.addAttribute("orderList", orderList);
	    }
	    
	    
	    if (detail != null) {
	        int m_no = detail.getM_no();
	        List<orderRequestDTO> orderList = orderDao.selectMyOrderList(m_no);
	        System.out.println("주문 내역 개수: " + (orderList != null ? orderList.size() : "null")); // 로그 확인
	        model.addAttribute("orderList", orderList);
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
	public String memberUpdateForm(HttpSession session, HttpServletRequest request, Model model) {
	    // 2. 매개변수 순서를 HttpSession, HttpServletRequest, Model 순으로 배치 (권장)
	    
	    Boolean isVerified = (Boolean) session.getAttribute("pwVerified");
	    if (isVerified == null || !isVerified) {
	        String m_no = request.getParameter("m_no");
	        return "redirect:/member/memberDetail?m_no=" + m_no;
	    }
	    session.removeAttribute("pwVerified");

	    int m_no = Integer.parseInt(request.getParameter("m_no"));
	    memberDTO dto = dao.memberViewDao(m_no);
	    
	    if (dto != null && dto.getM_addr() != null && dto.getM_addr().contains("]")) {
	        String fullAddr = dto.getM_addr();
	        String zipcode = fullAddr.substring(1, fullAddr.indexOf("]"));
	        String addrPart = fullAddr.substring(fullAddr.indexOf("]") + 2);
	        
	        if (addrPart.contains(",")) {
	            // 콤마를 기준으로 최대 2개까지만 나눕니다. (상세주소 안에 또 콤마가 있을 수 있으므로)
	            String[] addrSplit = addrPart.split(",", 2); 
	            
	            model.addAttribute("zipcode", zipcode);
	            model.addAttribute("address", addrSplit[0].trim()); // 기본주소
	            
	            if (addrSplit.length > 1) {
	                // JSP에서 ${addrDetail}로 쓰기로 했다면 이 이름을 유지하고, 
	                // 만약 JSP input의 value가 ${detail}이라면 아래 이름을 detail로 바꾸세요.
	                model.addAttribute("addrDetail", addrSplit[1].trim()); 
	            }
	        } else {
	            model.addAttribute("zipcode", zipcode);
	            model.addAttribute("address", addrPart.trim());
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
		
		 return "redirect:/member/memberDetail?m_no=" + dto.getM_no();
	}
	
	@RequestMapping("/member/memberDelete")
	public String memberDelete(HttpServletRequest request) {
		int m_no = Integer.parseInt(request.getParameter("m_no"));
		dao.memberDeleteDao(m_no);
		return "redirect:/home";
	}
}
