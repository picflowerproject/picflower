package com.picflower.dto;


import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class NoticeDTO {
	private int n_no;
	private String n_title;
	private String n_text;
	private String n_image_name;
	private MultipartFile n_image;
	private Date n_date;
}
