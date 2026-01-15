<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Flower Garden</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/loginPopup.css">
</head>
<body>
<header>
    <div class="top-header">
        <!-- 1. 로고 -->
        <div class="logo">
            <a href="/"><img src="/assets/picflowerLogo.jpg" alt="Picflower Logo"></a>
        </div>

        <!-- 2. 검색창 (중앙 고정) -->
     <div class="search-bar">
		    <form action="/productSearch" method="get" class="search-form">
		        <input type="text" name="searchKeyword" placeholder="오늘은 어떤 꽃을 찾으시나요?">
		        <!-- 텍스트 '검색' 대신 아이콘으로 변경 -->
		        <button type="submit">
		            <i class="fa-solid fa-magnifying-glass fa-xl" style="color: #a36cd9;"></i>
		        </button>
		    </form>
		</div>

        <!-- 3. 우측 유저 메뉴 -->

		<div class="user-menu">
    <%-- 1. 비로그인 상태 --%>
    <sec:authorize access="isAnonymous()">
        <div class="auth-links">
            <a href="javascript:void(0);" onclick="openLoginModal()">로그인</a>
            <span style="color:#eee; margin:0 10px;">|</span>
            <a href="/guest/memberWriteForm">회원가입</a>
        </div>
    </sec:authorize>

    <%-- 2. 로그인 상태 --%>
    <sec:authorize access="isAuthenticated()">
        <div class="user-info-box">
            <div class="welcome-msg">
			    <strong><sec:authentication property="name"/></strong><span>님, 환영합니다!</span>
			</div>
            <div class="icon-group">
                <!-- 마이페이지 -->
                <a href="/member/memberDetailId?m_id=<sec:authentication property='name'/>" title="마이페이지">
                    <i class="fa-regular fa-user"></i>
                </a>
                <!-- 장바구니 -->
                <a href="/member/cartList" title="장바구니">
                    <i class="fa-solid fa-cart-shopping"></i>
                </a>
                <!-- 로그아웃 -->
                <a href="/logout" title="로그아웃">
                    <i class="fa-solid fa-right-from-bracket"></i>
                </a>

                <!-- 관리자 메뉴: 정확한 태그 닫기 필수 -->
                <sec:authorize access="hasRole('ROLE_ADMIN')">
                		<a href="/admin/qnaList" class="admin-qna-icon" title="1:1 문의 답변">
			        <i class="fa-solid fa-comments"></i>
			    </a>
                
                    <div class="admin-menu-container">
                        <i class="fa-solid fa-gear admin-icon"></i>
                        <select class="admin-select" onchange="if(this.value) location.href=this.value;">
                            <option value="">관리자 메뉴</option>
                            <option value="/admin/n_insertForm">공지 등록</option>
                            <option value="/admin/memberList">회원 리스트</option>
                             <option value="/admin/qnaList">1:1 문의 관리</option>
                            <option value="/admin/productWriteForm">상품 등록</option>
                        </select>
                    </div>
                </sec:authorize> 
            </div> <!-- .icon-group 닫기 -->
        </div> <!-- .user-info-box 닫기 -->
    </sec:authorize>
</div> <!-- .user-menu 닫기 -->
    </div>

    <!-- 4. 사라졌던 네비게이션 메뉴 바 -->
    <nav class="nav-bar">
        <div class="nav-container">
            <a href="/guest/productList" class="nav-item">테마 상품</a>
            <a href="/guest/trendPic" class="nav-item">트렌드 픽</a>
            <a href="/guest/b_list" class="nav-item">상품 후기</a>          
        </div>
    </nav>
    
    
<%-- 로그인 모달 (header.jsp 하단에 배치) --%>
<div id="loginModal" class="login-modal">
    <div class="login-box">
        <!-- 닫기 버튼 -->
        <button type="button" class="login-close" onclick="closeLoginModal()">&times;</button>
        
        <h2 style="color: #a36cd9; margin-bottom: 30px;">로그인</h2>
        
        <form action="/login" method="post">
            <%-- CSRF 토큰 (Security 설정에 따라 필요) --%>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            
            <div class="login-input">
                <input type="text" name="username" placeholder="아이디" required>
                <input type="password" name="password" placeholder="비밀번호" required>
            </div>
            
            <button type="submit" class="login-btn">로그인</button>
            
            <div class="login-divider"></div>
            
            <div class="social-login-container">
                <a href="/oauth2/authorization/kakao" class="kakao-mini-btn">
                    <img src="${pageContext.request.contextPath}/assets/kakao_icon.png" alt="카카오 로고">
                    카카오로 시작하기
                </a>
            </div>
            
            <div class="login-footer">
                <span>아직 회원이 아니신가요?</span>
                <a href="${pageContext.request.contextPath}/guest/memberWriteForm">회원가입</a>
            </div>
        </form>
    </div>
</div>
</header>

<script>
function openLoginModal() {
    document.getElementById('loginModal').style.display = 'flex';
}
function closeLoginModal() {
    document.getElementById('loginModal').style.display = 'none';
}

// ✅ [중요] 로그인 실패 후 리다이렉트 되었을 때 자동으로 팝업 다시 띄우기
window.onload = function() {
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('error')) {
        openLoginModal();
        alert("아이디 또는 비밀번호가 일치하지 않습니다.");
    }
}
</script>
</body>