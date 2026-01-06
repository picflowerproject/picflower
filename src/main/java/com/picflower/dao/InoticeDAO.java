package com.picflower.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.picflower.dto.NoticeDTO;

@Mapper
public interface InoticeDAO {
	public int n_insertDao(NoticeDTO dto); //공지 입력
	public List<NoticeDTO> n_listDao(); // 공지 목록 전체 조회
	public int n_deleteDao(int n_no); //공지 삭제
	public int n_updateDao(NoticeDTO dto); //공지 수정
}
