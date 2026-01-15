package com.picflower.service;

import java.util.List;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.picflower.dao.IcartDAO;
import com.picflower.dao.IorderDAO;
import com.picflower.dto.cartDTO;
import com.picflower.dto.orderDetailDTO;
import com.picflower.dto.orderRequestDTO;

@Service
public class orderService {

    @Autowired IcartDAO cartDao;
    @Autowired IorderDAO orderDao;

    // 포트원 API 키 설정
    private final String IMP_KEY = "4107367203761302";
    private final String IMP_SECRET = "i8bGFc9NCzy9sZa6MCsNpKOKpHvgzYnBcGZyA2fgp7ugvhn1Tvl9KADbeX8pYXhq5yTKg9ZYnXCTKal4";

    // 1. 주문 실행 로직 (기존 유지)
    @Transactional
    public void executeOrder(orderRequestDTO oDto, List<cartDTO> cartList, int m_no) {
        // 1. 주문 메인 저장
        orderDao.insertOrder(oDto);

        for(cartDTO cart : cartList) {
            // 2. 재고 차감 시도 및 결과 확인
            int affectedRows = orderDao.reduceStock(cart.getP_no(), cart.getC_count());
            
            if (affectedRows == 0) {
                throw new RuntimeException("상품 번호 " + cart.getP_no() + "의 재고가 부족합니다.");
            }

            // 3. 주문 상세 저장
            orderDetailDTO detail = new orderDetailDTO();
            detail.setO_no(oDto.getO_no());
            detail.setP_no(cart.getP_no());
            detail.setOd_count(cart.getC_count());
            detail.setOd_price(cart.getP_price());
            orderDao.insertOrderDetail(detail);
        }

        // 4. 장바구니 비우기
        cartDao.deleteCartAllDao(m_no);
    }

    // 2. 실제 결제 취소(환불) 로직 (통합 수정본)
    public boolean cancelPayment(String imp_uid) {
        try {
            RestTemplate restTemplate = new RestTemplate();

            /* ===============================
             * 1️⃣ Access Token 발급
             * =============================== */
            String tokenUrl = "https://api.iamport.kr/users/getToken";

            Map<String, String> tokenBody = new HashMap<>();
            tokenBody.put("imp_key", IMP_KEY);
            tokenBody.put("imp_secret", IMP_SECRET);

            ResponseEntity<JsonNode> tokenEntity =
                    restTemplate.postForEntity(tokenUrl, tokenBody, JsonNode.class);

            JsonNode tokenResponse = tokenEntity.getBody();

            if (tokenResponse == null || tokenResponse.get("response") == null) {
                System.out.println("토큰 발급 실패");
                return false;
            }

            String accessToken =
                    tokenResponse.get("response").get("access_token").asText();

            /* ===============================
             * 2️⃣ 결제 취소(환불) 요청
             * =============================== */
            String cancelUrl = "https://api.iamport.kr/payments/cancel";

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(accessToken);

            Map<String, String> cancelBody = new HashMap<>();
            cancelBody.put("imp_uid", imp_uid);
            cancelBody.put("reason", "고객 요청 환불");

            HttpEntity<Map<String, String>> request =
                    new HttpEntity<>(cancelBody, headers);

            ResponseEntity<JsonNode> cancelResponse =
                    restTemplate.postForEntity(cancelUrl, request, JsonNode.class);

            JsonNode body = cancelResponse.getBody();

            if (body != null && body.get("code").asInt() == 0) {
                System.out.println("✅ 포트원 결제 취소 성공: " + imp_uid);
                return true;
            } else {
                System.out.println("❌ 환불 실패: " +
                        (body != null ? body.get("message").asText() : "응답 없음"));
                return false;
            }

        } catch (Exception e) {
            System.err.println("❌ 환불 처리 중 예외 발생");
            e.printStackTrace();
            return false;
        }
    }
    
    @Transactional
    public boolean refundOrder(String imp_uid, int o_no) {

        // 1️⃣ 이미 환불된 주문인지 체크 (선택이지만 강력 권장)
        String status = orderDao.selectOrderStatus(o_no);
        if ("환불완료".equals(status)) {
            return false;
        }

        // 2️⃣ 포트원 실제 환불
        boolean paymentCanceled = cancelPayment(imp_uid);
        if (!paymentCanceled) {
            return false;
        }

        // 3️⃣ 주문 상태 변경
        orderDao.updateOrderStatus(o_no, "환불완료");

        // 4️⃣ 주문 상세 조회
        List<orderDetailDTO> detailList =
                orderDao.selectOrderDetailList(o_no);

        // 5️⃣ 재고 복구
        for (orderDetailDTO detail : detailList) {
            orderDao.restoreStock(
                detail.getP_no(),
                detail.getOd_count()
            );
        }

        return true;
    }
}