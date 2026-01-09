<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/FindPassword.css">
</head>
<body>
<div class="find-page">
    <div class="find-container">
        <div class="find-box">
            <h2>비밀번호 찾기</h2>
            <form action="${pageContext.request.contextPath}/findPasswordResult" method="post">
                <div class="input-group">
                    <input type="text" name="m_id" placeholder="아이디" required>
                </div>
                <div class="input-group">
                    <input type="password" name="m_pwd" placeholder="비밀번호" required>
                </div>
                <button type="submit" class="find-btn">확인</button>
            </form>
            <div class="find-footer">
                <a href="${pageContext.request.contextPath}/home">홈으로</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>