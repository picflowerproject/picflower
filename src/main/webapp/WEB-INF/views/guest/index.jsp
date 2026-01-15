<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PicFlower - 회사소개</title>
    
    <!-- Google Fonts (Noto Sans KR & Playfair Display) -->
    <link href="fonts.googleapis.com" rel="stylesheet">
    
    <style>
        :root {
            --point-color: #ff4d6d;      
            --sub-color: #ffb3c1;        
            --bg-soft: #fff5f6;          
            --dark-text: #2b2d42;        
            --light-gray: #f8f9fa;       
        }

        body { 
            font-family: 'Noto Sans KR', sans-serif; 
            color: var(--dark-text); 
            line-height: 1.6; /* 줄간격 다시 조밀하게 */
            margin: 0;
            padding: 0;
            background-color: white;
            word-break: keep-all;
        }

        .container {
            width: 90%;
            max-width: 1100px;
            margin: 0 auto;
            padding: 0 15px;
        }

        /* [수정] 섹션별 상하 간격을 적당히 조절 (160px -> 100px) */
        section {
            padding: 100px 0; 
            text-align: center;
        }

        .hero-banner {
            background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), 
                        url('images.unsplash.com'); /* 이미지 경로 수정 */
            background-size: cover;
            background-position: center;
            color: white;
            padding: 140px 0; /* 히어로 섹션 높이 조절 (220px -> 140px) */
        }

        h1 { font-size: 3.2rem; margin-bottom: 1rem; }
        h2 { font-size: 2.2rem; margin-bottom: 1.5rem; font-weight: 700; }
        h3 { font-size: 1.5rem; margin-bottom: 1rem; }
        
        /* [수정] 제목 아래 설명문과의 간격 조절 */
        .section-desc {
            margin-bottom: 2.5rem; /* 여백 축소 (4rem -> 2.5rem) */
            font-size: 1rem;
            color: #6c757d;
        }

        .playfair-font { font-family: 'Playfair Display', serif; }
        .italic { font-style: italic; font-weight: 300; opacity: 0.9; }
        .point-color { color: var(--point-color); }
        .bg-soft { background-color: var(--bg-soft); }
        .bg-dark-card { background-color: var(--dark-text); color: white; }
        

        .row {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 20px; /* 카드 사이 간격 조절 (30px -> 20px) */
            margin-top: 10px;
        }
        
        .col-half { flex-basis: calc(50% - 20px); }
        .col-third { flex-basis: calc(33.33% - 20px); }
        
        @media (max-width: 768px) {
            section { padding: 60px 0; } /* 모바일 섹션 간격도 축소 */
            .col-half, .col-third { flex-basis: 100%; }
            h1 { font-size: 2.5rem; }
            h2 { font-size: 1.8rem; }
        }

        .card {
            padding: 2.5rem 2rem; /* 카드 내부 여백 조절 (4rem -> 2.5rem) */
            border-radius: 1.5rem;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            height: 100%;
            transition: all 0.3s ease;
            border: 1px solid rgba(0,0,0,0.05);
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(255, 77, 109, 0.1);
        }
        .border-point { border: 1.5px solid var(--point-color) !important; }

        .icon-circle {
            width: 70px; /* 아이콘 크기 축소 */
            height: 70px;
            background-color: var(--bg-soft);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin: 0 auto 1rem;
        }

        .btn {
            display: inline-block;
            padding: 0.8rem 2.5rem; /* 버튼 크기 축소 */
            border-radius: 2rem;
            text-decoration: none;
            font-weight: 700;
            letter-spacing: normal;
            transition: all 0.3s;
            margin-top: 1.5rem; /* 버튼 상단 여백 조절 */
        }
        .btn-danger {
            background-color: var(--point-color);
            color: white;
            box-shadow: 0 4px 15px rgba(255, 77, 109, 0.2);
        }
        .btn-danger:hover {
            background-color: #ef233c;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 77, 109, 0.3);
        }
    </style>
</head>
<body>
<header>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
</header>

    <!-- 1. 메인 슬로건 섹션 -->
    <section class="hero-banner">
        <div class="container">
            <h4 class="italic">Premium Flower Curation</h4>
            <h1 class="playfair-font">PicFlower</h1>
            <p>"취향대로 <span class="point-color">픽(Pick)</span>하고 사진(<span class="point-color">Pic</span>)으로 공유하는 꽃의 세계"</p>
        </div>
    </section>

    <!-- 2. 브랜드 의미 및 정체성 -->
    <section>
        <div class="container">
            <h2>사진(Pic) 혹은 선택(Pick)</h2>
            <p class="section-desc">
                PicFlower는 SNS의 핵심인 <strong>시각적 즐거움(Pic)</strong>과 <br>
                커머스의 본질인 <strong>나만의 선택(Pick)</strong>을 결합한 스마트 플랫폼입니다.
            </p>
            
            <div class="row">
                <div class="col-half">
                    <div class="card bg-soft">
                        <h3>📸 Visual Pic</h3>
                        <p class="text-secondary">SNS 감성의 고해상도 사진을 통해 꽃의 생명력을 전달하며,<br>공간과 조화되는 실제 모습을 미리 경험합니다.</p>
                    </div>
                </div>
                <div class="col-half">
                    <div class="card bg-dark-card">
                        <h3 style="color: var(--sub-color);">🎯 Smart Pick</h3>
                        <p class="text-light-opacity">데이터 기반의 큐레이션으로 수많은 꽃들 중 <br>당신의 오늘과 가장 잘 어울리는 한 송이를 제안합니다.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 3. 핵심 서비스 강점 -->
    <section style="background-color: var(--light-gray);">
        <div class="container">
            <h2>PicFlower Strength</h2>
            <div style="width: 50px; height: 3px; background-color: var(--point-color); margin: 0 auto 2.5rem;"></div>
            
            <div class="row">
                <div class="col-third">
                    <div class="card">
                        <div class="icon-circle">🖼️</div>
                        <h4>시각적 커머스</h4>
                        <p class="text-secondary small">필터 없는 리얼 사진 피드로<br>상품의 신뢰와 감성을 동시에 잡았습니다.</p>
                    </div>
                </div>
                <div class="col-third">
                    <div class="card border-point">
                        <div class="icon-circle">👆</div>
                        <h4>취향 큐레이션</h4>
                        <p class="text-secondary small">당신의 클릭과 좋아요를 분석해<br>가장 선호하는 스타일을 먼저 추천합니다.</p>
                    </div>
                </div>
                <div class="col-third">
                    <div class="card">
                        <div class="icon-circle">📱</div>
                        <h4>커뮤니티 기반</h4>
                        <p class="text-secondary small">꽃을 사는 즐거움을 넘어,<br>사진으로 소통하는 새로운 문화를 만듭니다.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 4. CTA(행동 유도) 섹션 -->
    <section>
        <div class="container">
            <h2 style="margin-bottom: 10px;">나를 위한 특별한 픽</h2>
            <p class="text-secondary">지금 PicFlower에서 당신만의 꽃을 발견하세요.</p>
            <a href="/home" class="btn btn-danger">START PICFLOWER</a>
        </div>
    </section>

<footer>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>
</html>