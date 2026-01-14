<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home</title>
<link rel="stylesheet" href="/css/home.css">
<script src="/js/home.js" defer></script>
</head>
<body>
<header>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
</header>
<main class="home-main">
    <section class="main-slide">
        <div class="slide-wrapper">
            <div class="slide"><img src="/assets/home1.png"></div>
            <div class="slide"><img src="/assets/home2.png"></div>
            <div class="slide"><img src="/assets/home3.png"></div>
            <div class="slide"><img src="/assets/home4.png"></div>
            <div class="slide"><img src="/assets/home5.png"></div>
            <div class="slide"><img src="/assets/home1.png"></div>
        </div>
    </section>
</main>
<footer>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>
</html>