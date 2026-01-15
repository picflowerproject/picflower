package com.picflower.dto;

import java.sql.Date;
import lombok.Data;

@Data
public class QnaDTO {
    private int q_no;
    private int m_no;
    private String q_content;
    private String q_answer;
    private Date q_date;
    private String q_status;
    
    // [추가] 관리자 페이지에서 작성자 아이디를 보여주기 위한 필드
    private String m_id; 
}