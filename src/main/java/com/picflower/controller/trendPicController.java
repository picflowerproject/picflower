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
	    // 1. 날짜 및 탄생화 로직 (유지)
	    LocalDate now = LocalDate.now();
	    flowerDTO todayFlower = dao.selectBirthFlowerByDate(String.valueOf(now.getMonthValue()), String.valueOf(now.getDayOfMonth()));
	    if (todayFlower != null && todayFlower.getF_image() != null) {
	        todayFlower.setF_imageUrlList(Arrays.asList(todayFlower.getF_image().split(","))); 
	    }
	    model.addAttribute("flowerInfo", todayFlower);

	    // 2. 사랑과 고백 (productList)
	    List<Integer> targetPnos = Arrays.asList(10016, 10049, 10067, 10066,10071, 10069, 10030, 10019); 
	    List<productDTO> productList = dao.productListViewDao(targetPnos);
	    processProductImages(productList); // 아래 만든 공통 메서드 호출

	    // 3. 사과와 화해 제품군 (forgiveList) - 변수명 수정
	    List<Integer> forgivePnos = Arrays.asList(10064, 10015, 10108, 10025, 10089, 10029); 
	    List<productDTO> forgiveList = dao.productListViewDao(forgivePnos);
	    processProductImages(forgiveList); // 공통 메서드 호출

	    // 4. 베스트 상품
	    List<productDTO> bestProducts = dao.selectBestProducts(); 

	    // 5. 모델 바인딩 (JSP의 items 명칭과 반드시 일치시킬 것)
	    model.addAttribute("productList", productList);
	    model.addAttribute("forgiveList", forgiveList); // mdPickList 대신 forgiveList로 수정
	    model.addAttribute("bestProducts", bestProducts);
	    
	    return "guest/trendPic";
	}
	// 이미지 처리 공통 메서드 (중복 제거)
    private void processProductImages(List<productDTO> list) {
        if (list != null) {
            for (productDTO product : list) {
                if (product.getP_image() != null && !product.getP_image().isEmpty()) {
                    String[] pImages = product.getP_image().split(",");
                    // product.setP_imageUrlList(Arrays.asList(pImages)); 
                }
            }
        }
    } // processProductImages 메서드 끝

} // 