package com.picflower.dto;

import lombok.Data;

@Data
public class cartDTO {
    private int c_no;      // 장바구니 번호 (PK)
    private int c_count;   // 수량
    private int m_no;      // 회원 번호 (FK)
    private int p_no;      // 상품 번호 (FK)
    
    // JOIN을 통해 가져올 상품 정보 필드
    private String p_title;
    private int p_price;
    private String p_image;
    private int money;     // p_price * c_count (합계 금액)
}