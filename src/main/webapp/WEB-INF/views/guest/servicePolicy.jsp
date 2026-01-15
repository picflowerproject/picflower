<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Service Policy</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
<style>
	/* 탭 버튼 영역 */
	.tabs {
	    display: flex;
	    border-bottom: 2px solid #ddd;
	    margin-bottom: 20px;
	}

	.tab-link {
	    background: none;
	    border: none;
	    outline: none;
	    cursor: pointer;
	    padding: 14px 25px;
	    font-size: 16px;
	    transition: 0.3s;
	    font-weight: bold;
	    color: #666;
	}

	/* 마우스 올렸을 때 및 활성화 상태 */
	.tab-link:hover {
	    color: #6a5acd; /* 라벤더 색상 */
	}

	.tab-link.active {
	    color: #6a5acd;
	    border-bottom: 3px solid #6a5acd;
	}

	/* 탭 내용 제어 */
	.tab-content {
	    display: none; /* 기본적으로 숨김 */
	    padding: 20px;
	    line-height: 1.8;
	    background: #fdfdfd;
	    border-radius: 8px;
	}

	.tab-content.active {
	    display: block; /* 활성화된 탭만 표시 */
	}
</style>
<script>
	function openTab(evt, tabName) {
	    // 1. 모든 탭 내용 숨기기
	    const tabContents = document.getElementsByClassName("tab-content");
	    for (let i = 0; i < tabContents.length; i++) {
	        tabContents[i].style.display = "none";
	        tabContents[i].classList.remove("active");
	    }

	    // 2. 모든 탭 버튼에서 'active' 클래스 제거
	    const tabLinks = document.getElementsByClassName("tab-link");
	    for (let i = 0; i < tabLinks.length; i++) {
	        tabLinks[i].classList.remove("active");
	    }

	    // 3. 현재 클릭한 탭 표시 및 버튼 활성화
	    document.getElementById(tabName).style.display = "block";
	    document.getElementById(tabName).classList.add("active");
	    evt.currentTarget.classList.add("active");
	}
