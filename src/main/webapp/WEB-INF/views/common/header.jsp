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
                <button type="submit">검색</button>
            </form>
        </div>

        <!-- 3. 우측 유저 메뉴 -->

		<div class="user-menu">
		  	<sec:authorize access="isAnonymous()">
                <div class="auth-links">
                    <a href="/guest/loginForm">로그인</a>
                    <span style="color:#eee; margin:0 10px;">|</span>
                    <a href="/guest/memberWriteForm">회원가입</a>
                </div>
            </sec:authorize>
		
		    <sec:authorize access="isAuthenticated()">
		        <div class="user-info-box">
				    <div class="icon-group">
				        <!-- 마이페이지 -->
				        <a href="/member/memberDetailId?m_id=<sec:authentication property='principal.username'/>" title="마이페이지">
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
				
				        <!-- 관리자 메뉴: 로그아웃 바로 옆에 배치 -->
				        <sec:authorize access="hasRole('ROLE_ADMIN')">
				            <div class="admin-menu-container">
				                <i class="fa-solid fa-gear admin-icon"></i>
				                <select class="admin-select" onchange="if(this.value) location.href=this.value;">
				                    <option value="">관리자</option>
				                    <option value="/admin/n_insertForm">공지 등록</option>
				                    <option value="/admin/memberList">회원 리스트</option>
				                    <option value="/admin/productWriteForm">상품 등록</option>
				                    <option value="/admin/flowerList">꽃 리스트</option>
				                </select>
				            </div>
				        </sec:authorize>
				    </div>
				    
				    <div class="welcome-msg">
				        <strong><sec:authentication property="principal.username"/></strong>님 환영합니다.
				    </div>
				</div>
		    </sec:authorize>
		</div>
    </div>

    <!-- 4. 사라졌던 네비게이션 메뉴 바 -->
    <nav class="nav-bar">
        <div class="nav-container">
            <a href="/guest/productList" class="nav-item">테마 상품</a>
            <a href="/guest/trendPic" class="nav-item">트렌드 픽</a>
            <a href="/guest/b_list" class="nav-item">상품 후기</a>          
        </div>
    </nav>
</header>