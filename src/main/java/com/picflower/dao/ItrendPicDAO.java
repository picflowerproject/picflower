package com.picflower.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.picflower.dto.flowerDTO;
import com.picflower.dto.productDTO;

@Mapper
public interface ItrendPicDAO {
    flowerDTO selectBirthFlowerByDate(@Param("month") String month, @Param("day") String day);
    
    // @Param("p_no")를 추가하여 XML의 #{p_no}와 이름을 맞춥니다.
    public List<productDTO> productListViewDao(@Param("p_nos") List<Integer> p_nos);
	public List<productDTO> selectBestProducts();
}