<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/footer.css">

</head>
<body>
 <!-- 1. 본문 영역: 이 태그가 핵심입니다. 내용이 없어도 남는 공간을 다 차지합니다. -->
    <div class="content-wrapper">
        <!-- 
             여기에 실제 페이지 내용(게시판 리스트, 상품 상세 등)이 들어갑니다.
             내용이 한 줄도 없어도 푸터는 바닥에 고정됩니다.
        -->
    </div>
<hr> <!-- 본문과 구분하기 위한 선 -->
<footer>
    <div class="footer-container">
        <!-- 왼쪽 영역: 로고 및 CS -->
        <div class="footer-left">
            <div class="brand-logo">
		            <a href="/"><img src="/assets/picflowerLogo.jpg" alt="Logo" ></a></div>
            <p class="slogan">당신의 소중한 순간에 꽃을 더하다.</p>
            <div class="cs-info">
                <span class="cs-title">고객센터</span>
                <strong class="cs-number">02-1234-5678</strong>
                <p class="cs-detail">
                    평일 10:00 - 18:00 (점심 12:00 - 13:00)<br>
                    주말 및 공휴일 휴무
                </p>
                <div class="social-links">
                    <a href="#">Instagram</a> <a href="#">Blog</a> <a href="#">Kakao</a>
                </div>
            </div>
        </div>

        <!-- 오른쪽 영역: 메뉴(위) + 비즈니스 정보(아래) -->
        <div class="footer-right">
            <!-- 우측 상단: 메뉴 -->
            <nav class="footer-nav">
                <a href="/guest/notice">공지사항</a>
                <a href="/guest/about">회사소개</a>
                <a href="/guest/terms">이용약관</a>
                <a href="/guest/privacy" class="priority">개인정보처리방침</a>
                <a href="/guest/customerCenter">고객센터</a>
            </nav>

            <!-- 우측 하단: 비즈니스 정보 -->
            <div class="business-info">
			    <p>
			        <!-- 각 정보 블록을 <span>으로 묶음 -->
			        <span class="info-item"><strong>Picflower (픽플라워)</strong></span> | 
			        <span class="info-item">대표: 이민나</span> | 
			        <span class="info-item">사업자번호: 123-45-67890</span> <br>
			        <span class="info-item">주소: 서울특별시 어딘가 꽃길 123</span> | 
			        <span class="info-item">통신판매업신고: 제 2026-서울강남-0000호</span><br>
			        <span class="info-item">이메일: support@picflower.com</span> | 
			        <span class="info-item">개인정보관리책임자: 이민나</span>
			    </p>
			    
			    <div class="copyright">
			        &copy; 2026 Picflower. All Rights Reserved.
			    </div>
			</div>
        </div>
    </div>
</footer>
</body>
</html>