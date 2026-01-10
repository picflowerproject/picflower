package com.picflower.dto;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class boardDTO {
	private int b_no;
	private Date b_date;
	private String b_title;
	private String b_text;
	private MultipartFile b_upload;
	private String b_image;
	private List<MultipartFile> b_upload_list; // 업로드 시 사용 (JSP name과 일치)
    private List<String> b_image_list; 
	private int b_rating;
	private int b_like;
	private int m_no;
	private String m_id;
	private List<replyDTO> replies; //댓글 모음
	private boolean userLiked; 
}
