<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원정보 상세보기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/MemberDetail.css">
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <main class="content-wrapper">
        <div class="content-container">

            <h2>회원정보 상세보기</h2>
            
            <table border="1">
                <tr>
                    <td>번호</td>
                    <td>${detail.m_no}</td>
                    <td>아이디</td>
                    <td>${detail.m_id}</td>
                </tr>
                <tr>
                    <td>이름</td>
                    <td>${detail.m_name}</td>
                    <td>성별</td>
                    <td>${detail.m_gender}</td>
                </tr>
                <tr>
                    <td>생년월일</td>
                    <td>${detail.m_birth}</td>
                    <td>연락처</td>
                    <td>${detail.m_tel}</td>
                </tr>
                <tr>
                    <td>주소</td>
                    <td colspan="3">${detail.m_addr}</td>
                </tr>
                <tr>
                    <td>이메일</td>
                    <td>${detail.m_email}</td>
                    <td>좋아하는 꽃</td>
                    <td>${detail.m_flower}</td>
                </tr>
                <tr>
                    <td>가입일</td>
                    <td><fmt:formatDate value="${detail.m_date}" pattern="yyyy-MM-dd"/></td>
                    <td>권한</td>
                    <td>${detail.m_auth}</td>
                </tr>	
            </table>

            <div class="button-container">
                <button type="button" class="btn-lavender" onclick="location.href='/member/memberUpdateForm?m_no=${detail.m_no}'">정보수정</button>
                <button type="button" class="btn-lavender" onclick="history.back()">뒤로가기</button>
            </div>

        </div> 
    </main>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>