</script>
</head>
<body>
<header>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
</header>
<main>
<section>
	<main class="content-container">
	    <h1>서비스 정책</h1>
	
	<!-- 탭 메뉴 -->
	   <div class="tabs">
	       <button class="tab-link active" onclick="openTab(event, 'privacy')">개인정보 처리방침</button>
	       <button class="tab-link" onclick="openTab(event, 'DeliveryTerms')">배송약관</button>
	   </div>

	
 <div id="privacy" class="tab-content active">
        <h3>Picflower 개인정보 처리방침</h3>
        
        <p class="policy-text">
            기분꽃같네(팀명)의 인터넷 쇼핑몰 서비스인 Picflower(이하 회사)은 개인정보 보호법 제30조에 따라 고객님(이하 정보주체)의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리지침을 수립 · 공개합니다.
        </p>

        <p class="policy-text">
            회사는 통신비밀보호법, 전기통신사업법, 정보통신망 이용촉진 및 정보보호 등에 관한 법률, 개인정보보호법 등 정보통신서비스 제공자가 준수하여야 할 관련 법령상의 규정을 지키며, 관련 법령에 따른 개인정보처리방침을 정하여 이를 회사 홈페이지(picflower.com)에 공개하여 고객이 언제나 용이하게 열람할 수 있도록 하고 있습니다. 회사의 개인정보 처리방침은 정부의 법률 및 지침 변경 등에 따라 개인정보 처리방침의 지속적인 개선을 위하여 수정 · 추가가 될 수 있으며 이에 필요한 절차를 정하고 있습니다.
        </p>

        <div class="section-title">제1조 (개인정보의 수집 및 처리 목적)</div>
        <p class="policy-text">① 회사는 정보주체를 위한 각종 서비스를 제공하기 위해서 필요 최소한의 정보만을 수집하고 있습니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 개인정보 보호법 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.</p>
        <ul class="sub-list">
            <li><strong>1. 홈페이지 회원 가입 및 관리:</strong> 회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별 · 인증, 회원자격 유지·관리, 서비스 부정이용 방지, 각종 고지 · 통지, 고충처리 등을 목적으로 개인정보를 처리합니다.</li>
            <li><strong>2. 재화 또는 서비스 제공:</strong> 물품배송, 서비스 제공, 계약서 · 청구서 발송, 콘텐츠 제공, 맞춤서비스 제공, 요금결제·정산 등을 목적으로 개인정보를 처리합니다.</li>
            <li><strong>3. 고충처리:</strong> 민원인의 신원 확인, 민원사항 확인, 사실조사를 위한 연락·통지, 처리결과 통보 등의 목적으로 개인정보를 처리합니다.</li>
        </ul>

        <div class="section-title">제2조 (개인정보의 처리 및 보유기간)</div>
        <p class="policy-text">① 회사는 법령에 따른 개인정보 처리 · 보유기간 또는 정보주체로부터 개인정보를 수집시에 동의 받은 개인정보 처리 · 보유기간 내에서 개인정보를 처리 · 보유합니다.</p>
        <p class="policy-text">② 회사는 다음과 같이 거래 관련 권리 의무 관계를 확인하기 위하여 개인정보를 일정기간 보유할 수 있으며, 이 때 보유 기간은 다음과 같습니다.</p>
        <ul class="sub-list">
            <li>1. 홈페이지 회원 가입 및 관리: 사업자 · 단체 홈페이지 탈퇴시까지 (단, 수사 진행 시 종료 시까지, 채권·채무 관계 잔존 시 정산 시까지)</li>
            <li>2. 재화 또는 서비스 제공: 재화·서비스 공급완료 및 요금결제 · 정산 완료시까지</li>
            <li>&nbsp;&nbsp;&nbsp;- 표시 · 광고에 관한 기록: 6개월</li>
            <li>&nbsp;&nbsp;&nbsp;- 계약 또는 청약철회, 대금결제, 재화 등의 공급 기록: 5년</li>
            <li>&nbsp;&nbsp;&nbsp;- 소비자 불만 또는 분쟁처리에 관한 기록: 3년</li>
            <li>&nbsp;&nbsp;&nbsp;- 접속 로그, 접속지 추적자료: 3개월</li>
        </ul>

        <div class="section-title">제3조 (개인정보의 처리위탁)</div>
        <p class="policy-text">회사는 원활한 업무 처리를 위해 이용자의 개인정보를 위탁 처리할 경우 반드시 사전에 개인정보 처리위탁을 받는 자(수탁자)와 업무 내용을 고지합니다.</p>
        <ul class="sub-list">
            <li>- 카카오톡페이: 결제관련</li>
            <li>- 토스페이먼츠: 결제관련</li>
            <li>- 페이코페이: 결제관련</li>
        </ul>

        <div class="section-title">제4조 (정보주체와 법정대리인의 권리·의무 및 행사방법)</div>
        <p class="policy-text">정보주체는 회사에 대해 언제든지 개인정보 열람 요구, 오류 정정 요구, 삭제 요구, 처리정지 요구를 할 수 있습니다. 회사는 서면, 전화, 전자우편 등을 통해 요청을 받은 경우 지체 없이 조치하겠습니다.</p>

        <div class="section-title">제5조 (처리하는 개인정보 항목)</div>
        <table class="info-table">
            <thead>
                <tr>
                    <th>유형</th>
                    <th>수집항목</th>
                    <th>수집/이용목적</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>필수</td>
                    <td>성명, 아이디(ID), 휴대전화번호, 이메일, 배송지 주소, 받는분 연락처/성함</td>
                    <td>이용자 식별, 계약이행 연락, 물품 배송 및 확인</td>
                </tr>
                <tr>
                    <td>결제</td>
                    <td>계좌번호, 신용카드번호, 결제 기록, 사업자번호(영수증 발행 시)</td>
                    <td>요금청구 및 결제, 계산서 발행</td>
                </tr>
                <tr>
                    <td>자동수집</td>
                    <td>IP주소, 쿠키, 서비스 이용기록, 접속로그</td>
                    <td>부정이용 방지, 장바구니 서비스 제공</td>
                </tr>
                <tr>
                    <td>선택</td>
                    <td>자택주소, 기념일, 결혼여부</td>
                    <td>고객편의 맞춤 서비스 제공</td>
                </tr>
            </tbody>
        </table>

        <div class="section-title">제7조 (개인정보 보호책임자)</div>
        <div class="highlight-box">
            <strong>▶ 개인정보보호책임자</strong><br>
            성명: 이민나 | 직책: 대표이사<br>
            연락처: 02-1234-5678 | 이메일: miiery23@picflower.com
        </div>

        <div class="section-title">제10조 (개인정보 처리방침 변경)</div>
        <p class="policy-text">이 개인정보 처리방침은 2026년 01월 16일부터 적용됩니다. 이전의 처리방침은 아래에서 확인하실 수 있습니다.</p>

    </div>
