package com.picflower.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.picflower.dto.ReplyDTO;

@Mapper
public interface IreplyDAO {
	public int r_insertDao(ReplyDTO dto); //댓글 입력
	public List<ReplyDTO> r_listDato(); //댓글 전체 조회
	public List<ReplyDTO> r_listByB_no(int b_no); //특정 게시글 아래에 있는 댓글 조회
	public int r_deleteDao(int r_no); //댓글 삭제
	public int r_updateDao(ReplyDTO dto); //댓글 수정
}
