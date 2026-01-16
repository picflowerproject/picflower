package com.picflower.dto;

import lombok.Data;

@Data
public class orderDetailDTO {
    private int od_no;   // PK
    private int o_no;    // FK (OrderRequestDTO의 o_no를 전달받음)
    private int p_no;
    private int od_count;
    private int od_price;
    private String p_title; // 
    public String getP_title() { return p_title; }
    public void setP_title(String p_title) { this.p_title = p_title; }
}