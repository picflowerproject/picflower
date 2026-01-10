package com.picflower.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.picflower.dto.replyDTO;

@Mapper
public interface IreplyDAO {
    public int r_insertDao(replyDTO dto); // 댓글 입력
    public List<replyDTO> r_listDato();   // 댓글 전체 조회 (오타 주의: r_listDao)
    public List<replyDTO> r_listByB_no(int b_no); // 특정 게시글 아래 댓글 조회
    public int r_deleteDao(int r_no);     // 댓글 삭제
    public int r_updateDao(replyDTO dto); // 댓글 수정
    
    // [추가] 특정 댓글의 정보를 가져오는 메서드 (권한 확인용)
    public replyDTO findByR_no(int r_no); 
}