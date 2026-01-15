<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/loginForm.css">
</head>
<body>

<div class="login-container">
    <div class="login-box">
        <h2>로그인</h2>
        <form name="login" method="post" action="/j_spring_security_check">
            <div class="input-group">
                <input type="text" name="j_username" placeholder="ID" required>
            </div>
            <div class="input-group">
                <input type="password" name="j_password" placeholder="PASSWORD" required>
            </div>
            
            <input type="submit" value="로그인" class="login-btn">
            <input type="reset" value="취소" class="login-btn" style="background-color: #eee; color: #666; margin-top: 5px;">
        </form>
        
        <div class="login-footer">
            <a href="/guest/memberWriteForm">회원가입</a>
        </div>
    </div>
</div>

</body>
</html>