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
    <!-- 이전 버튼 -->
    <c:if test="${currentPage > 1}">
        <a href="?page=${currentPage - 1}" class="page-link">&laquo;</a>
    </c:if>

    <!-- 페이지 번호 -->
    <c:forEach var="i" begin="1" end="${totalPages}">
        <a href="?page=${i}" class="page-link ${i == currentPage ? 'active' : ''}">${i}</a>
    </c:forEach>

    <!-- 다음 버튼 -->
    <c:if test="${currentPage < totalPages}">
        <a href="?page=${currentPage + 1}" class="page-link">&raquo;</a>
    </c:if>
</div>
</body>
</html>