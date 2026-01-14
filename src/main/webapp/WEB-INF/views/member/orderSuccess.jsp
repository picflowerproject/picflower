<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="path" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>주문 완료 | 쇼핑몰</title>
    <link rel="stylesheet" type="text/css" href="${path}/css/orderSuccess.css">
</head>
<body>
    <header>
        <c:import url="/WEB-INF/views/common/header.jsp" />
    </header>

    <main class="success-container">
        <div class="success-icon">✔️</div>
        <h1 style="color: #2ecc71;">주문이 완료되었습니다!</h1>
        <p>고객님의 소중한 주문이 정상적으로 접수되었습니다.</p>

       <div class="order-info-card">
		    <!-- order.o_no 형태로 수정 -->
		    <p><strong>주문 번호:</strong> <span>${order.o_no}</span></p> 
		    
		    <!-- oDto 내의 이름 필드명(예: o_name)에 맞춰 수정 -->
		    <p><strong>받으시는 분:</strong> <c:out value="${order.o_name}" /></p>
		    
		    <p><strong>최종 결제 금액:</strong> 
		        <span class="price-highlight">
		            <!-- oDto 내의 금액 필드명(예: o_total_price)에 맞춰 수정 -->
		            <fmt:formatNumber value="${order.o_total_price}" pattern="#,###"/>원
		        </span>
		    </p>
		</div>

        <div class="button-group">
            <a href="/guest/productList" class="btn btn-primary">쇼핑 계속하기</a>
            <a href="${path}/member/myOrderList" class="btn btn-secondary">주문내역 확인</a>
        </div>
    </main>

    <footer>
        <c:import url="/WEB-INF/views/common/footer.jsp" />
    </footer>
</body>
</html>