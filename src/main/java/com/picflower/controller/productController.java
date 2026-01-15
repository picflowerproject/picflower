package com.picflower.controller;

import java.io.File;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.picflower.dao.IboardDAO;
import com.picflower.dao.IcartDAO;
import com.picflower.dao.ImemberDAO;
import com.picflower.dao.IproductDAO;
import com.picflower.dao.IreplyDAO;
import com.picflower.dto.boardDTO;
import com.picflower.dto.cartDTO;
import com.picflower.dto.memberDTO;
import com.picflower.dto.orderDetailDTO;
import com.picflower.dto.orderRequestDTO;
import com.picflower.dto.productDTO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class productController {
	@Autowired
	IproductDAO dao;
	
	@Autowired
	IboardDAO boardDao; // 후기 DAO 주입

	@Autowired
	IreplyDAO replyDao; // 댓글 DAO 주입
	
	@RequestMapping("/admin/productWriteForm") 
	public String productWriteForm() {
		return "admin/productWriteForm";
	}
	
	@RequestMapping("/admin/productWrite")
	public String productWrite(productDTO dto) throws Exception {
		 List<MultipartFile> files = dto.getP_upload();
		    String filePath = "C:\\Springboot\\Picflower\\src\\main\\resources\\static\\product_img\\";
		    
		    // 파일명들을 합쳐서 저장할 객체
		    StringBuilder fileNames = new StringBuilder();

		    if (files != null && !files.isEmpty()) {
		        for (MultipartFile file : files) {
		            if (!file.isEmpty()) {
		                String originalName = file.getOriginalFilename();
		                // 파일명 중복 방지를 위해 UUID 사용 권장
		                String saveName = System.currentTimeMillis() + "_" + originalName;
		                
		                file.transferTo(new File(filePath + saveName));
		                
		                // 파일명들을 구분자(,)로 연결
		                if (fileNames.length() > 0) fileNames.append(",");
		                fileNames.append(saveName);
		            }
		        }
		    }
		    
		    // 합쳐진 파일명 문자열을 DTO에 세팅 (DB의 f_images 컬럼에 저장됨)
		    dto.setP_image(fileNames.toString());
		
		dao.productWriteDao(dto); 
		
		return "redirect:/guest/productList";
	}
	
	@RequestMapping("/guest/productList") 
	public String productList(
	        @RequestParam(value="p_category", required=false) String p_category, 
	        @RequestParam(value="page", defaultValue="1") int page, // 추가: 기본값 1페이지
	        Model model) {
	    
	    int pageSize = 20; // 한 페이지에 보여줄 상품 개수
	    // Oracle ROWNUM 기준 시작과 끝 번호 계산
	    int start = (page - 1) * pageSize + 1;
	    int end = page * pageSize;

	    // 1. 해당 페이지의 데이터만 조회 (DAO 메서드 변경 필요)
	    List<productDTO> list = dao.productListPagedDao(p_category, start, end);
	    
	    // 2. 페이지 번호 생성을 위한 전체 개수 조회
	    int totalCount = dao.getTotalCountDao(p_category);
	    
	    // 3. 전체 페이지 수 계산 (올림 처리)
	    int totalPages = (int) Math.ceil((double) totalCount / pageSize);

	    model.addAttribute("list", list);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("totalPages", totalPages);
	    model.addAttribute("selectedCategory", p_category);
	    
	    return "guest/productList"; 
	}
	
	@RequestMapping("/guest/productDetail") 
	public String productDetail(HttpServletRequest request, Model model, Principal principal) {
	    int p_no = Integer.parseInt(request.getParameter("p_no"));
	    
	    // 1. 상품 상세 정보 가져오기
	    model.addAttribute("detail", dao.productViewDao(p_no));
	    
	    // 2. 해당 상품의 후기 리스트 가져오기 (p_no 기준)
	    List<boardDTO> boardList = boardDao.b_listByProductDao(p_no);
	    
	    // 3. 후기별 이미지 리스트화 및 로그인 유저 좋아요 체크
	    Integer current_m_no = null;
	    if (principal != null) {
	        memberDTO member = memberDao.findByM_id(principal.getName());
	        if (member != null) current_m_no = member.getM_no();
	    }
	    
	    for(boardDTO board : boardList) {
	        // 댓글 목록 가져오기
	        board.setReplies(replyDao.r_listByB_no(board.getB_no()));
	        
	        // 좋아요 체크
	        if (current_m_no != null) {
	            board.setUserLiked(boardDao.checkLikeDao(board.getB_no(), current_m_no) > 0);
	        }
	        
	        // 후기 이미지 리스트 변환 (쉼표로 구분된 문자열을 리스트로)
	        if (board.getB_image() != null && !board.getB_image().isEmpty()) {
	            String[] imgArray = board.getB_image().split(",");
	            board.setB_image_list(java.util.Arrays.asList(imgArray));
	        }
	    }
	    
	    // 4. 모델에 후기 리스트 추가
	    model.addAttribute("reviewList", boardList);
	    
	    return "guest/productDetail"; 
	}
	
	@RequestMapping("/admin/productUpdateForm")
	public String productUpdateForm(Model model, HttpServletRequest request) {
		int p_no = Integer.parseInt(request.getParameter("p_no"));
		model.addAttribute("edit", dao.productViewDao(p_no));
		return "admin/productUpdateForm";
	}
	
	@RequestMapping("/admin/productUpdate")
	public String productUpdate(productDTO dto, 
	                            @RequestParam(value="delete_images", required=false) String[] deleteImages,
	                            @RequestParam(value="all_existing_images", required=false) String[] allExistingImages) throws Exception {
	    
	    String filePath = "C:\\Springboot\\Picflower\\src\\main\\resources\\static\\product_img\\";
	    StringBuilder finalImages = new StringBuilder();
	    
	    if (allExistingImages != null) {
	        for (String exist : allExistingImages) {
	            boolean isDeleted = false;
	            if (deleteImages != null) {
	                for (String del : deleteImages) {
	                    if (exist.equals(del)) {
	                        isDeleted = true;
	                  
	                        File fileToDelete = new File(filePath + exist);
	                        if(fileToDelete.exists()) fileToDelete.delete();
	                        break;
	                    }
	                }
	            }
	            
	            if (!isDeleted) {
	                if (finalImages.length() > 0) finalImages.append(",");
	                finalImages.append(exist);
	            }
	        }
	    }

	    List<MultipartFile> files = dto.getP_upload();
	    if (files != null && !files.isEmpty()) {
	        for (MultipartFile file : files) {
	            if (!file.isEmpty()) {
	                String originalName = file.getOriginalFilename();
	                String saveName = System.currentTimeMillis() + "_" + originalName;
	                file.transferTo(new File(filePath + saveName));
	                
	                if (finalImages.length() > 0) finalImages.append(",");
	                finalImages.append(saveName);
	            }
	        }
	    }
	    
	    // 최종 이미지 문자열 세팅
	    dto.setP_image(finalImages.toString());
	    
	    // 4. DAO 호출 (주의: productWriteDao가 아니라 productUpdateDao를 사용해야 함)
	    dao.productUpdateDao(dto); 
	    
	    return "redirect:/guest/productDetail?p_no=" + dto.getP_no();
	}
	
	@RequestMapping("/admin/productDelete")
	public String deleteProduct(HttpServletRequest request) {
		int p_no = Integer.parseInt(request.getParameter("p_no"));
		dao.productDeleteDao(p_no);
		return "redirect:/guest/productList";
	}
	
	@Autowired
	IcartDAO cartDao;

	@Autowired
	ImemberDAO memberDao;
	
	
	
	@RequestMapping("/member/addCart")
	public String addCart(cartDTO dto, Principal principal) {
	    if (principal == null) return "redirect:/guest/loginForm";
	    
	    String m_id = principal.getName(); 

	    // 1. 타입을 int가 아니라 memberDTO로 변경해서 받습니다.
	    memberDTO mDto = memberDao.findByM_id(m_id);
	    
	    // 2. mDto 객체에서 m_no(회원번호)를 꺼내서 변수에 담습니다.
	    if (mDto != null) {
	        int m_no = mDto.getM_no(); // mDto 안의 getter 메서드 사용
	        dto.setM_no(m_no);
	        
	        // 이후 기존 로직 실행
	        int count = cartDao.checkProductDao(m_no, dto.getP_no());
	        if(count == 0) {
	            cartDao.addCartDao(dto);
	        } else {
	            cartDao.updateCountDao(dto);
	        }
	    }

	    return "redirect:/member/cartList";
	}

	// 2. cartList 메서드 (중요: 여기서도 Principal을 써야 함)
	@RequestMapping("/member/cartList")
	public String cartList(Principal principal, Model model) {
	    // 1. Security Principal에서 로그인된 ID 확인
	    if (principal == null) return "redirect:/guest/loginForm";
	    String m_id = principal.getName();

	    // 2. memberDao를 통해 memberDTO 객체를 가져옴
	    memberDTO mDto = memberDao.findByM_id(m_id);

	    // 3. mDto가 정상적으로 조회되었을 때만 로직 수행
	    if (mDto != null) {
	        int m_no = mDto.getM_no(); // DTO에서 m_no 추출

	        // 4. 추출한 m_no를 이용해 장바구니 리스트 조회
	        List<cartDTO> list = cartDao.listCartDao(m_no);

	        // 5. 총 합계 계산
	        int totalMoney = 0;
	        for (cartDTO c : list) {
	            totalMoney += c.getMoney();
	        }

	        // 6. 모델에 데이터 담기
	        model.addAttribute("list", list);
	        model.addAttribute("totalMoney", totalMoney);
	        
	        return "member/cartList";
	    } else {
	        // 회원 정보가 없는 경우 예외 처리
	        return "redirect:/guest/loginForm";
	    }
	}
	@GetMapping("/member/cartUpdate")
	public String cartUpdate(@RequestParam("c_no") int c_no, 
	                         @RequestParam("c_count") int c_count) {
	    
	    // 1. 주석을 풀고 실제 DAO의 메서드를 호출하여 DB 값을 변경합니다.
	    cartDao.updateCartQtyDao(c_no, c_count); 
	    
	    // 2. 업데이트 완료 후 다시 장바구니 목록으로 리다이렉트
	    return "redirect:/member/cartList"; 
	}

	@RequestMapping("/member/cartDelete")
	public String cartDelete(@RequestParam("c_no") int c_no) {
	    cartDao.deleteCartDao(c_no);
	    return "redirect:/member/cartList";
	}
	
}
