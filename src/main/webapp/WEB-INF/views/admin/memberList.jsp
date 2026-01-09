<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원목록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/memberlist.css">
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<h2>회원목록</h2>
<table border="1">
	<tr>
		<td>회원번호</td>
		<td>아이디</td>
		<td>이름</td>
		<td>성별</td>
		<td>생일</td>
		<td>연락처</td>
		<td>주소</td>
		<td>좋아하는 꽃</td>
	</tr>
	<c:forEach var="list" items="${list}">
	<tr>
		<td>${list.m_no}</td>
		<td><a href="${pageContext.request.contextPath}/member/memberDetail?m_no=${list.m_no}">${list.m_id}</a></td>
		<td>${list.m_name}</td>
		<td>${list.m_gender}</td>
		<td>${list.m_birth}</td>
		<td>${list.m_tel}</td>
		<td>${list.m_addr}</td>
		<td>${list.m_flower}</td>
	</tr>
	</c:forEach>
</table>
<footer>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>
</html>