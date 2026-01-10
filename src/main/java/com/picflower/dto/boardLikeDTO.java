package com.picflower.dto;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class boardLikeDTO {
    private int l_no;
    private int b_no;
    private int m_no;
    private Date l_date;
}
