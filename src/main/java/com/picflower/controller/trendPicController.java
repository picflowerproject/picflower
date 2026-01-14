package com.picflower.controller;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.picflower.dao.IproductDAO;
import com.picflower.dao.ItrendPicDAO;
import com.picflower.dto.flowerDTO;
import com.picflower.dto.productDTO;

@Controller
public class trendPicController {
	@Autowired
	ItrendPicDAO dao;
	
	@Autowired
	IproductDAO productDao;
	
	@RequestMapping("/guest/trendPic")
	public String trendPic(Model model) {
	    // 1. 날짜 및 탄생화 로직 (기존 유지)
	    LocalDate now = LocalDate.now();
	    String month = String.valueOf(now.getMonthValue());
	    String day = String.valueOf(now.getDayOfMonth());
	    
	    flowerDTO todayFlower = dao.selectBirthFlowerByDate(month, day);
	    if (todayFlower != null && todayFlower.getF_image() != null) {
	        String[] imageUrls = todayFlower.getF_image().split(",");
	        todayFlower.setF_imageUrlList(Arrays.asList(imageUrls)); 
	    }
	    model.addAttribute("flowerInfo", todayFlower);

	    // 2. 여러 제품 정보 가져오기
	    List<Integer> targetPnos = Arrays.asList(10021, 10022, 10023); 
	    List<productDTO> productList = dao.productListViewDao(targetPnos);

	    // 3. 각 제품별 이미지 문자열 처리 (for 루프 완성)
	    if (productList != null) {
	        for (productDTO product : productList) {
	            if (product.getP_image() != null && !product.getP_image().isEmpty()) {
	                // p_image 문자열을 잘라서 List로 변환 후 DTO에 저장 (DTO에 해당 필드 추가 필요)
	                String[] pImages = product.getP_image().split(",");
	                // product.setP_imageUrlList(Arrays.asList(pImages)); // DTO에 필드가 있다면 주석 해제
	            }
	        }
	    }
	    
	    List<productDTO> bestProducts = dao.selectBestProducts(); 
	    model.addAttribute("bestProducts", bestProducts);

	    model.addAttribute("productList", productList);
	    
	    return "guest/trendPic";
	} // trendPic 메서드 끝
}