package com.picflower.dto;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class productDTO {
	private int p_no;
	private String p_title;
	private String p_subtitle;
	private int p_price;
	private String p_category;
	private List<MultipartFile> p_upload;
	private String p_image;
	private String p_detail;
	private Date p_date;
	private int m_no;
	private int h_no;
	private int f_no;
}
