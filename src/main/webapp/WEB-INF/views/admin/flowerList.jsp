<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %> <!-- 문자열 처리를 위해 추가 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>꽃 리스트</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/flowerList.css">
</head>
<body>
<header>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
</header>
<main>
<h2>꽃 리스트</h2>
<table border="1">
    <tr>
        <td>번호</td>
        <td>이미지</td>
        <td>꽃 이름</td>
        <td>영문 이름</td>
        <td>탄생일</td>
    </tr>
    <c:forEach var="item" items="${list}">
    <tr>
        <td>${item.f_no}</td>
        <td>
            <!-- 쉼표로 구분된 파일명 중 첫 번째 이미지만 추출 -->
            <c:set var="firstImg" value="${fn:split(item.f_image, ',')[0]}" />
            <a href="/admin/flowerDetail?f_no=${item.f_no}">
                <img src="/flower_img/${firstImg}" alt="${item.f_name}"/>
            </a>
        </td>
        <td><a href="/admin/flowerDetail?f_no=${item.f_no}">${item.f_name}</a></td>
        <td>${item.f_ename}</td>
        <td>${item.f_birth}</td>
    </tr>
    </c:forEach>
</table>
<a href="flowerWriteForm">꽃 등록</a>
</main>
<footer>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>
</html>