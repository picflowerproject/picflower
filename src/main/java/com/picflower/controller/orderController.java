package com.picflower.controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.picflower.dao.IcartDAO;
import com.picflower.dao.ImemberDAO;
import com.picflower.dao.IorderDAO;
import com.picflower.dao.IproductDAO;
import com.picflower.dto.cartDTO;
import com.picflower.dto.memberDTO;
import com.picflower.dto.orderDetailDTO;
import com.picflower.dto.orderRequestDTO;
import com.picflower.dto.productDTO;
import com.picflower.service.orderService;

@Controller
public class orderController {
	@Autowired IorderDAO orderDao; 
    @Autowired IcartDAO cartDao;
    @Autowired ImemberDAO memberDao;
    @Autowired IproductDAO dao;
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
        @ModelAttribute("oDto") orderRequestDTO oDto, // 스프링이 orderItems 리스트를 자동으로 채워줌
        @RequestParam("imp_uid") String imp_uid,
        @RequestParam(value="isDirectOrder", required=false, defaultValue="false") boolean isDirectOrder,
        Principal principal, 
        Model model) {
        
        if (principal == null) return "redirect:/guest/loginForm";
        
        memberDTO mDto = memberDao.findByM_id(principal.getName());
        if (mDto == null) return "redirect:/guest/loginForm";

        // 1. 기본 정보 설정
        oDto.setM_no(mDto.getM_no());
        oDto.setImp_uid(imp_uid);
        
        // 2. 장바구니 리스트 준비 (삭제용)
        List<cartDTO> cartListForDelete = null;
        if (!isDirectOrder) {
            cartListForDelete = cartDao.listCartDao(mDto.getM_no());
        }

        /* 
           [핵심] oDto.getOrderItems()에는 이미 JSP에서 보낸 데이터가 들어있습니다.
           바로구매든 장바구니든 상관없이 이 리스트를 사용하여 주문을 처리합니다.
        */
        orderService.executeOrder(oDto, cartListForDelete, mDto.getM_no());

        model.addAttribute("order", oDto);
        model.addAttribute("imp_uid", imp_uid);
        
        return "member/orderSuccess"; 
    }
    
  //바로구매 컨트롤러 추가
    @PostMapping("/member/directOrderForm")
    public String directOrderForm(@RequestParam("p_no") int p_no, 
                                  @RequestParam("o_count") int o_count, 
                                  Principal principal, 
                                  Model model) {
        
        if (principal == null) return "redirect:/guest/loginForm";
        
        memberDTO member = memberDao.findByM_id(principal.getName()); 
        model.addAttribute("mDto", member);
        
        productDTO product = dao.productViewDao(p_no);
        
        List<cartDTO> items = new ArrayList<>();
        cartDTO item = new cartDTO();
        item.setP_no(p_no);
        item.setP_title(product.getP_title());
        item.setP_price(product.getP_price());
        item.setC_count(o_count);
        item.setMoney(product.getP_price() * o_count);
        items.add(item);
        
        int totalMoney = item.getMoney();

        model.addAttribute("list", items); 
        model.addAttribute("totalMoney", totalMoney); // 이 값이 중요함
        model.addAttribute("isDirectOrder", true);
        
        // [추가] JSP 상단 c:if문에서 에러가 나지 않도록 빈 객체라도 생성해서 보냅니다.
        orderRequestDTO orderReq = new orderRequestDTO();
        orderReq.setO_total_price(totalMoney);
        model.addAttribute("orderReq", orderReq); 
        
        return "member/orderForm";
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