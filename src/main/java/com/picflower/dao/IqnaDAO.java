package com.picflower.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.picflower.dto.QnaDTO;

@Mapper
public interface IqnaDAO {
    public int insertQna(QnaDTO dto);
    public List<QnaDTO> selectAllQna();

    // 답변 등록 (내용 업데이트 + 상태 변경)
    public int updateQnaAnswer(QnaDTO dto);

    public List<QnaDTO> selectMyQna(int m_no);

    // ✅✅ 삭제 (추가)
    public int deleteQna(int q_no);
}
