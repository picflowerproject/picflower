<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Header</title>

<!-- 공통 CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<!-- 로그인 팝업 CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/LoginPopup.css">

</head>
<body>
<div class="login-modal" id="loginModal">

    <div class="login-box">
        <span class="login-close" onclick="closeLogin()">×</span>

        <h2>로그인</h2>

        <form action="${pageContext.request.contextPath}/login" method="post">

            <div class="login-input">
                <input type="text" name="username" placeholder="아이디를 입력하세요" required>
            </div>

            <div class="login-input">
                <input type="password" name="password" placeholder="비밀번호를 입력하세요" required>
            </div>

            <button type="submit" class="login-btn">로그인</button>
        </form>

        <div class="login-footer">
            <a href="${pageContext.request.contextPath}/memberWriteForm">회원가입</a> |
            <a href="#">취소</a>
        </div>
    </div>

</div>

<!-- ================= 팝업 JS ================= -->
<script>
function openLogin() {
    document.getElementById("loginModal").style.display = "flex";
}

function closeLogin() {
    document.getElementById("loginModal").style.display = "none";
}

window.onclick = function(e) {
    const modal = document.getElementById("loginModal");
    if (e.target === modal) {
        modal.style.display = "none";
    }
}
</script>

</body>
</html>
