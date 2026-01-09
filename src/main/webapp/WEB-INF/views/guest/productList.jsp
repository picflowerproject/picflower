<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Premium Flower Shop</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/productList.css">
</head>
<body>
<header>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
</header>

<main>
    <h2>테마 상품</h2>
    
    <!-- 카테고리 메뉴를 클래스로 관리 -->
	<nav class="category-nav">
	    <!-- 전체보기: p_category 파라미터가 비어있을 때 active -->
	    <a href="productList" class="${empty param.p_category ? 'active' : ''}">전체</a>
	    
	    <!-- 각 카테고리: p_category 파라미터와 값이 일치할 때 active -->
	    <a href="productList?p_category=꽃선물" 
	       class="${param.p_category == '꽃선물' ? 'active' : ''}">꽃선물</a>
	       
	    <a href="productList?p_category=개업화분" 
	       class="${param.p_category == '개업화분' ? 'active' : ''}">개업화분</a>
	       
	    <a href="productList?p_category=승진/취임" 
	       class="${param.p_category == '승진/취임' ? 'active' : ''}">승진/취임</a>
	       
	    <a href="productList?p_category=결혼/장례" 
	       class="${param.p_category == '결혼/장례' ? 'active' : ''}">결혼/장례</a>
	</nav>

    <!-- 테이블 대신 그리드 사용 -->
    <div class="product-grid">
        <c:forEach var="list" items="${list}">
            <div class="product-card">
                <!-- 이미지 섹션 -->
                <div class="product-img-box">
                    <c:set var="firstImg" value="${fn:split(list.p_image, ',')[0]}" />
                    <a href="productDetail?p_no=${list.p_no}">
                        <img src="/img/${firstImg}" alt="${list.p_title}"/>
                    </a>
                </div>
                
                <!-- 정보 섹션 -->
                <div class="product-info">
                    <div class="product-title">
                        <a href="productDetail?p_no=${list.p_no}">${list.p_title}</a>
                    </div>
                    <div class="product-price">
                        <fmt:formatNumber value="${list.p_price}"/><span>원</span>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
   <!-- 페이지 번호 출력 영역 -->
	<div class="pagination">
	    <!-- 이전 버튼 -->
	    <c:if test="${currentPage > 1}">
	        <a href="productList?page=${currentPage - 1}${not empty selectedCategory ? '&p_category=' += selectedCategory : ''}" class="page-btn">&lt;</a>
	    </c:if>
	
	    <!-- 페이지 번호 루프 -->
	    <c:forEach var="i" begin="1" end="${totalPages}">
	        <a href="productList?page=${i}${not empty selectedCategory ? '&p_category=' += selectedCategory : ''}" 
	           class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
	    </c:forEach>
	
	    <!-- 다음 버튼 -->
	    <c:if test="${currentPage < totalPages}">
	        <a href="productList?page=${currentPage + 1}${not empty selectedCategory ? '&p_category=' += selectedCategory : ''}" class="page-btn">&gt;</a>
	    </c:if>
	</div>
</main>

<footer>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>
</html>