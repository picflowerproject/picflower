package com.picflower.controller;

import java.io.File;
import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.picflower.dao.IcartDAO;
import com.picflower.dao.ImemberDAO;
import com.picflower.dao.IproductDAO;
import com.picflower.dto.cartDTO;
import com.picflower.dto.memberDTO;
import com.picflower.dto.productDTO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class productController {
	@Autowired
	IproductDAO dao;
	
	@RequestMapping("/admin/productWriteForm") 
	public String productWriteForm() {
		return "admin/productWriteForm";
	}
	
	@RequestMapping("/admin/productWrite")
	public String productWrite(productDTO dto) throws Exception {
		 List<MultipartFile> files = dto.getP_upload();
		    String filePath = "C:\\Springboot\\Picflower\\src\\main\\resources\\static\\img\\";
		    
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
	public String productList(@RequestParam(value="p_category", required=false) String p_category, Model model) {
	    // category 파라미터가 없으면 null이 들어가서 전체 리스트를 조회하고,
	    // category=꽃다발 처럼 값이 넘어오면 해당 카테고리만 조회합니다.
	    model.addAttribute("list", dao.productListDao(p_category));
	    
	    // 현재 선택된 카테고리를 JSP에서 알 수 있도록 다시 넘겨줍니다 (선택된 메뉴 강조용)
	    model.addAttribute("selectedCategory", p_category);
	    
	    return "guest/productList"; 
	}
	
	@RequestMapping("/guest/productDetail") 
	public String productDetail(HttpServletRequest request, Model model) {
		int p_no = Integer.parseInt(request.getParameter("p_no"));
		model.addAttribute("detail", dao.productViewDao(p_no));
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
	    
	    String filePath = "C:\\Springboot\\Picflower\\src\\main\\resources\\static\\img\\";
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

	@RequestMapping("/member/cartDelete")
	public String cartDelete(@RequestParam("c_no") int c_no) {
	    cartDao.deleteCartDao(c_no);
	    return "redirect:/member/cartList";
	}
}
