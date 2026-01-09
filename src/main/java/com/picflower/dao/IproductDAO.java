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
}