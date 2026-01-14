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
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/pagenation.css">
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
                        <img src="${pageContext.request.contextPath}/img/${firstImg}" alt="${list.p_title}"/>
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
    
    
<%-- pagination.jsp 호출 직전 --%>
<c:set var="appendQuery" value="" />
<c:if test="${not empty selectedCategory}">
    <%-- 카테고리가 있으면 쿼리 스트링 생성 --%>
    <c:set var="appendQuery" value="&p_category=${selectedCategory}" />
</c:if>

<jsp:include page="/WEB-INF/views/common/pagination.jsp">
    <jsp:param name="appendQuery" value="${appendQuery}" />
</jsp:include>
</main>

<footer>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>
</html>