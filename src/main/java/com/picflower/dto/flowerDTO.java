package com.picflower.dto;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class flowerDTO {
	private int f_no;
	private String f_name;
	private String f_ename;
	private List<MultipartFile> f_upload;
	private String f_image;
    private List<String> f_imageUrlList; 
	private String f_language;
	private String f_detail;
	private String f_use;
	private String f_raise;
	private String f_birth;
	private int m_no;
}