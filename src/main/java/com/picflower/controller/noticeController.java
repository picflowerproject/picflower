package com.picflower.controller;

import java.io.File;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.picflower.dao.InoticeDAO;
import com.picflower.dto.noticeDTO;

@Controller
public class noticeController {
	@Autowired
	InoticeDAO dao;
	
	private static final String COMMON_PATH = "src/main/resources/static/img/";
	
	@RequestMapping("/admin/n_insertForm")
	public String n_insertForm() {
		return "admin/n_insertForm";
	}
	
	   // 1. 공지 등록 (이미지 처리 로직 제거)
    @RequestMapping(value ="/admin/n_insert", method=RequestMethod.POST)
    public String n_insert(noticeDTO dto) { 
        // 에디터 본문(n_text)에 이미지가 Base64로 포함되어 들어오므로
        // MultipartFile 처리 없이 바로 DAO를 호출합니다.
        dao.n_insertDao(dto);
        return "redirect:/guest/notice";
    }
	
    @RequestMapping("/guest/notice")
    public String notice(Model model, @RequestParam(value="page", defaultValue="1") int page) {
        int size = 10;
        int totalCount = dao.getTotalCount();
        int totalPages = (int) Math.ceil((double) totalCount / size);
        int offset = (page - 1) * size;
        
        model.addAttribute("list", dao.n_listPagedDao(offset, size));
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        
        return "guest/notice";
    }
	 // 2. 공지 수정 (이미지 처리 로직 제거)
    @RequestMapping(value = "/admin/n_update", method = RequestMethod.POST)
    public String n_update(noticeDTO dto) {
        // 기존의 MultipartFile 처리 코드를 모두 삭제했습니다.
        dao.n_updateDao(dto);
        return "redirect:/guest/notice#notice_" + dto.getN_no();
    }
	
	@RequestMapping("/admin/n_delete")
		public String n_delete(@RequestParam("n_no") int n_no) {
			dao.n_deleteDao(n_no);
			return "redirect:/guest/notice";
		}
	
	@GetMapping("/guest/terms")
	public String terms() {
	    return "guest/termsOfUse"; // WEB-INF/views/guest/terms.jsp로 연결
	}
	
	   @RequestMapping("/guest/termsOfUse")
	   public String termsOfUse() {
	      return "guest/termsOfUse";
	   }
	   
	   
	   @RequestMapping("/guest/servicePolicy")
	   public String servicePolicy() {
	      return "guest/servicePolicy";
	   }
	   
	   @RequestMapping("/guest/index")
	   public String index() {
	      return "guest/index";
	   }

}
