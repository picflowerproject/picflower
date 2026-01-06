package com.picflower.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.picflower.dao.InoticeDAO;
import com.picflower.dto.NoticeDTO;

@Controller
public class NoticeController {
	@Autowired
	InoticeDAO dao;
	
	
	
	@RequestMapping("/n_insertForm")
	public String n_insertForm() {
		return "n_insertForm";
	}
	
	@RequestMapping("/n_insert")
	public String n_insert(NoticeDTO dto) {
		if (dto.getN_image() != null && !dto.getN_image().isEmpty()) {
	        String fileName = dto.getN_image().getOriginalFilename();
	        // 2. 중요: DTO의 n_image_name 필드에 추출한 이름을 담음
	        dto.setN_image_name(fileName); 
	    }
	    
	    // 3. DB 저장 실행
	    dao.n_insertDao(dto);
		return "redirect:/notice";
	}
	
	@RequestMapping("/notice")
	public String notice(Model model) {
		model.addAttribute("list", dao.n_listDao());
		return "notice";
	}
}
