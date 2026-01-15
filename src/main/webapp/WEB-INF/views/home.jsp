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
    
     <section class="brand-story">
        <div class="story-container">
            <div class="story-intro">
                <h2>당신의 성격이 꽃이 되고,<br>취향이 선물이 되는 공간 <span>PicFlower</span></h2>
                <p>
                    누구나 소중한 사람에게 꽃을 선물해야 하는 특별한 순간을 마주합니다.<br>
                    하지만 꽃을 잘 모르는 막막함과 선택의 혼란 속에서 망설이고 계셨나요?<br>
                    <strong>픽플라워</strong>는 나만의 성격(꽃)을 공유하고 데이터로 취향을 찾아주는 <strong>SNS형 플라워 커머스</strong>입니다.
                </p>
            </div>

            <div class="feature-layout">
                <div class="feature-item">
                    <div class="txt-area">
                        <span class="num">01</span>
                        <h3>막막한 선택을 확신으로, <strong>픽도우미</strong></h3>
                        <p>꽃을 전혀 몰라도 괜찮습니다. 대상, 목적, 분위기만 체크하세요. 픽플라워만의 단계별 체크리스트 '꽃픽'이 10초 만에 가장 완벽한 해답을 제안합니다.</p>
                    </div>
                </div>

                <div class="feature-item">
                    <div class="txt-area">
                        <span class="num">02</span>
                        <h3>데이터로 증명하는 센스, <strong>트렌드 추천</strong></h3>
                        <p>수많은 유저의 '꽃 버튼(좋아요)'과 구매 데이터를 분석해 나이와 상황에 맞는 실시간 트렌드를 보여드립니다. 오늘의 탄생화 정보로 선물에 깊은 의미를 더해보세요.</p>
                    </div>
                </div>

                <div class="feature-item">
                    <div class="txt-area">
                        <span class="num">03</span>
                        <h3>일상을 사진으로 소통하는, <strong>Flower Garden</strong></h3>
                        <p>나를 닮은 꽃 사진(picflower)을 공유하고 댓글로 소통하세요. 사진 속 꽃이 마음에 든다면 태그를 통해 바로 구매까지! 발견의 즐거움이 쇼핑의 편리함이 됩니다.</p>
                    </div>
                </div>
            </div>

            <div class="story-footer">
                <p>"꽃이 가장 아름다운 지금, 당신의 진심을 <strong>Pick</strong>하세요."</p>
                <span>7일 이내 생생한 후기 작성 시, 다음 감동을 위한 할인 쿠폰을 드립니다. 🌷🌷🌷🌷</span>
            </div>
        </div>
    </section>
</main>
<footer>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>
</html>