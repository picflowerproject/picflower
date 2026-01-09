package com.picflower.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.picflower.dao.ImemberDAO;
import com.picflower.dto.memberDTO;

import jakarta.servlet.http.HttpServletRequest;

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
	
	@RequestMapping("/guest/loginPopup")
	public String loginPopup() {
		return "guest/loginPopup";
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
	
	@RequestMapping("/guest/memberWrite")
	public String memberWrite(HttpServletRequest request, memberDTO dto) {
		String m_email1 = request.getParameter("m_email1");
		String m_email2 = request.getParameter("m_email2");
		dto.setM_email(m_email1+"@"+m_email2);
		
		String m_tel1 = request.getParameter("m_tel1");
		String m_tel2 = request.getParameter("m_tel2");
		String m_tel3 = request.getParameter("m_tel3");
		dto.setM_tel(m_tel1+"-"+m_tel2+"-"+m_tel3);
		
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
	
	@RequestMapping("/member/memberDetail") 
	public String memberDetail(HttpServletRequest request, Model model) {
		int m_no = Integer.parseInt(request.getParameter("m_no"));
		model.addAttribute("detail", dao.memberViewDao(m_no));
		return "member/memberDetail"; 
	}
	
	@RequestMapping("/member/memberUpdateForm")
	public String memberUpdateForm(Model model, HttpServletRequest request) {
		int m_no = Integer.parseInt(request.getParameter("m_no"));
		model.addAttribute("edit", dao.memberViewDao(m_no));
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
		
		String encodedPassword = passwordEncoder.encode(dto.getM_pwd());
		dto.setM_pwd(encodedPassword);
		
		dao.memberUpdateDao(dto); 
		
		return "redirect:/home";
	}
	
	@RequestMapping("/member/memberDelete")
	public String memberDelete(HttpServletRequest request) {
		int m_no = Integer.parseInt(request.getParameter("m_no"));
		dao.memberDeleteDao(m_no);
		return "redirect:/home";
	}
}
