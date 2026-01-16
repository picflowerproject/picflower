package com.picflower.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.picflower.dao.ISearchDAO;
import com.picflower.dto.boardSearchDTO;
import com.picflower.dto.productDTO;

@Controller
public class SearchController {

    @Autowired
    private ISearchDAO searchDao;

    private static final int PAGE_SIZE = 20;      // 한 페이지 20개
    private static final int PAGE_BLOCK = 5;      // 페이지 번호 5개씩

    // ✅ 시큐리티 안 건드리려면 /guest/** 로 받는 게 제일 안전
    // (헤더 action을 /guest/productSearch 로 바꾸면 비로그인도 검색됨)
    @GetMapping({"/guest/productSearch", "/productSearch"})
    public String search(
            @RequestParam(value = "searchKeyword", required = false, defaultValue = "") String searchKeyword,
            @RequestParam(value = "pPage", required = false, defaultValue = "1") int pPage,
            @RequestParam(value = "bPage", required = false, defaultValue = "1") int bPage,
            Model model
    ) {
        String keyword = searchKeyword.trim();

        // === 상품 ===
        int pTotal = (keyword.isEmpty()) ? 0 : searchDao.countProducts(keyword);
        int pTotalPages = (int) Math.ceil(pTotal / (double) PAGE_SIZE);
        if (pTotalPages == 0) pTotalPages = 1;
        if (pPage < 1) pPage = 1;
        if (pPage > pTotalPages) pPage = pTotalPages;

        int pStart = (pPage - 1) * PAGE_SIZE + 1;
        int pEnd = pPage * PAGE_SIZE;

        List<productDTO> productList = keyword.isEmpty()
                ? java.util.Collections.emptyList()
                : searchDao.searchProducts(keyword, pStart, pEnd);

        int pStartPage = ((pPage - 1) / PAGE_BLOCK) * PAGE_BLOCK + 1;
        int pEndPage = Math.min(pStartPage + PAGE_BLOCK - 1, pTotalPages);

        // === 후기 ===
        int bTotal = (keyword.isEmpty()) ? 0 : searchDao.countBoards(keyword);
        int bTotalPages = (int) Math.ceil(bTotal / (double) PAGE_SIZE);
        if (bTotalPages == 0) bTotalPages = 1;
        if (bPage < 1) bPage = 1;
        if (bPage > bTotalPages) bPage = bTotalPages;

        int bStart = (bPage - 1) * PAGE_SIZE + 1;
        int bEnd = bPage * PAGE_SIZE;

        List<boardSearchDTO> boardList = keyword.isEmpty()
                ? java.util.Collections.emptyList()
                : searchDao.searchBoards(keyword, bStart, bEnd);

        int bStartPage = ((bPage - 1) / PAGE_BLOCK) * PAGE_BLOCK + 1;
        int bEndPage = Math.min(bStartPage + PAGE_BLOCK - 1, bTotalPages);

        // model
        model.addAttribute("searchKeyword", keyword);

        model.addAttribute("productList", productList);
        model.addAttribute("pPage", pPage);
        model.addAttribute("pTotal", pTotal);
        model.addAttribute("pTotalPages", pTotalPages);
        model.addAttribute("pStartPage", pStartPage);
        model.addAttribute("pEndPage", pEndPage);

        model.addAttribute("boardList", boardList);
        model.addAttribute("bPage", bPage);
        model.addAttribute("bTotal", bTotal);
        model.addAttribute("bTotalPages", bTotalPages);
        model.addAttribute("bStartPage", bStartPage);
        model.addAttribute("bEndPage", bEndPage);

        return "guest/searchResult";
    }
}
