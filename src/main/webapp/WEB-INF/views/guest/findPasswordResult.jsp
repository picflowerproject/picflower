<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기 결과</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/FindPassword.css">
</head>
<body>
<div class="find-page">
    <div class="find-container">
        <div class="find-box">
            <h2>확인 결과</h2>
            <p style="margin-top:30px; font-size:16px;">
                ${message}
            </p>
            <div class="find-footer">
                <a href="${pageContext.request.contextPath}/findPassword">다시 시도</a>
                |
                <a href="${pageContext.request.contextPath}/home">홈으로</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>