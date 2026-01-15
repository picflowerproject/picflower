package com.picflower.controller;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.picflower.dao.ImemberDAO;
import com.picflower.dao.IqnaDAO;
import com.picflower.dto.QnaDTO;
import com.picflower.dto.memberDTO;

@Controller
public class QnaController {

    @Autowired
    private IqnaDAO qnaDao;

    @Autowired
    private ImemberDAO memberDao;

    // ✅ 로그인 회원 가져오기 (공통)
    private memberDTO getLoginMember() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) return null;

        // ✅ anonymous 판별은 name으로 통일
        if ("anonymousUser".equals(auth.getName())) return null;

        String loginId = auth.getName();
        return memberDao.findByM_id(loginId);
    }

    // ✅ [회원] 질문 저장
    @ResponseBody
    @PostMapping("/qna/send")
    public String sendQna(@RequestParam("msg") String msg) {

        memberDTO loginMember = getLoginMember();
        if (loginMember == null) return "FAIL";

        QnaDTO dto = new QnaDTO();
        dto.setM_no(loginMember.getM_no());
        dto.setQ_content(msg);

        int result = qnaDao.insertQna(dto);
        return result > 0 ? "SUCCESS" : "ERROR";
    }

    
    // ✅ [회원] 채팅박스에서 내 문의+답변 불러오기 (JSON)
    @GetMapping("/qna/my")
    @ResponseBody
    public List<QnaDTO> myQna() {

        memberDTO loginMember = getLoginMember();
        if (loginMember == null) return Collections.emptyList();

        return qnaDao.selectMyQna(loginMember.getM_no());
    }

    // ✅ [관리자] 문의 리스트 페이지
    @GetMapping("/admin/qnaList")
    public String adminQnaList(Model model) {
        List<QnaDTO> list = qnaDao.selectAllQna();
        model.addAttribute("list", list);
        return "admin/qnaList";
    }

    // ✅ [관리자] 답변 저장
    @ResponseBody
    @PostMapping("/admin/qna/reply")
    public String replyQna(@RequestParam("q_no") int q_no,
                           @RequestParam("answer") String answer) {

        QnaDTO dto = new QnaDTO();
        dto.setQ_no(q_no);
        dto.setQ_answer(answer);

        int result = qnaDao.updateQnaAnswer(dto);
        return result > 0 ? "SUCCESS" : "FAIL";
    }

    // ✅✅ [관리자] 문의 삭제 (추가)
    @ResponseBody
    @PostMapping("/admin/qna/delete")
    public String deleteQna(@RequestParam("q_no") int q_no) {
        try {
            int result = qnaDao.deleteQna(q_no);
            return result > 0 ? "SUCCESS" : "FAIL";
        } catch (Exception e) {
            // FK 제약(ORA-02292) 등 예외가 나면 FAIL
            return "FAIL";
        }
    }

    // ✅ [회원] 내 문의 리스트 페이지
    @GetMapping("/qna/list")
    public String myQnaList(Model model) {

        memberDTO loginMember = getLoginMember();
        if (loginMember == null) {
            return "redirect:/home";
        }

        List<QnaDTO> myList = qnaDao.selectMyQna(loginMember.getM_no());
        model.addAttribute("myList", myList);

        return "member/qnaList";
    }
}
