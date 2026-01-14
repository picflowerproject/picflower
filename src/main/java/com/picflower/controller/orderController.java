package com.picflower.controller;

import java.security.Principal;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.picflower.dao.IcartDAO;
import com.picflower.dao.ImemberDAO;
import com.picflower.dao.IorderDAO;
import com.picflower.dto.cartDTO;
import com.picflower.dto.memberDTO;
import com.picflower.dto.orderRequestDTO;
import com.picflower.service.orderService;

@Controller
public class orderController {
	@Autowired IorderDAO orderDao; 
    @Autowired IcartDAO cartDao;
    @Autowired ImemberDAO memberDao;
    @Autowired orderService orderService; // DB 저장 전담 서비스

    // 1. 주문서 작성 폼 (그대로 유지)
    @RequestMapping("/member/orderForm")
    public String orderForm(Principal principal, Model model) {
        if (principal == null) return "redirect:/guest/loginForm";
        
        String m_id = principal.getName();
        memberDTO mDto = memberDao.findByM_id(m_id);
        
        if (mDto != null) {
            List<cartDTO> list = cartDao.listCartDao(mDto.getM_no());
            int totalMoney = 0;
            for (cartDTO c : list) { totalMoney += c.getMoney(); }

            model.addAttribute("mDto", mDto);
            model.addAttribute("list", list);
            model.addAttribute("totalMoney", totalMoney);
            
            return "member/orderForm"; // 주문서 페이지로 이동
        }
        return "redirect:/member/cartList";
    }

    // 2. 주문 완료 처리 (로직만 서비스로 넘김)
    @RequestMapping("/member/orderProcess")
    public String orderProcess(
        @ModelAttribute("oDto") orderRequestDTO oDto, // 객체 바인딩 이름 명시
        @RequestParam("imp_uid") String imp_uid,       // 파라미터 이름 명시
        Principal principal, 
        Model model) {
        
        if (principal == null) return "redirect:/guest/loginForm";
        
        String m_id = principal.getName();
        memberDTO mDto = memberDao.findByM_id(m_id);
        
        if (mDto != null) {
            oDto.setM_no(mDto.getM_no());
            List<cartDTO> cartList = cartDao.listCartDao(mDto.getM_no());
            
            // 서비스 호출
            orderService.executeOrder(oDto, cartList, mDto.getM_no());

            model.addAttribute("order", oDto);
            model.addAttribute("imp_uid", imp_uid);
        }
        return "member/orderSuccess"; 
    }
    
    @RequestMapping("/member/myOrderList")
    public String myOrderList(Principal principal, Model model) {
        if (principal == null) return "redirect:/guest/loginForm";

        // 1. 로그인한 회원 정보 가져오기
        String m_id = principal.getName();
        memberDTO mDto = memberDao.findByM_id(m_id);

        if (mDto != null) {
            // 2. 해당 회원의 주문 목록 조회
            List<orderRequestDTO> orderList = orderDao.selectMyOrderList(mDto.getM_no());
            
            // 3. 화면에 데이터 전달
            model.addAttribute("orderList", orderList);
        }
        
        return "member/myOrderList"; // JSP 파일 경로
    }
    
    @PostMapping("/member/orderCancel")
    @ResponseBody
    public String orderCancel(
            @RequestParam("imp_uid") String imp_uid,
            @RequestParam("o_no") int o_no) {
        try {
            boolean result = orderService.refundOrder(imp_uid, o_no);
            return result ? "success" : "fail";
        } catch (Exception e) {
            // 로그에 예외 정보를 기록합니다.
            e.printStackTrace(); 
            // 클라이언트에게는 실패 메시지를 반환하거나, 특정 오류 코드를 반환할 수 있습니다.
            return "error occurred: " + e.getMessage(); 
        }
    }
}