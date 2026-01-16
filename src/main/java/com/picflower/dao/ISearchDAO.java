package com.picflower.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.picflower.dto.productDTO;
import com.picflower.dto.boardSearchDTO;

@Mapper
public interface ISearchDAO {

    int countProducts(@Param("keyword") String keyword);

    List<productDTO> searchProducts(
            @Param("keyword") String keyword,
            @Param("start") int start,
            @Param("end") int end
    );

    int countBoards(@Param("keyword") String keyword);

    List<boardSearchDTO> searchBoards(
            @Param("keyword") String keyword,
            @Param("start") int start,
            @Param("end") int end
    );
}
