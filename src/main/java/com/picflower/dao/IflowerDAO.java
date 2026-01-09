package com.picflower.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.picflower.dto.flowerDTO;

@Mapper
public interface IflowerDAO {
	public List<flowerDTO> flowerListDao();
	public int flowerWriteDao(flowerDTO dto);
	public flowerDTO flowerViewDao(int p_no);
	public int flowerUpdateDao(flowerDTO dto);
	public int flowerDeleteDao(int p_no);
}