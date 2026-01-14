package com.picflower.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.picflower.dto.memberDTO;

@Mapper
public interface ImemberDAO {
	public List<memberDTO> memberListDao();
	public int memberWriteDao(memberDTO dto);
	public memberDTO memberViewDao(int m_no);
	public int memberUpdateDao(memberDTO dto);
	public int memberDeleteDao(int m_no);
	public memberDTO findByM_id(String m_id);
	public int checkMemberFindPasswd(String m_id,String m_pwd);
	public int updatePassword(int m_no, String m_pwd);
}
