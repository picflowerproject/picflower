package com.picflower.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.picflower.dto.noticeDTO;

@Mapper
public interface InoticeDAO {
	public int n_insertDao(noticeDTO dto); //공지 입력
	public List<noticeDTO> n_listDao(); // 공지 목록 전체 조회
	public int n_deleteDao(int n_no); //공지 삭제
	public int n_updateDao(noticeDTO dto); //공지 수정
	
	//페이지//
	public int getTotalCount();
    public List<noticeDTO> n_listPagedDao(@Param("offset") int offset, @Param("size") int size);
    //
}
