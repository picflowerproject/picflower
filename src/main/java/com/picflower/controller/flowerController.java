package com.picflower.controller;

import java.io.File;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.picflower.dao.IflowerDAO;
import com.picflower.dto.flowerDTO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class flowerController {
	@Autowired
	IflowerDAO dao;
	
	@RequestMapping("/admin/flowerWriteForm") 
	public String flowerWriteForm() {
		return "admin/flowerWriteForm";
	}
	
	@RequestMapping("/admin/flowerWrite")
	public String flowerWrite(flowerDTO dto) throws Exception {
	    List<MultipartFile> files = dto.getF_upload();
	    String filePath = "C:\\Springboot\\Picflower\\src\\main\\resources\\static\\flower_img\\";
	    
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
	    dto.setF_image(fileNames.toString());
	    
	    dao.flowerWriteDao(dto); 
	    return "redirect:/admin/flowerList";
	}
	
	@RequestMapping("/admin/flowerList") 
	public String flowerList(Model model) {
		model.addAttribute("list", dao.flowerListDao());
		
		return "admin/flowerList"; 
	}
	
	@RequestMapping("/admin/flowerDetail") 
	public String flowerDetail(HttpServletRequest request, Model model) {
		int f_no = Integer.parseInt(request.getParameter("f_no"));
		model.addAttribute("detail", dao.flowerViewDao(f_no));
		return "admin/flowerDetail"; 
	}
	
	@RequestMapping("/admin/flowerUpdateForm")
	public String flowerUpdateForm(Model model, HttpServletRequest request) {
		int f_no = Integer.parseInt(request.getParameter("f_no"));
		model.addAttribute("edit", dao.flowerViewDao(f_no));
		return "admin/flowerUpdateForm";
	}
	
	@RequestMapping("/admin/flowerUpdate")
	public String flowerUpdate(flowerDTO dto) throws Exception {
		List<MultipartFile> files = dto.getF_upload();
	    String filePath = "C:\\Springboot\\Picflower\\src\\main\\resources\\static\\flower_img\\";
	    
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
	    dto.setF_image(fileNames.toString());
		dao.flowerUpdateDao(dto); 
		
		return "redirect:/admin/flowerList";
	}
	
	@RequestMapping("/admin/flowerDelete")
	public String deleteFower(HttpServletRequest request) {
		int f_no = Integer.parseInt(request.getParameter("f_no"));
		dao.flowerDeleteDao(f_no);
		return "redirect:/admin/flowerList";
	}
	
}