package com.picflower.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.picflower.dto.cartDTO;

@Mapper
public interface IcartDAO {
    public void addCartDao(cartDTO dto);
    public List<cartDTO> listCartDao(int m_no);
    public int checkProductDao(@Param("m_no") int m_no, @Param("p_no") int p_no);
    public void updateCountDao(cartDTO dto);
    public void updateCartQtyDao(@Param("c_no") int c_no, @Param("c_count") int c_count);
    public void deleteCartDao(int c_no);
    
    // 추가: 특정 회원의 장바구니 전체 삭제 (주문 완료용)
    public void deleteCartAllDao(@Param("m_no") int m_no);
}
