package com.picflower.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.picflower.dto.boardDTO;

@Mapper
public interface IboardDAO {
	public int b_insertDao(boardDTO dto);  //후기 글 입력
	public List<boardDTO> b_listDao(); //후기 글 목록 보기
	public int b_deleteDao(int b_no); //후기 글 삭제
	public int b_updateDao(boardDTO dto);  //후기 글 수정
	public List<boardDTO> b_listWithMemberDao(); //회원정보 가져오기
	public boardDTO b_viewWithMemberDao(int b_no);
	// 1. 좋아요 중복 체크 (결과가 1이면 이미 누름, 0이면 안 누름)
    public int checkLikeDao(@Param("b_no") int b_no, @Param("m_no") int m_no);

    // 2. board_like 테이블에 기록 추가
    public int insertLikeDao(@Param("b_no") int b_no, @Param("m_no") int m_no);

	// 3. board 테이블의 b_like 컬럼 숫자 +1 (기존 것 사용)
    public int upLike(int b_no);
    
 // 좋아요 기록 삭제
    public int deleteLikeDao(@Param("b_no") int b_no, @Param("m_no") int m_no);

    // board 테이블의 b_like 컬럼 숫자 -1
    public int downLike(int b_no);

    // 4. 최신 좋아요 개수 가져오기 (기존 것 사용)
    public int getLikeCount(int b_no);
    

 // 삭제 대신 상태를 변경하는 메서드 추가
    public int updateStatusDao(@Param("b_no") int b_no);
    
    // 1. 특정 상품(p_no)에 달린 후기 목록만 가져오기 (상품 상세페이지용)
    public List<boardDTO> b_listByProductDao(int p_no);

    // 2. 후기 목록 조회 시 상품 이름까지 포함해서 가져오기 (전체 후기 게시판용)
    public List<boardDTO> b_listWithProductDao(); 
    
    public List<boardDTO> getRecentProduct(@Param("m_no") int m_no);
    
    public List<boardDTO> getUnreviewedProducts(@Param("m_no") int m_no);
    
}
