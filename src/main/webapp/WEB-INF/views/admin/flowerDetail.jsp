<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>꽃 상세정보</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/flowerDetail.css">
<style>
    /* 큰 이미지 스타일 */
    .main-img { width: 350px; height: 400px; object-fit: cover; border: 1px solid #ddd; margin-bottom: 10px; }
    /* 작은 썸네일 이미지들 정렬 */
    .thumb-container { display: flex; gap: 5px; flex-wrap: wrap; }
    .thumb-img { width: 60px; height: 60px; object-fit: cover; border: 1px solid #ccc; cursor: pointer; }
    .thumb-img:hover { border-color: #333; }
</style>
</head>
<body>
<header>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
</header>
<h2>꽃 상세정보</h2>
<table border="1">
    <tr>
        <td rowspan="5" width="400" align="center" valign="top">
            <c:set var="imageArray" value="${fn:split(detail.f_image, ',')}" />
            
            <%-- 1. 메인 큰 이미지 (배열의 0번째) --%>
            <c:if test="${not empty imageArray[0]}">
                <img src="/flower_img/${imageArray[0]}" id="mainImage" class="main-img" />
            </c:if>

            <%-- 2. 서브 작은 이미지들 (썸네일) --%>
            <div class="thumb-container">
                <c:forEach var="imageName" items="${imageArray}" varStatus="status">
                    <%-- 모든 이미지를 작은 썸네일로 표시 (클릭 시 메인 변경 기능은 선택 사항) --%>
                    <img src="/flower_img/${imageName}" class="thumb-img" 
                         onclick="document.getElementById('mainImage').src=this.src;" />
                </c:forEach>
            </div>
        </td>
        <td width="120">번호</td>
        <td>${detail.f_no}</td>
    </tr>
    <tr>
        <td>꽃 이름</td>
        <td>${detail.f_name}</td>
    </tr>
    <tr>
        <td>꽃 영문이름</td>
        <td>${detail.f_ename}</td>
    </tr>
    <tr>
        <td>꽃말</td>
        <td>${detail.f_language}</td>
    </tr>
    <tr>
        <td>탄생일</td>
        <td>${detail.f_birth}</td>
    </tr>
    <tr>
        <td colspan="3">꽃 정보</td>
    </tr>
    <tr>
        <td colspan="3">${detail.f_detail}</td>
    </tr>
     <tr>
        <td colspan="3">꽃 정보</td>
    </tr>
    <tr>
        <td colspan="3">${detail.f_detail}</td>
    </tr>
     <tr>
        <td colspan="3">꽃 이용</td>
    </tr>
    <tr>
        <td colspan="3">${detail.f_use}</td>
    </tr>
     <tr>
        <td colspan="3">꽃 기르기</td>
    </tr>
    <tr>
        <td colspan="3">${detail.f_raise}</td>
    </tr>
</table>

<div class="button-group">
    <a href="flowerList">꽃 목록</a> 
    <a href="flowerUpdateForm?f_no=${detail.f_no}">수정</a> 
    <a href="flowerDelete?f_no=${detail.f_no}">삭제</a>
</div>
<footer>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>
</html>