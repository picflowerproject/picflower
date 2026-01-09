<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>장바구니</title>
    <style>
        .cart-table { width: 100%; border-collapse: collapse; text-align: center; }
        .cart-table th, .cart-table td { border: 1px solid #ccc; padding: 10px; }
        .cart-table th { background-color: #f9f9f9; }
        .total-area { text-align: right; margin-top: 20px; font-size: 1.2em; }
    </style>
</head>
<body>
    <h2>나의 장바구니</h2>

    <c:choose>
        <c:when test="${empty list}">
            <div style="text-align:center; padding:50px;">
                <p>장바구니에 담긴 상품이 없습니다.</p>
                <a href="/guest/productList">쇼핑하러 가기</a>
            </div>
        </c:when>
        <c:otherwise>
            <table class="cart-table">
                <thead>
                    <tr>
                        <th>이미지</th>
                        <th>상품명</th>
                        <th>판매가</th>
                        <th>수량</th>
                        <th>합계</th>
                        <th>선택</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="${list}">
                        <tr>
                            <td><img src="/img/${row.p_image}" width="70"></td>
                            <td>${row.p_title}</td>
                            <td><fmt:formatNumber value="${row.p_price}" pattern="#,###"/>원</td>
                            <td>${row.c_count}개</td>
                            <td>
                                <strong><fmt:formatNumber value="${row.money}" pattern="#,###"/>원</strong>
                            </td>
                            <td>
                                <!-- c_no를 파라미터로 넘겨 삭제 처리 -->
                                <a href="cartDelete?c_no=${row.c_no}" onclick="return confirm('삭제하시겠습니까?')">삭제</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="total-area">
                총 결제 금액: <span style="color:red; font-weight:bold;">
                    <fmt:formatNumber value="${totalMoney}" pattern="#,###"/>원
                </span>
            </div>

            <div style="text-align: center; margin-top: 30px;">
                <a href="/guest/productList"><button type="button">계속 쇼핑하기</button></a>
                <button type="button" onclick="location.href='orderForm'">주문하기</button>
            </div>
        </c:otherwise>
    </c:choose>
</body>
</html>