<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/memberwrite.css">
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <main class="content-wrapper">
        <div class="content-container">
            <h2>회원가입</h2>
            <form name="member" method="post" action="memberWrite">
                <table border="1">
                    <tr>
                        <td>아이디</td> 
                        <td><input type="text" name="m_id" required></td>
                    </tr>
                    <tr>
                        <td>비밀번호</td>
                        <td><input type="password" name="m_pwd" required></td>
                    </tr>
                    <tr>
                        <td>비밀번호 확인</td>
                        <td><input type="password" name="m_pwd2" required></td>
                    </tr>
                    <tr>
                        <td>이름</td>
                        <td><input type="text" name="m_name" required></td>
                    </tr>
                    <tr>
                        <td>성별</td>
                        <td>
                            <input type="radio" name="m_gender" value="남자" checked>남자 
                            <input type="radio" name="m_gender" value="여자">여자
                        </td>
                    </tr>
                    <tr>
                        <td>생일</td>
                        <td><input type="text" name="m_birth" required></td>
                    </tr>
                    <tr>
                        <td>연락처</td>
                        <td>
                            <select name="m_tel1">
                                <option value="010">010</option>
                                <option value="011">011</option>
                                <option value="017">017</option>
                                <option value="019">019</option>
                            </select>-
                            <input type="text" name="m_tel2" size="2" maxlength="4">-
                            <input type="text" name="m_tel3" size="2" maxlength="4">
                        </td>
                    </tr>
                    <tr>
                        <td>주소</td>
                        <td><input type="text" name="m_addr"></td>
                    </tr>
                    <tr>
                        <td>이메일</td>
                        <td>
                            <input type="text" name="m_email1">@
                            <select name="m_email2">
                                <option value="gmail.com">gmail.com</option>
                                <option value="naver.com">naver.com</option>
                                <option value="hanmail.net">hanmail.net</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>좋아하는 꽃</td>
                        <td><input type="text" name="m_flower"></td>
                    </tr>
                    <tr>
                        <td>권한</td>
                        <td>
                            <input type="radio" name="m_auth" value="ADMIN">관리자 
                            <input type="radio" name="m_auth" value="MEMBER" checked>회원
                        </td>
                    </tr>
                </table>
                <div class="button-group">
                    <input type="submit" class="btn-submit" value="가입하기">
                    <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                </div>
            </form>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>