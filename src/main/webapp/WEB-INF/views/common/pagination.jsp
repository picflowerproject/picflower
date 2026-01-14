<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/pagenation.css">
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="pagination">
    <c:set var="pageCut" value="5" /> <%-- 현재 페이지 기준 앞뒤로 5개씩만 보여줌 --%>
    <c:set var="startPage" value="${currentPage - pageCut > 1 ? currentPage - pageCut : 1}" />
    <c:set var="endPage" value="${currentPage + pageCut < totalPages ? currentPage + pageCut : totalPages}" />

    <!-- 이전 버튼 -->
    <c:if test="${currentPage > 1}">
        <%-- param. 을 반드시 붙여야 합니다 --%>
        <a href="?page=${currentPage - 1}${param.appendQuery}" class="page-link">&laquo;</a>
    </c:if>

    <!-- 페이지 번호 루프 (시작/끝 제한) -->
    <c:forEach var="i" begin="${startPage}" end="${endPage}">
        <a href="?page=${i}${param.appendQuery}" 
           class="page-link ${i == currentPage ? 'active' : ''}">${i}</a>
    </c:forEach>

    <!-- 다음 버튼 -->
    <c:if test="${currentPage < totalPages}">
        <a href="?page=${currentPage + 1}${param.appendQuery}" class="page-link">&raquo;</a>
    </c:if>
</div>
</body>
</html>