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
    try {
        const totalAmount = document.getElementById('o_total_price').value;
        const buyerName = document.getElementById('o_name').value || "미입력";
        
        // 1. 대표 상품명 추출 (화면에 표시된 첫 번째 상품명)
        const firstProductName = document.querySelector('.product-name')?.innerText || "상품 결제";
        // 2. 전체 상품 종류 수 계산
        const productItems = document.querySelectorAll('.product-item'); // 상품 행에 class="product-item" 추가 필요

        let pgCode = "";
        if(payMethod === 'kakao') pgCode = "kakaopay.TC0ONETIME";
        else if(payMethod === 'toss') pgCode = "tosspayments.iamporttest_3";
        else if(payMethod === 'payco') pgCode = "payco.PARTNERTEST";

        IMP.request_pay({
            pg: pgCode,
            pay_method: "card",
            merchant_uid: "mid_" + new Date().getTime(),
            name: productItems.length > 1 ? `${firstProductName} 외 ${productItems.length - 1}건` : firstProductName,
            amount: parseInt(totalAmount),
            buyer_name: buyerName,
            buyer_tel: document.getElementById('o_tel')?.value || "010-0000-0000",
        }, function (rsp) {
            if (rsp.success) {
                const form = document.querySelector('.order-form');
                
                // 결제 고유번호 추가
                addHiddenInput(form, 'imp_uid', rsp.imp_uid);
                
                // [중요] 상세 상품 정보(orderItems)를 리스트 형태로 매핑
                // 장바구니/바로구매 페이지의 hidden input들을 찾아 서브밋 데이터에 포함
                // 상품 정보 input들에 class="p-info"를 주고 아래와 같이 반복 처리
                document.querySelectorAll('.p-info').forEach((el, index) => {
                    // 서버의 List<OrderDetailDTO> orderItems로 매핑되도록 이름 설정
                    // ex) orderItems[0].p_no, orderItems[0].od_count
                    const name = el.dataset.name; // HTML에 data-name="p_no" 식으로 저장
                    addHiddenInput(form, `orderItems[${Math.floor(index/3)}].${name}`, el.value);
                });

                form.submit();
            } else {
                alert("결제 실패: " + rsp.error_msg);
            }
        });
    } catch (e) { console.error(e); }
    return false;
}

// Hidden Input 생성을 위한 편의 함수
function addHiddenInput(form, name, value) {
    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = name;
    input.value = value;
    form.appendChild(input);
}
function copyMemberInfo() {
    const isChecked = document.getElementById('sameAsMember').checked;
    
    // JSP의 mDto 데이터를 자바스크립트 변수에 할당
    const memberName = "${mDto.m_name}";
    const memberTel = "${mDto.m_tel}";
    const memberAddr = "${mDto.m_addr}"; // 예: "부산광역시 부산진구,101호"

    // 입력 필드 객체들 가져오기
    const oNameInput = document.getElementById('o_name');
    const oTelInput = document.getElementById('o_tel');
    const oAddrInput = document.getElementById('o_addr');
    const oAddrDetailInput = document.getElementById('o_addr_detail'); // 상세주소 필드 추가

    if (isChecked) {
        oNameInput.value = memberName;
        oTelInput.value = memberTel;

        // 쉼표(,)를 기준으로 주소 분리
        if (memberAddr.includes(',')) {
            const addrParts = memberAddr.split(',');
            oAddrInput.value = addrParts[0].trim();       // 쉼표 앞 (기본주소)
            oAddrDetailInput.value = addrParts[1].trim(); // 쉼표 뒤 (상세주소)
        } else {
            // 쉼표가 없는 경우 전체를 기본주소에 넣음
            oAddrInput.value = memberAddr;
            oAddrDetailInput.value = "";
        }
    } else {
        oNameInput.value = "";
        oTelInput.value = "";
        oAddrInput.value = "";
        oAddrDetailInput.value = "";
    }
}

//주소 팝업창 호출
function goAddrPopup() {
    // 팝업 호출 경로를 현재 프로젝트의 주소 팝업 JSP 경로로 설정하세요.
    // 예: /guest/jusoPopup.jsp 또는 /member/jusoPopup
    var pop = window.open("/guest/jusoPopup", "pop", "width=570,height=420,scrollbars=yes,resizable=yes");
}

// 팝업에서 호출하는 콜백 함수 (이름이 반드시 jusoCallBack이어야 함)
function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo) {
    // roadAddrPart1: 도로명 주소 (예: 서울특별시 강남구 강남대로 123)
    // addrDetail: 고객이 직접 입력한 상세주소 (예: 101호)
    // roadAddrPart2: 참고주소 (예: (역삼동))
    
    document.getElementById("o_addr").value = roadAddrPart1 + "," + roadAddrPart2;
    document.getElementById("o_addr_detail").value = addrDetail;
}
</script>
</head>
<body>
<header>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
</header>
  <main class="order-container"> 
    <form action="/member/orderProcess" method="post" class="order-form">
	  	<!-- 금액 정보를 담는 유일한 input 필드 -->
		<input type="hidden" name="o_total_price"  id="o_total_price" value="${totalMoney}"> 
		
        <input type="hidden" name="isDirectOrder" value="${isDirectOrder}">
        
	
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
			    <div class="address-group">
			        <!-- o_addr은 API가 주는 도로명주소를 담습니다 -->
			        <input type="text" name="o_addr" id="o_addr" readonly required placeholder="주소 검색을 눌러주세요">
			        <button type="button" onclick="goAddrPopup()" class="btn-sub">주소 검색</button>
			    </div>
			    <!-- 상세주소 필드 -->
			    <input type="text" id="o_addr_detail" class="full-width" placeholder="상세 주소를 입력해주세요">
			</div>
	
		<h3>주문 상품 확인</h3>
		
			<c:forEach var="row" items="${list}" varStatus="i">
			    <div class="order-item-list">
			        <span><strong>${row.p_title}</strong></span>
			        <span>${row.c_count}개 / <fmt:formatNumber value="${row.p_price}" pattern="#,###"/>원</span>
			    </div>
			
			    <input type="hidden" name="orderItems[${i.index}].p_no" value="${row.p_no}">
			    <!-- row.c_count가 null일 경우를 대비해 1 또는 원본값 할당 -->
			    <input type="hidden" name="orderItems[${i.index}].od_count" value="${row.c_count > 0 ? row.c_count : 1}">
			    <input type="hidden" name="orderItems[${i.index}].od_price" value="${row.p_price}">
			</c:forEach>

<!-- 총 결제 금액 표시 영역 -->
<div class="total">
    총 금액: <fmt:formatNumber value="${totalMoney}" pattern="#,###"/>원
</div>
			
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