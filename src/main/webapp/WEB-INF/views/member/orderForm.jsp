<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 양식</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/orderForm.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" ></script>
<script type="text/javascript" src="https://service.iamport.kr/js/iamport.payment-1.1.5.js"></script>
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
<script>
const IMP = window.IMP;
IMP.init("imp76644727"); 

function requestPay(payMethod) {
    // 1. 폼 데이터 및 결제 정보 설정
    const totalAmount = document.querySelector('input[name="o_total_price"]').value;
    const buyerName = document.querySelector('input[name="o_name"]').value;
    const orderName = "테스트 상품 결제";

    // 2. pgCode 선언 (한 번만 선언해야 에러가 나지 않습니다)
    let pgCode = "";
    switch(payMethod) {
        case 'kakao': pgCode = "kakaopay.TC0ONETIME"; break;
        case 'toss':  pgCode = "tosspayments.iamporttest_3"; break; 
        case 'payco': pgCode = "payco.PARTNERTEST"; break;
        default: return;
    }

    // 3. 아임포트 결제 요청
    IMP.request_pay({
        pg: pgCode,
        //pay_method: "",
       pay_method: "card",
        merchant_uid: "mid_" + new Date().getTime(),
        name: orderName,
        amount: totalAmount, // 100원 대신 실제 주문 금액 사용 권장
        buyer_name: buyerName,
        buyer_tel: "010-1234-5678",
    }, function (rsp) {
        if (rsp.success) {
            // [중요] 결제 성공 시 서버의 orderProcess로 폼 제출
            console.log("결제 성공:", rsp);
            const form = document.querySelector('.order-form');
            
            // 결제 고유 번호를 서버로 넘겨주기 위해 hidden 필드 생성
            const impInput = document.createElement('input');
            impInput.type = 'hidden';
            impInput.name = 'imp_uid';
            impInput.value = rsp.imp_uid;
            form.appendChild(impInput);

            // 서버 경로 재확인 (컨트롤러 설정에 맞춰 제출)
            form.submit(); 
        } else {
            alert("결제 실패: " + rsp.error_msg);
        }
    });

    // 버튼 클릭 시 폼이 바로 제출(새로고침)되는 것을 방지
    return false;
}


function copyMemberInfo() {
    const isChecked = document.getElementById('sameAsMember').checked;
    
    // JSP의 mDto 데이터를 자바스크립트 변수에 할당
    const memberName = "${mDto.m_name}";
    const memberTel = "${mDto.m_tel}";
    const memberAddr = "${mDto.m_addr}";

    // 입력 필드 객체들 가져오기
    const oNameInput = document.getElementById('o_name');
    const oTelInput = document.getElementById('o_tel');
    const oAddrInput = document.getElementById('o_addr');

    if (isChecked) {
        // 체크되었을 때: 로그인 유저 정보로 채우기
        oNameInput.value = memberName;
        oTelInput.value = memberTel;
        oAddrInput.value = memberAddr;
    } else {
        // 체크 해제되었을 때: 입력 필드 비우기
        oNameInput.value = "";
        oTelInput.value = "";
        oAddrInput.value = "";
    }
}
</script>
</head>
<body>
	<c:if test="${isDirectOrder}">
	    <c:set var="totalMoney" value="${orderReq.o_total_price}" />
	    <c:set var="list" value="${orderReq.orderItems}" />
	</c:if>
<header>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
</header>
<main class="order-container"> 
    <form action="/member/orderProcess" method="post" class="order-form">
	  	<input type="hidden" name="m_no" value="${mDto.m_no}">
	    <input type="hidden" name="o_total_price" value="${totalMoney}">
	
		<div class="section-header" style="display: flex; align-items: center; justify-content: space-between; margin-top: 30px;">
	    <h3 style="margin: 0;">배송 정보</h3>
	    <div class="checkbox-group" style="display: flex; align-items: center; gap: 5px;">
	        <input type="checkbox" id="sameAsMember" onclick="copyMemberInfo()" style="width: 18px; height: 18px; cursor: pointer;">
	        <label for="sameAsMember" style="margin: 0; font-size: 0.9rem; cursor: pointer; color: #555;">주문자 정보와 동일</label>
	    </div>
	</div>

		<!-- 입력 필드 영역 -->
		<div class="shipping-info">
		    <div class="input-row">
		        <label>받는 사람</label>
		        <input type="text" name="o_name" id="o_name" required>
		    </div>
		    <div class="input-row">
		        <label>연락처</label>
		        <input type="text" name="o_tel" id="o_tel" required>
		    </div>
		    <div class="input-row">
		        <label>주소</label>
		        <input type="text" name="o_addr" id="o_addr" class="full-width" required>
		    </div>
		</div>
	
		<h3>주문 상품 확인</h3>
		<c:forEach var="row" items="${list}" varStatus="i">
		    <!-- 데이터 전송용 hidden 필드 -->
		    <input type="hidden" name="orderItems[${i.index}].p_no" value="${row.p_no}">
		    
		    <%-- 수량 결정: 바로구매(od_count)인지 장바구니(c_count)인지 체크 --%>
		    <c:set var="itemCount" value="${isDirectOrder ? row.od_count : row.c_count}" />
		    <%-- 가격 결정: 바로구매(od_price)인지 장바구니(p_price)인지 체크 --%>
		    <c:set var="itemPrice" value="${isDirectOrder ? row.od_price : row.p_price}" />

		    <input type="hidden" name="orderItems[${i.index}].od_count" value="${itemCount}">
		    <input type="hidden" name="orderItems[${i.index}].od_price" value="${itemPrice}">
		    
		    <div class="order-item-list">
		        <span>
		            <strong>
		                <c:choose>
		                    <c:when test="${isDirectOrder}">${product.p_title}</c:when>
		                    <c:otherwise>${row.p_title}</c:otherwise>
		                </c:choose>
		            </strong>
		        </span>
		        <span>
		            ${itemCount}개 / <fmt:formatNumber value="${itemPrice}" pattern="#,###"/>원
		        </span>
		    </div>
		</c:forEach>
	
	  	<div class="total">총 금액: <fmt:formatNumber value="${totalMoney}" pattern="#,###"/>원</div>
	  	<h3>결제 수단 선택</h3>
			<div class="payment-buttons">
			   <button type="button" onclick="requestPay('kakao')" class="pay-btn kakao">
				    <img src="${pageContext.request.contextPath}/assets/kakaopay_logo.png" alt="카카오페이">
				</button>
				
				<button type="button" onclick="requestPay('toss')" class="pay-btn toss">
				    <img src="${pageContext.request.contextPath}/assets/tosspay_logo.png" alt="토스페이">
				</button>
				
				<button type="button" onclick="requestPay('payco')" class="pay-btn payco">
				    <span class="payco-text">
				        <span class="payco-p">P</span>AYCO
				    </span>
				</button>
			</div>
	</form>
</main>
<footer>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>
</html>