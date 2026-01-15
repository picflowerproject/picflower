<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 1:1 문의</title>
</head>
<body>
<h2>내 문의 내역</h2>

<c:if test="${empty myList}">
  <div>문의 내역이 없습니다.</div>
</c:if>

<c:forEach var="dto" items="${myList}">
  <div style="border:1px solid #ddd; padding:12px; margin:10px 0;">
    <div><b>문의번호:</b> ${dto.q_no}</div>
    <div><b>문의내용:</b> ${dto.q_content}</div>
    <div><b>상태:</b>
      <c:if test="${dto.q_status == '0'}">답변대기</c:if>
      <c:if test="${dto.q_status == '1'}">답변완료</c:if>
    </div>

    <c:if test="${dto.q_status == '1'}">
      <div style="margin-top:8px; color:#333;">
        <b>관리자 답변:</b> ${dto.q_answer}
      </div>
    </c:if>
  </div>
</c:forEach>

</body>
</html>
