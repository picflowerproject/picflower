<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원정보 수정</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/MemberUpdate.css">
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <main class="content-wrapper">
        <div class="content-container">
            <h2>회원정보 수정</h2>
            <form name="member" method="post" action="/member/memberUpdate">
                <table border="1">
                    <tr>
                        <td>회원번호</td>
                        <td>${edit.m_no}<input type="hidden" name="m_no" value="${edit.m_no}"></td>
                    </tr>
                    <tr>
                        <td>아이디</td>
                        <td>${edit.m_id}</td>
                    </tr>
                    <tr>
                        <td>이름</td>
                        <td><input type="text" name="m_name" value="${edit.m_name}" required></td>
                    </tr>
                    <tr>
                        <td>성별</td>
                        <td>
                            <input type="radio" name="m_gender" value="남자" <c:if test="${edit.m_gender=='남자'}">checked</c:if>>남자
                            <input type="radio" name="m_gender" value="여자" <c:if test="${edit.m_gender=='여자'}">checked</c:if>>여자
                        </td>
                    </tr>
                    <tr>
                        <td>생년월일</td>
                        <td><input type="text" name="m_birth" value="${edit.m_birth}" maxlength="8"></td>
                    </tr>
                    <tr>
                        <td>연락처</td>
                        <td>
                            <select name="m_tel1">
                                <option value="010" <c:if test="${fn:startsWith(edit.m_tel,'010')}">selected</c:if>>010</option>
                                <option value="011" <c:if test="${fn:startsWith(edit.m_tel,'011')}">selected</c:if>>011</option>
                            </select>-
                            <input type="text" name="m_tel2" size="4" value="${edit.m_tel.substring(4,8)}">-
                            <input type="text" name="m_tel3" size="4" value="${edit.m_tel.substring(9,13)}">
                        </td>
                    </tr>
                    <tr>
                        <td>주소</td>
                        <td><input type="text" name="m_addr" value="${edit.m_addr}" style="width: 80%;"></td>
                    </tr>
                    <tr>
                        <td>이메일</td>
                        <td>
                            <input type="text" name="m_email1" value="${edit.m_email.substring(0, edit.m_email.indexOf('@'))}">@
                            <select name="m_email2">
                                <option value="gmail.com" ${edit.m_email.indexOf('gmail.com')>-1?'selected':''}>gmail.com</option>
                                <option value="naver.com" ${edit.m_email.indexOf('naver.com')>-1?'selected':''}>naver.com</option>
                            </select>
                        </td>
                    </tr>
                </table>

                <div class="button-group">
                    <input type="submit" class="btn-submit" value="수정완료">
                    <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                </div>
            </form>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>