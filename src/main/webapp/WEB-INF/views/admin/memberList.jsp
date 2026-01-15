<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원목록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/memberlist.css">
<script>
function deleteSelected() {
    const checkboxes = document.querySelectorAll('input[name="m_nos"]:checked');
    if (checkboxes.length === 0) {
        alert("삭제할 회원을 선택해주세요.");
        return;
    }
    if (confirm("정말 삭제하시겠습니까?")) {
        document.getElementById("deleteForm").submit();
    }
}
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<h2>회원목록</h2>

<form id="deleteForm" action="${pageContext.request.contextPath}/member/deleteMembers" method="post">
    <table>
        <tr>
            <td width="8%">번호</td>
            <td width="15%">아이디</td>
            <td width="12%">이름</td>
            <td width="8%">성별</td>
            <td width="15%">생일</td>
            <td width="15%">연락처</td>
            <td width="17%">좋아하는 꽃</td>
            <td width="10%">선택 <input type="checkbox" id="selectAll" onclick="for(c of document.getElementsByName('m_nos')) c.checked=this.checked"></td>
        </tr>
        <c:forEach var="list" items="${list}">
        <tr>
            <td>${list.m_no}</td>
            <td><a href="${pageContext.request.contextPath}/member/memberDetail?m_no=${list.m_no}">${list.m_id}</a></td>
            <td>${list.m_name}</td>
            <td>${list.m_gender}</td>
            <td>
                <%-- String을 Date로 변환 후 출력 (시분초 제외) --%>
                <fmt:parseDate value="${list.m_birth}" var="birthDate" pattern="yyyy-MM-dd HH:mm:ss" />
                <fmt:formatDate value="${birthDate}" pattern="yyyy-MM-dd" />
            </td>
            <td>${list.m_tel}</td>
            <td>${list.m_flower}</td>
            <td><input type="checkbox" name="m_nos" value="${list.m_no}"></td>
        </tr>
        </c:forEach>
    </table>
    
    <div class="button-container">
        <button type="button" onclick="deleteSelected()">선택 삭제</button>
    </div>
</form>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>