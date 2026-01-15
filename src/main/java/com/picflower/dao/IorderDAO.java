package com.picflower.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.picflower.dto.orderDetailDTO;
import com.picflower.dto.orderRequestDTO;

@Mapper
public interface IorderDAO {
	int insertOrder(orderRequestDTO dto);
    int insertOrderDetail(orderDetailDTO dto);
    int reduceStock(@Param("p_no") int p_no, @Param("count") int count);
    List<orderRequestDTO> selectMyOrderList(@Param("m_no") int m_no);
    void updateOrderStatus(@Param("o_no") int o_no, @Param("status") String status);
    String selectOrderStatus(int o_no);
    List<orderDetailDTO> selectOrderDetailList(int o_no);
    void restoreStock(@Param("p_no") int p_no, @Param("count") int count);
}
