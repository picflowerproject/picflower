package com.picflower.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.picflower.dto.boardDTO;

@Mapper
public interface IboardDAO {
	public int b_insertDao(boardDTO dto);  //후기 글 입력
	public List<boardDTO> b_listDao(); //후기 글 목록 보기
	public int b_deleteDao(int b_no); //후기 글 삭제
	public int b_updateDao(boardDTO dto);  //후기 글 수정
	public void upLike(int b_no); //특정 게시글의 좋아요 수 +1
	public int getLikeCount(int b_no); // 현재 좋아요 수 가져오기
	public List<boardDTO> b_listWithMemberDao(); //회원정보 가져오기
	public boardDTO b_viewWithMemberDao(int b_no);
}
