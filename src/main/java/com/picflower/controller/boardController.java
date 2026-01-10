package com.picflower.controller;

import java.io.File;
import java.security.Principal;
import java.util.ArrayList;
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
import com.picflower.dao.ImemberDAO;
import com.picflower.dao.IreplyDAO;
import com.picflower.dto.boardDTO;
import com.picflower.dto.memberDTO;
import com.picflower.dto.replyDTO;

@Controller
public class boardController {
	@Autowired
	IboardDAO dao;
	
	@Autowired
	IreplyDAO r_dao;
	
	@Autowired
    ImemberDAO memberDao;
	
	
	//후기글 조회 + 각 글의 댓글 조회
	@RequestMapping("/guest/b_list")
	public String b_list(Model model, Principal principal) {
	    // 1. 실제 로그인한 사용자 정보 가져오기
	    Integer current_m_no = null;
	    if (principal != null) {
	        memberDTO member = memberDao.findByM_id(principal.getName());
	        if (member != null) {
	            current_m_no = member.getM_no();
	        }
	    }
	    
	    List<boardDTO> boardList = dao.b_listWithMemberDao();
	    
	    for(boardDTO board : boardList) {
	        board.setReplies(r_dao.r_listByB_no(board.getB_no()));
	        
	        if (current_m_no != null) {
	            int check = dao.checkLikeDao(board.getB_no(), current_m_no);
	            board.setUserLiked(check > 0); 
	        } else {
	            board.setUserLiked(false); // 로그인 안 했으면 무조건 false
	        }
	        // 이미지 리스트 변환 로직 (기존 동일)
	        if (board.getB_image() != null && !board.getB_image().isEmpty()) {
	            String[] imgArray = board.getB_image().split(",");
	            board.setB_image_list(java.util.Arrays.asList(imgArray));
	        }
	    }

	    model.addAttribute("list", boardList);
	    return "guest/board";
	}
	
	//후기 작성
	@RequestMapping(value ="/member/b_insert", method=RequestMethod.POST)
	public String b_insert(boardDTO dto, Principal principal) { 
	    // 1. Principal이 null이면 로그인이 안 된 상태
	    if (principal == null) {
	        return "redirect:/guest/loginForm";
	    }

	    // 2. 로그인한 아이디(m_id) 가져오기
	    String m_id = principal.getName();
	    
	    // 3. DAO를 통해 아이디로 회원 정보(m_no 포함) 조회
	    // ImemberDAO에 정의된 findByM_id를 사용합니다.
	    memberDTO member = memberDao.findByM_id(m_id); 
	    
	    if (member == null) {
	        return "redirect:/guest/loginForm";
	    }

	    // 4. DTO에 실제 로그인한 사용자의 번호(m_no) 세팅
	    dto.setM_no(member.getM_no());
	    
	    // --- 파일 업로드 로직 (기존 유지) ---
	    List<MultipartFile> files = dto.getB_upload_list();
	    if (files != null && !files.isEmpty()) {
	        String uploadPath = "C:/Springboot/Picflower/src/main/resources/static/img/";
	        List<String> fileNameList = new ArrayList<>();

	        for (MultipartFile file : files) {
	            if (!file.isEmpty()) {
	                String storedFileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
	                try {
	                    file.transferTo(new File(uploadPath + storedFileName));
	                    fileNameList.add(storedFileName);
	                } catch (Exception e) { e.printStackTrace(); }
	            }
	        }
	        if(!fileNameList.isEmpty()) {
	            dto.setB_image(String.join(",", fileNameList));
	        }
	    }
	    
	    dao.b_insertDao(dto);
	    return "redirect:/guest/b_list";
	}
	
	//각 후기글 좋아요
	@RequestMapping("/member/b_like")
	@ResponseBody
	public String b_like(@RequestParam("b_no") int b_no, Principal principal) {
	    // 1. 로그인 체크 (시큐리티 설정으로 막혀있겠지만 코드에서도 보강)
	    if (principal == null) return "error:login_required";

	    memberDTO member = memberDao.findByM_id(principal.getName());
	    int m_no = member.getM_no(); 
	    
	    // 2. 해당 유저 기준 좋아요 체크
	    int check = dao.checkLikeDao(b_no, m_no); 
	    
	    if (check == 0) {
	        dao.insertLikeDao(b_no, m_no);
	        dao.upLike(b_no); 
	        return "plus:" + dao.getLikeCount(b_no);
	    } else {
	        dao.deleteLikeDao(b_no, m_no);
	        dao.downLike(b_no); 
	        return "minus:" + dao.getLikeCount(b_no);
	    }
	}
	
	//후기 수정
	@PostMapping("/member/b_update")
	@ResponseBody
	public String updateReview(boardDTO dto) {
	    try {
	        // 1. 다중 파일 리스트(b_upload_list)를 가져옵니다.
	        List<MultipartFile> files = dto.getB_upload_list();
	        
	        // 파일이 전송되었는지 확인 (리스트가 존재하고 첫 번째 파일이 비어있지 않은지)
	        if (files != null && !files.isEmpty() && !files.get(0).isEmpty()) {
	            String uploadPath = "C:/Springboot/Picflower/src/main/resources/static/img/";
	            List<String> savedFileNames = new ArrayList<>();

	            for (MultipartFile file : files) {
	                if (!file.isEmpty()) {
	                    // 고유 파일명 생성
	                    String storedFileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
	                    file.transferTo(new File(uploadPath + storedFileName));
	                    savedFileNames.add(storedFileName);
	                }
	            }
	            
	            // 2. 여러 파일명을 콤마로 합쳐서 "uuid1_a.jpg,uuid2_b.jpg" 형태로 저장
	            if (!savedFileNames.isEmpty()) {
	                dto.setB_image(String.join(",", savedFileNames));
	            }
	        }

	        // 3. DB 업데이트 실행
	        int result = dao.b_updateDao(dto); 
	        return (result > 0) ? "success" : "fail";

	    } catch (Exception e) {
	        e.printStackTrace(); // 에러 발생 시 콘솔 확인용
	        return "fail";
	    }
	}
	
	//후기 삭제
	@RequestMapping("/member/b_delete")
	public String b_delete(@RequestParam("b_no") int b_no) {
	    // 이제 dao에 updateStatusDao가 있으므로 에러가 나지 않습니다.
	    dao.updateStatusDao(b_no); 
	    return "redirect:/guest/b_list";
	}
	
	@PostMapping("/member/r_insert")
	@ResponseBody
	public replyDTO r_insert(replyDTO dto, Principal principal) {
	    // 1. 로그인 정보 처리
	    String m_id = principal.getName();
	    memberDTO member = memberDao.findByM_id(m_id);
	    
	    dto.setM_no(member.getM_no());
	    dto.setR_count(0);
	    
	    // 2. DB 저장
	    int result = r_dao.r_insertDao(dto); 
	    
	    if(result > 0) {
	        // JSP에서 사용할 작성자 ID를 DTO에 담아서 반환
	        dto.setM_id(m_id); 
	        return dto; 
	    } else {
	        return null;
	    }
	}
	
	@PostMapping("/member/r_delete")
	@ResponseBody
	public String r_delete(@RequestParam("r_no") int r_no) {
	    int result = r_dao.r_deleteDao(r_no);
	    return (result > 0) ? "success" : "fail";
	}

	@PostMapping("/member/r_update")
	@ResponseBody
	public String r_update(replyDTO dto) {
	    int result = r_dao.r_updateDao(dto);
	    return (result > 0) ? "success" : "fail";
	}
	
}	
