package com.picflower.dto;


import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class noticeDTO {
	private int n_no;
	private String n_title;
	private String n_text;
	private Date n_date;
}
