<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Header</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/LoginPopup.css">
<link href="fonts.googleapis.com" rel="stylesheet">

</head>
<body>
<div class="login-modal" id="loginModal">
    <div class="login-box">
        <button class="login-close" onclick="closeLogin()">&times;</button>
        <h2 style="margin-bottom:30px; color:#333;">로그인</h2>
        
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="login-input">
                <input type="text" name="username" placeholder="아이디" required>
            </div>
            <div class="login-input">
                <input type="password" name="password" placeholder="비밀번호" required>
            </div>
            <button type="submit" class="login-btn">로그인</button>
        </form>

        <div class="login-divider"></div>

        <!-- 카카오 로그인 버튼 -->
        <div class="social-login-container">
            <a href="${pageContext.request.contextPath}/kakaoLogin" class="kakao-mini-btn">
			    <span class="material-icons" style="margin-right:8px; font-size:18px;">chat_bubble</span>
			    카카오로 시작하기
			</a>
        </div>

        <div class="login-footer">
            <a href="${pageContext.request.contextPath}/memberWriteForm">회원가입</a> | 
            <a href="javascript:void(0)" onclick="closeLogin()">취-소</a>
        </div>
    </div>
</div>

<script>
    const modal = document.getElementById("loginModal");

    function openLogin() { modal.style.display = "flex"; }
    function closeLogin() { modal.style.display = "none"; }

    // 배경 클릭 시 닫기 & ESC 키 입력 시 닫기
    window.onclick = (e) => { if (e.target === modal) closeLogin(); };
    window.onkeydown = (e) => { if (e.key === "Escape") closeLogin(); };
</script>

</body>
</html>
