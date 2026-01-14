package com.picflower.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.picflower.dto.productDTO;

@Mapper
public interface IproductDAO {
	public List<productDTO> productListDao(@Param("p_category") String p_category);
	public int productWriteDao(productDTO dto);
	public productDTO productViewDao(int p_no);
	public int productUpdateDao(productDTO dto);
	public int productDeleteDao(int p_no);
	
	//페이지네이션
	 public List<productDTO> productListPagedDao(
		        @Param("p_category") String p_category, 
		        @Param("start") int start, 
		        @Param("end") int end
		    );

	 // 페이징 계산을 위한 전체 상품 개수 조회
	 public int getTotalCountDao(@Param("p_category") String p_category);
}