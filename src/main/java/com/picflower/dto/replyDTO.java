package com.picflower.dto;

import java.util.Date;
import lombok.Data;

@Data
public class replyDTO {
    private int r_no;
    private String r_text;
    private int r_count;
    private Date r_date;
    private int b_no;
    
    // 추가해야 할 필드
    private int m_no;      // 작성자 회원번호 (DB 저장용)
    private String m_id;   // 작성자 아이디 (화면 출력용)
}