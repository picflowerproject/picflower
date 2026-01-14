<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Flower Garden</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/homeHeader.css">
	
	
</head>
<body>
<header>
    <div class="top-header">
        <!-- 1. 로고 -->
        <div class="logo">
            <a href="/"><img src="/assets/picflowerLogo.jpg" alt="Picflower Logo"></a>
        </div>

        <!-- 2. 검색창 -->
		<div class="search-bar">
		    <form action="/productSearch" method="get" class="search-form">
		        <input type="text" name="searchKeyword" placeholder="오늘은 어떤 꽃을 찾으시나요?">
		        <button type="submit">검색</button>
		    </form>
		</div>

        <!-- 3. 우측 유저 메뉴 -->
		<div class="user-menu">
		    <div class="auth-links">
		        <sec:authorize access="isAnonymous()">
		            <!-- 로그인하지 않은 일반 방문자에게 보이는 메뉴 -->
		            <a href="/guest/loginForm">로그인</a>
		            <span class="divider">|</span>
		            <a href="/guest/memberWriteForm">회원가입</a>
		        </sec:authorize>

		        <sec:authorize access="isAuthenticated()">
		            <!-- 로그인한 모든 사용자에게 보이는 메뉴 -->
		            <span class="welcome-msg">
		                <strong class="user-id">${userName}</strong>님 반갑습니다
		            </span>
		            <span class="divider">|</span>
		            <a href="/logout" class="logout-link">로그아웃</a>
		        </sec:authorize>
		    </div>

		    <!-- [핵심] 관리자(ROLE_ADMIN) 권한이 있는 경우에만 메뉴 출력 -->
		    <sec:authorize access="hasRole('ROLE_ADMIN')">
		        <select class="admin-select" onchange="if(this.value) location.href=this.value;">
		            <option value="">관리자 메뉴</option>
		            <option value="/admin/n_insertForm">공지 등록</option>
		            <option value="/admin/memberList">회원 리스트</option>
		            <option value="/admin/flowerList">꽃 리스트</option>
		            <option value="/admin/productWriteForm">상품 등록</option>
		            <option value="/admin/flowerWriteForm">꽃 등록</option>
		        </select>
		    </sec:authorize>
		</div>
    </div>

    <!-- 4. 네비게이션 라인 -->
    <nav class="nav-bar">
        <div class="nav-container">
            <div class="theme-details">
                <a href="/guest/productList" class="nav-item">테마 상품</a>
            </div>
            <a href="/guest/b_list" class="nav-item">상품 후기</a>
            <a href="/guest/b_list" class="nav-item">트렌드 픽</a>
        </div>
    </nav>
</header>