</main>

	
	

</section>
<div id="DeliveryTerms" class="tab-content">

	<h3>청약철회 반품/교환/환불/취소 등 </h3>
	<br/>
	① ‘전자상거래 등에서의 소비자보호에 관한 법률’ 제17조에 따라 회원은 상품을 배송 받은 날로부터 7일 이내에 반품 또는 교환을 요청할 수 있으며, 반품에 관한 일반적인 사항은 ’전자상거래 등에서의 소비자보호에 관한 법률’ 등 관련 법령이 판매자가 제시한 조건보다 우선합니다. 단, 다음 각 호의 경우에는 회원이 반품이나 교환을 요청할 수 없습니다.<br/>
	<br/>
	1. 회원의 귀책사유로 말미암아 오배송 되었거나 상품이 훼손된 경우<br/>
	2. 회원의 사용 또는 일부 소비로 말미암아 상품의 가치가 현저히 감소한 경우<br/>
	3. 시간이 지나 재판매가 어려울 정도로 상품의 가치가 현저히 감소한 경우<br/>
	4. 복제가 가능한 상품의 포장을 훼손한 경우<br/>
	5. 기타 회원이 환불이나 교환을 요청할 수 없는 합리적인 사유가 있는 경우 <br/>
	※당사 상품의 특성상 주문·제작이 이루어지거나 판매되고 난 뒤 짧은 기간에 상품가치가 현저히 감소하여 재판매가 어려운 상품으로 배송된 뒤 주문자의 주관적인 판단으로 환불 또는 교환이 거절 되거나 상품금액의 일부금액을 공제한 금액이 환불될 수 있습니다.<br/>
	<br/>
	② 회사는 회원으로부터 교환 또는 반품의 의사표시를 접수하면, 즉시 그러한 사실을 판매자에게 통보합니다.<br/>
	<br/>
	③ 반품이나 교환에 필요한 왕복 배송비와 기타 필요한 비용은 귀책사유가 있는 쪽에서 부담합니다. <br/>
	<br/>
	④ 교환에 드는 비용은 물품하자의 경우에는 판매자가 왕복배송비를 부담하나 회원의 변심에 의한 경우에는 회원이 부담합니다.<br/>
	<br/>
	⑤ 배송상의 문제로 회원이 손해를 보았을 때 그에 대한 책임은 해당 배송업체를 지정한 회사에게 있습니다. <br/>
	<br/>
	⑥ 확인된 거래가 취소되어 결제대금을 환불할 경우는 회사는 거래가 취소된 날로부터 2영업일 이내에 회원에게 환불에 필요한 조치를 합니다. 신용카드로 결제했을 때는 환불을 요청한 즉시 결제 승인이 취소됩니다. 그러나 카드사 결제일에 따라 실제 환불까지는 2주 이상이 시간이 소요될 수 있습니다. <br/>
	<br/>
	⑦ 회원은 상품이 제작되기 전까지 구매를 취소할 수 있으며, 제작 후에는 상품의 종류에 따라 일정금액을 제한 금액이 환불되거나 재판매가 어려운 상품의 경우에는 환불 및 구매취소가 안될 수 있습니다. 따라서 주문상태가 ‘상품 준비' 상태이거나 출고 및 도착 이후에 단순 변심으로 인한 교환/환불은 불가합니다.
		
    </div>
    

<footer>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>
</html>