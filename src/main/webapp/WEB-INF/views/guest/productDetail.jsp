<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품상세정보</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/productDetail.css">
<script src="${pageContext.request.contextPath}/js/productDetail.js"></script>
<style>
    /* 큰 이미지 스타일 */
    .main-img { width: 350px; height: 400px; object-fit: cover; border: 1px solid #ddd; margin-bottom: 10px; }
    /* 작은 썸네일 이미지들 정렬 */
    .thumb-container { display: flex; gap: 5px; flex-wrap: wrap; }
    .thumb-img { width: 60px; height: 60px; object-fit: cover; border: 1px solid #ccc; cursor: pointer; }
    .thumb-img:hover { border-color: #333;}
</style>
</head>
<body>
<header>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
</header>
<main>
<h2>${detail.p_title}</h2>
<h3>${detail.p_subtitle}</h3>
<table border="0">
	<tr>
		 <td rowspan="5" width="400" align="center" valign="top">
            <c:set var="imageArray" value="${fn:split(detail.p_image, ',')}" />
            
            <%-- 1. 메인 큰 이미지 (배열의 0번째) --%>
            <c:if test="${not empty imageArray[0]}">
                <img src="/img/${imageArray[0]}" id="mainImage" class="main-img" />
            </c:if>

            <%-- 2. 서브 작은 이미지들 (썸네일) --%>
            <div class="thumb-container">
                <c:forEach var="imageName" items="${imageArray}" varStatus="status">
                    <%-- 모든 이미지를 작은 썸네일로 표시 (클릭 시 메인 변경 기능은 선택 사항) --%>
                    <img src="/img/${imageName}" class="thumb-img" 
                         onclick="document.getElementById('mainImage').src=this.src;" />
                </c:forEach>
            </div>
        </td>
	</tr>
	<tr>
		<td>상품명</td>
		<td>${detail.p_title}</td>
	</tr>
	<tr>
    <td>가격</td>
    	<td class="price-row">
        	<span class="price-text"><fmt:formatNumber value="${detail.p_price}"/></span>
        	<form action="/member/addCart" method="post" style="display: inline-block; margin-left: 20px;">
            	<input type="hidden" name="p_no" value="${detail.p_no}">
            	<label>수량 : </label>
            	<input type="number" name="p_count" value="1" min="1">
            	<input type="submit" value="장바구니 담기">
        	</form>
    	</td>
	</tr>
	<tr>
		<td>분류</td>
		<td>${detail.p_category}</td>
	</tr>
	<tr>
		<td>등록 일자</td>
		<td><fmt:formatDate value="${detail.p_date}" pattern="yyyy-MM-dd"/></td>
	</tr>
</table>
<div class="link-container">
    <a href="productList">목록</a> 
    <a href="/admin/productUpdateForm?p_no=${detail.p_no}">수정</a> 
    <a href="/admin/productDelete?p_no=${detail.p_no}">삭제</a>
</div>
<div class="tab-menu">
    <button class="tab-btn active" onclick="openTab(event, 'tab-detail')">상세정보</button>
    <button class="tab-btn" onclick="openTab(event, 'tab-review')">상품후기 (${reviewList.size()})</button>
</div>

<!-- 탭 내용 1: 상세정보 -->
<div id="tab-detail" class="tab-content active">
    <div class="detail-box">
        ${detail.p_detail}
    </div>
</div>

<!-- 탭 내용 2: 상품후기 -->
<div id="tab-review" class="tab-content">
    <div class="review-box">
        <%@ include file="board.jsp" %> <!-- 후기 로직을 별도 파일로 분리하거나 위 코드를 그대로 삽입 -->
    </div>
</div>
</main>
<footer>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>
</html>