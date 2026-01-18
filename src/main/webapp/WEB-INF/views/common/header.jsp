<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Flower Garden</title>
    <script src="${pageContext.request.contextPath}/js/simple_board.js"></script>
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
		   <form action="${pageContext.request.contextPath}/guest/productSearch" method="get" class="search-form">
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
    <sec:authentication property="principal" var="user" />
    
    <div class="welcome-msg">
        <strong>
            <c:choose>
                <%-- 1. 카카오 유저인지 확인 (패키지 경로로 확인하는 것이 가장 확실함) --%>
                <c:when test="${fn:contains(user.getClass().name, 'OAuth2User')}">
                    <%-- 카카오 닉네임 출력 --%>
                    <c:out value="${user.attributes.properties.nickname}" />
                </c:when>
                
                <%-- 2. 일반 유저인 경우 --%>
                <c:otherwise>
                    <%-- 일반 유저는 attributes가 없으므로 이 블록에서만 username 호출 --%>
                    <c:out value="${user.username}" />
                </c:otherwise>
            </c:choose>
        </strong><span>님, 환영합니다!</span>
    </div>

    <div class="icon-group">
        <%-- 마이페이지 링크 m_id 결정 --%>
        <c:set var="mId">
            <c:choose>
                <c:when test="${fn:contains(user.getClass().name, 'OAuth2User')}">
                    ${user.name}
                </c:when>
                <c:otherwise>
                    ${user.username}
                </c:otherwise>
            </c:choose>
        </c:set>
        <a href="/member/memberDetailId?m_id=${mId}"><i class="fa-regular fa-user"></i></a>
                
                <a href="/member/cartList" title="장바구니"><i class="fa-solid fa-cart-shopping"></i></a>
                 <sec:authorize access="hasRole('ROLE_ADMIN')">
                    <%-- 관리자 메뉴 --%>
                    <a href="/admin/qnaList" title="문의답변"><i class="fa-solid fa-comments"></i></a>
                </sec:authorize>
                <a href="/logout" title="로그아웃"><i class="fa-solid fa-right-from-bracket"></i></a>
				<sec:authorize access="hasRole('ROLE_ADMIN')">
                <div class="admin-menu-container">
                        <i class="fa-solid fa-gear admin-icon"></i>
                        <select class="admin-select" onchange="if(this.value) location.href=this.value;">
                            <option value="">관리자 메뉴</option>
                            <option value="/admin/n_insertForm">공지 등록</option>
                            <option value="/admin/memberList">회원 리스트</option>
                            <option value="/admin/productWriteForm">상품 등록</option>
                            <option value="/admin/qnaList">1:1 문의 관리</option>
                            
                        </select>
                    </div>
                    </sec:authorize>
            </div>
        </div>
    </sec:authorize>
</div>  
   </div> <!-- .user-info-box 닫기 -->
    </div>


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

// ✅ 로직 통합: 하나로 관리하여 중복 실행 방지
$(document).ready(function() {
    const urlParams = new URLSearchParams(window.location.search);
    
    // 1. 에러 파라미터 확인 (loginError 또는 error)
    if (urlParams.has('loginError') || urlParams.has('error')) {
        
        // 2. [핵심] 주소창에서 에러 파라미터 즉시 제거
        // 새로고침 시 다시 실행되지 않도록 함
        const newUrl = window.location.pathname;
        window.history.replaceState({}, document.title, newUrl);
        
        // 3. 모달 열기 및 알림
        openLoginModal();
        alert("아이디 또는 비밀번호가 일치하지 않습니다.");
    }
});
</script>
</body>