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
    	System.out.println(oDto.getOrderItems().size());
    	
    	// 1. 주문 메인 저장 (o_no가 생성됨)
        orderDao.insertOrder(oDto);

        // [수정] cartList 대신 oDto에 담겨온 orderItems를 사용합니다.
        // JSP에서 <input name="orderItems[0].p_no">로 보낸 데이터가 여기 들어있습니다.
        List<orderDetailDTO> items = oDto.getOrderItems();

        if (items != null && !items.isEmpty()) {
            for (orderDetailDTO item : items) {
                // 2. 재고 차감 (item에 담긴 p_no와 od_count 사용)
                int affectedRows = orderDao.reduceStock(item.getP_no(), item.getOd_count());
                
                if (affectedRows == 0) {
                    throw new RuntimeException("상품 번호 " + item.getP_no() + "의 재고가 부족합니다.");
                }

                // 3. 주문 상세 저장
                item.setO_no(oDto.getO_no()); 
                // item.getOd_price()에는 JSP에서 보낸 가격이 이미 들어있음
                orderDao.insertOrderDetail(item);
            }
        }
        // 4. 장바구니 비우기 (cartList가 null이 아닐 때만 실행 - 즉, 장바구니 구매일 때만)
        if (cartList != null && !cartList.isEmpty()) {
            cartDao.deleteCartAllDao(m_no);
        }
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