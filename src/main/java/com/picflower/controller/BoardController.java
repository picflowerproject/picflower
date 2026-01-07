package com.picflower.controller;

import java.io.File;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.picflower.dao.IboardDAO;
import com.picflower.dao.IreplyDAO;
import com.picflower.dto.BoardDTO;
import com.picflower.dto.ReplyDTO;

@Controller
public class BoardController {
	@Autowired
	IboardDAO dao;
	
	@Autowired
	IreplyDAO r_dao;
	
	
	//후기글 조회 + 각 글의 댓글 조회
	@RequestMapping("/b_list")
	public String b_list(Model model) {
		//게시글 리스트 가져오기
		List<BoardDTO> boardList = dao.b_listWithMemberDao();
		
		//각 게시글에 해당하는 댓글의 리스트 가져오기
		for(BoardDTO board : boardList) {
			List<ReplyDTO> replyList = r_dao.r_listByB_no(board.getB_no());
	        board.setReplies(replyList);
		}

		model.addAttribute("list", boardList);
		return "board";
	}
	
	//후기 작성
	@RequestMapping(value ="/b_insert", method=RequestMethod.POST)
	public String b_insert(BoardDTO dto) { 
		dto.setM_no(1004);
	    MultipartFile file = dto.getB_image(); // DTO에서 MultipartFile 객체 가져오기

	    if (file != null && !file.isEmpty()) {
	        try {
	            String uploadPath = "C:/Springboot/Picflower/src/main/resources/static/img/"; // 실제 경로
	            File folder = new File(uploadPath);
	            if (!folder.exists()) folder.mkdirs();

	            String originalFileName = file.getOriginalFilename();
				String storedFileName = UUID.randomUUID().toString() + "_" + originalFileName;
	            
	            File saveFile = new File(uploadPath + storedFileName);
	            file.transferTo(saveFile);
	            
	            // DB 컬럼명과 매핑될 b_image_name 필드에 고유한 파일 이름 세팅
	            dto.setB_image_name(storedFileName); 
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    
	    dao.b_insertDao(dto);
	    return "redirect:b_list";
	}
	
	//각 후기글 좋아요
	@RequestMapping("/b_like")
	@ResponseBody
	public String b_like(@RequestParam("b_no") int b_no) {
	    System.out.println("전달받은 번호: " + b_no); // 콘솔에 찍히는지 확인
	    dao.upLike(b_no); 
	    int count = dao.getLikeCount(b_no);
	    System.out.println("갱신된 좋아요: " + count);
	    return String.valueOf(count);
	}
	
	
	//후기 수정(이후 사진 수정까지)
	@PostMapping("/b_update")
	@ResponseBody
	public String updateReview(BoardDTO dto) { // DTO로 한 번에 받기
	    int result = dao.b_updateDao(dto); 
	    if(result > 0) {
	        return "success";
	    } else {
	        return "fail";
	    }
	}
	
	//후기 삭제
	@RequestMapping("/b_delete")
	public String b_delete(@RequestParam("b_no") int b_no) {
	    dao.b_deleteDao(b_no); // MyBatis 삭제 쿼리 실행
	    return "redirect:b_list"; // 삭제 후 리스트로 새로고침 이동
	}
	
	@PostMapping("/r_insert")
	@ResponseBody
	public String r_insert(ReplyDTO dto) {
		dto.setR_count(0);
	    int result = r_dao.r_insertDao(dto); 
	    if(result > 0) {
	        return "success";
	    } else {
	        return "fail";
	    }
	}
	
	@PostMapping("/r_delete")
	@ResponseBody
	public String r_delete(@RequestParam("r_no") int r_no) {
	    int result = r_dao.r_deleteDao(r_no);
	    return (result > 0) ? "success" : "fail";
	}

	@PostMapping("/r_update")
	@ResponseBody
	public String r_update(ReplyDTO dto) {
	    int result = r_dao.r_updateDao(dto);
	    return (result > 0) ? "success" : "fail";
	}
	
}	
