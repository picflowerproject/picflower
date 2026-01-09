package com.picflower.controller;

import java.io.File;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
	
	@RequestMapping(value ="/admin/n_insert", method=RequestMethod.POST)
	public String n_insert(noticeDTO dto) { 
	    MultipartFile file = dto.getN_image(); 
	    if (file != null && !file.isEmpty()) {
	        try {
	            File folder = new File(COMMON_PATH);
	            if (!folder.exists()) folder.mkdirs();

	            String originalFileName = file.getOriginalFilename();
	            
	            // [해결 포인트] 공백은 '_'로, 괄호 등 특수문자는 제거합니다.
	            String cleanFileName = originalFileName.replaceAll("\\s", "_") // 공백을 언더바로
	                                                   .replaceAll("[() ]", ""); // 괄호 제거
	            
	            // 실제 파일 저장
	            file.transferTo(new File(folder.getAbsolutePath() + File.separator + cleanFileName));
	            
	            // DB에도 정제된 이름을 저장
	            dto.setN_image_name(cleanFileName); 
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    dao.n_insertDao(dto);
	    return "redirect:/guest/notice";
	}
	
	@RequestMapping("/guest/notice")
	public String notice(Model model, @RequestParam(value="page", defaultValue="1") int page) {
	    int size = 10; // 한 페이지에 보여줄 게시글 개수
	    
	    // 1. 전체 게시글 수 조회 (DAO에 getTotalCount() 추가 필요)
	    int totalCount = dao.getTotalCount();
	    
	    // 2. 전체 페이지 수 계산
	    int totalPages = (int) Math.ceil((double) totalCount / size);
	    
	    // 3. DB에서 가져올 시작 위치(offset) 계산
	    int offset = (page - 1) * size;
	    
	    // 4. 데이터 조회 (기존 n_listDao 대신 페이징용 n_listPagedDao 사용)
	    model.addAttribute("list", dao.n_listPagedDao(offset, size));
	    
	    // 5. 페이지네이션 UI에 필요한 정보 전달
	    model.addAttribute("currentPage", page);
	    model.addAttribute("totalPages", totalPages);
	    
	    return "guest/notice";
	}
	
	@RequestMapping(value = "/admin/n_update", method = RequestMethod.POST)
	public String n_update(noticeDTO dto) {
	    MultipartFile file = dto.getN_image();
	    if (file != null && !file.isEmpty()) {
	        try {
	            String originalFileName = file.getOriginalFilename();
	            // [추가] 수정 시에도 공백과 특수문자 제거
	            String cleanFileName = originalFileName.replaceAll("\\s", "_").replaceAll("[() ]", "");
	            
	            file.transferTo(new File(new File(COMMON_PATH).getAbsolutePath() + File.separator + cleanFileName));
	            dto.setN_image_name(cleanFileName); 
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    dao.n_updateDao(dto);
	    
	    return "redirect:/guest/notice#notice_" + dto.getN_no();
	}
	
	@RequestMapping("/admin/n_delete")
		public String n_delete(@RequestParam("n_no") int n_no) {
			dao.n_deleteDao(n_no);
			return "redirect:/guest/notice";
		}

	
}
