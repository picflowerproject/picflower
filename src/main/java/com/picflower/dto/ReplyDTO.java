package com.picflower.dto;

import java.util.Date;

import lombok.Data;

@Data
public class ReplyDTO {
	private int r_no;
	private String r_text;
	private int r_count;
	private Date r_date;
	private int b_no;
}
