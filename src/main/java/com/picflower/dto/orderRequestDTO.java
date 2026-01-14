package com.picflower.dto;

import java.sql.Timestamp;
import java.util.List;

import lombok.Data;

@Data
public class orderRequestDTO {
    // orders 테이블용 (Insert 후 o_no가 여기로 채워짐)
    private int o_no;          // auto_increment 값을 받기 위한 필드 추가
    private int m_no;
    private Timestamp o_date;
    private String o_name;
    private String o_tel;
    private String o_addr;
    private int o_total_price;
    private String o_status;
    private String imp_uid;
    

    // order_detail 테이블용 목록
    private List<orderDetailDTO> orderItems;
    
    private String p_title;    // 대표 상품명 (화면 출력용)
    private int product_count; // "상품명 외 n건"을 위한 전체 상품 종류 수
    // 
}