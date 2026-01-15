<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>장바구니 - 2026 Trend Shop</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/cartList.css">
<script>
function changeQty(c_no, delta) {
    const input = document.getElementById('qty_' + c_no);
    let currentQty = parseInt(input.value);
    let newQty = currentQty + delta;

    if (newQty < 1) {
        alert("최소 수량은 1개입니다.");
        return;
    }

    // 경로 앞에 ${pageContext.request.contextPath}/member/ 를 붙여서 절대 경로로 호출하세요.
    location.href = "${pageContext.request.contextPath}/member/cartUpdate?c_no=" + c_no + "&c_count=" + newQty;
}
</script>
</head>
<body>
<header>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
</header>

<main>
    <h2>나의 장바구니</h2>
    
    <c:choose>
        <%-- 장바구니가 비어있는 경우 --%>
        <c:when test="${empty list}">
            <div style="text-align:center; padding:100px 0;">
                <p style="font-size: 1.2em; color: #888;">장바구니에 담긴 상품이 없습니다.</p>
                <div class="btn-group">
                    <a href="/guest/productList" class="btn-shop">쇼핑하러 가기</a>
                </div>
            </div>
        </c:when>
        
        <%-- 장바구니에 상품이 있는 경우 --%>
        <c:otherwise>
            <table class="cart-table">
                <thead>
                    <tr>
                        <th colspan="2">상품정보</th>
                        <th>판매가</th>
                        <th>수량</th>
                        <th>합계</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="${list}">
                        <tr>
                            <%-- 1. 상품 이미지 처리 (콤마로 구분된 이미지 중 첫 번째 사용) --%>
                            <td width="120">
                                <c:set var="imageArray" value="${fn:split(row.p_image, ',')}" />
                                <c:choose>
                                    <c:when test="${not empty imageArray[0]}">
                                        <img src="${pageContext.request.contextPath}/product_img/${imageArray[0]}" width="90" alt="상품이미지">
                                    </c:when>
                                    <c:otherwise>
                                        <div style="width:90px; height:90px; background:#f4f4f4; display:flex; align-items:center; justify-content:center; border-radius:8px; font-size:12px; color:#ccc;">No Image</div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            
                            <%-- 2. 상품명 --%>
                            <td class="product-title" align="left">
                                <span style="font-size: 1.1em;">${row.p_title}</span>
                            </td>
                            
                            <%-- 3. 판매가 --%>
                            <td><fmt:formatNumber value="${row.p_price}" pattern="#,###"/>원</td>
                            
                            <%-- 4. 수량 조절 UI --%>
                            <td>
                                <div class="qty-wrapper">
                                    <button type="button" onclick="changeQty('${row.c_no}', -1)">-</button>
                                    <input type="text" id="qty_${row.c_no}" value="${row.c_count}" readonly>
                                    <button type="button" onclick="changeQty('${row.c_no}', 1)">+</button>
                                </div>
                            </td>
                            
                            <%-- 5. 개별 상품 합계 --%>
                            <td>
                                <strong style="color:#333;"><fmt:formatNumber value="${row.money}" pattern="#,###"/>원</strong>
                            </td>
                            
                            <%-- 6. 삭제 버튼 (강조 스타일 적용) --%>
                            <td>
                                <a href="${pageContext.request.contextPath}/member/cartDelete?c_no=${row.c_no}" class="btn-delete" onclick="return confirm('해당 상품을 장바구니에서 삭제하시겠습니까?')">삭제</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <%-- 총 결제 금액 영역 --%>
            <div class="total-area">
                <p style="font-size: 16px; color: #666; margin-bottom: 5px;">최종 주문 금액</p>
                <span><fmt:formatNumber value="${totalMoney}" pattern="#,###"/>원</span>
            </div>

            <%-- 하단 버튼 그룹 --%>
            <div class="btn-group">
                <a href="/guest/productList" class="btn-shop">계속 쇼핑하기</a>
                <button type="button" class="btn-order" onclick="location.href='/member/orderForm'">주문하기</button>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<footer>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>