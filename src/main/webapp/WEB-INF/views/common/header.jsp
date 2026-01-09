<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/header.css">
</head>
<body>
<header>
    <!-- 상단 라인 -->
    <div class="top-header">
        <!-- 1. 로고 -->
        <div class="logo">
            <a href="/"><img src="/assets/picflowerLogo.jpg" alt="Picflower Logo"></a>
        </div>

        <!-- 2. 검색창 -->
        <div class="search-bar">
            <form action="/productSearch" method="get" style="display:flex; width:100%;">
                <input type="text" name="searchKeyword" placeholder="오늘은 어떤 꽃을 찾으시나요?">
                <button type="submit">검색</button>
            </form>
        </div>

        <!-- 3. 우측 유저 메뉴 -->
        <div class="user-menu">
            <div class="auth-links">
                <a href="/guest/loginForm">로그인</a>
                <span style="color:#ddd; margin: 0 5px;">|</span>
                <a href="/guest/memberWriteForm">회원가입</a>
            </div>

            <!-- 관리자 드롭박스 -->
            <select class="admin-select" onchange="if(this.value) location.href=this.value;">
                <option value="">관리자 메뉴</option>
                <option value="/admin/n_insertForm">공지 등록</option>
                <option value="/admin/memberList">회원 리스트</option>
                <option value="/admin/flowerList">꽃 리스트</option>
                <option value="/admin/productWriteForm">상품 등록</option>
                <option value="/admin/flowerWriteForm">꽃 등록</option>
            </select>
        </div>
    </div>

    <!-- 4. 네비게이션 라인 -->
    <nav class="nav-bar">
        <div class="nav-container">
            <!-- 테마 드롭다운 -->
            <div class="theme-details">
                <a href="/guest/productList" class="nav-item">테마 상품</a>
            </div>

            <a href="/guest/b_list" class="nav-item">상품 후기</a>
            <a href="/guest/b_list" class="nav-item">트렌드 픽</a>
        </div>
    </nav>
</header>
</body>
</html>