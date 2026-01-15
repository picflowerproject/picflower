<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>TrendPic</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/trendPic.css">
<style>
    .seconde-love-container {
        padding: 120px 20px;
        background-color: #f9f9f9;
        text-align: center;
    }

    /* 배경에 흐릿하게 깔리는 대형 타이틀 효과 */
    .love-text-group {
        position: relative;
        margin-bottom: 80px;
    }

    .love-title {
        display: block;
        font-size: 5rem; /* 매우 큰 사이즈 */
        font-weight: 900;
        color: #eee; /* 배경과 유사한 아주 연한 그레이 */
        text-transform: uppercase;
        letter-spacing: 10px;
        position: absolute;
        width: 100%;
        top: -70px;
        z-index: 0;
    }

    .love-text {
        position: relative;
        z-index: 1;
        display: block;
        font-size: 1.8rem;
        font-weight: 600;
        color: #111;
		top: 20px;
        letter-spacing: -1px;
    }

    /* 상품 카드: 테두리 없이 깔끔한 스타일 */
    .seconde-love-inner {
        max-width: 1300px;
        margin: 0 auto;
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 20px; /* 간격을 좁혀 밀도감 상승 */
    }

    .product-box {
        position: relative;
        overflow: hidden;
    }

    .image-container {
        aspect-ratio: 3 / 4;
        overflow: hidden;
        background: #eee;
    }

    .product-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        filter: grayscale(20%); /* 약간의 채도 감소로 차분함 유지 */
        transition: all 0.6s cubic-bezier(0.165, 0.84, 0.44, 1);
    }

    .product-box:hover .product-img {
        filter: grayscale(0%);
        transform: scale(1.03);
    }

    /* 하단에서 올라오는 심플한 정보 바 */
    .product-overlay {
        position: absolute;
        bottom: 0;
        left: 0;
        width: 100%;
        padding: 30px 20px;
        background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);
        color: #fff;
        opacity: 0;
        transition: opacity 0.3s ease;
        text-align: left;
    }

    .product-box:hover .product-overlay {
        opacity: 1;
    }

    .overlay-title { font-size: 1.1rem; font-weight: 400; }
    .overlay-price { font-size: 1rem; color: #bbb; margin-top: 5px; }
	
	/* 컨테이너 전체: 2026년 트렌드 컬러인 '어스 톤(Earth Tone)' 적용 */
	.third-apology-container {
	    padding: 120px 0;
	    background-color: #dcd3c9; /* 깊이감이 있는 샌드 베이지색 */
	    color: #4a443f;
	}

	/* 컨테이너 및 배경 */
	.third-apology-container {
	    padding: 100px 0;
	    background-color: #dcd3c9; /* 차분한 샌드 베이지 */
	    color: #4a443f;
	}

	.apology-text-group {
	    text-align: center;
	    margin-bottom: 60px;
	}

	.apology-main-title {
	    font-size: 32px;
	    font-family: 'Noto Serif KR', serif;
	    margin: 10px 0 20px;
	}

	/* 상품 그리드 */
	.third-apology-inner {
	    max-width: 1200px;
	    margin: 0 auto;
	    display: grid;
	    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
	    gap: 30px;
	    padding: 0 20px;
	}

	/* 이미지 및 호버 컨테이너 */
	.apology-thumb-wrap {
	    position: relative;
	    overflow: hidden;
	    aspect-ratio: 1 / 1.1; /* 약간 세로로 긴 비율 */
	    background-color: #c9bfb4;
	    border-radius: 4px;
	}

	.apology-thumb-img {
	    width: 100%;
	    height: 100%;
	    object-fit: cover;
	    transition: transform 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94);
	}

	/* 호버 오버레이 (초기 상태: 투명 및 약간 아래 배치) */
	.apology-hover-overlay {
	    position: absolute;
	    top: 0; left: 0;
	    width: 100%; height: 100%;
	    background: rgba(56, 50, 45, 0.7); /* 톤다운된 브라운 블랙 오버레이 */
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    opacity: 0;
	    transition: all 0.4s ease-in-out;
	}

	.hover-content {
	    text-align: center;
	    color: #fff;
	    transform: translateY(20px); /* 아래에서 위로 올라오는 효과를 위한 초기값 */
	    transition: transform 0.4s ease-in-out;
	    padding: 20px;
	}

	/* 호버 시 텍스트 스타일 */
	.hover-title {
	    font-size: 20px;
	    font-weight: 500;
	    margin-bottom: 10px;
	}

	.hover-line {
	    width: 30px;
	    height: 1px;
	    background-color: #dcd3c9;
	    margin: 15px auto;
	}

	.hover-price {
	    font-size: 16px;
	    letter-spacing: 1px;
	    margin-bottom: 20px;
	}

	.hover-view-more {
	    font-size: 11px;
	    letter-spacing: 2px;
	    border-bottom: 1px solid #fff;
	    padding-bottom: 3px;
	    opacity: 0.8;
	}

	/* Hover Action */
	.apology-item-card:hover .apology-hover-overlay {
	    opacity: 1;
	}

	.apology-item-card:hover .hover-content {
	    transform: translateY(0); /* 제자리로 이동 */
	}

	.apology-item-card:hover .apology-thumb-img {
	    transform: scale(1.1); /* 이미지 미세 확대 */
	}

	.apology-link {
	    text-decoration: none;
	}
	
	.best-products-container {
	    max-width: 1200px;
	    margin: 60px auto;
	    padding: 0 20px;
	}

	.best-products-container h2 {
	    display: flex;
	    flex-direction: column; /* 위아래 두 줄 구성 */
	    align-items: center;
	    gap: 8px;
	    margin-bottom: 50px;
	    font-family: 'Pretendard', sans-serif; /* 깔끔한 폰트 권장 */
	}

	/* 메인 타이틀: 세련된 영문과 한글 조합 */
	.best-products-container h2::before {
	    content: "WEEKLY BEST"; /* 상단에 작은 영문 텍스트 추가 */
	    font-size: 0.85rem;
	    color: #ff4757; /* 브랜드 포인트 컬러 */
	    letter-spacing: 4px;
	    font-weight: 700;
	}

	.best-products-container h2::after {
	    content: ""; /* 하단 장식 선 */
	    width: 40px;
	    height: 3px;
	    background-color: #222;
	    margin-top: 15px;
	    border-radius: 2px;
	}

	/* 본 텍스트 스타일링 */
	.best-products-container h2 span {
	    font-size: 2.4rem;
	    font-weight: 700;
	    color: #111;
	    letter-spacing: -1.5px;
	    position: relative;
	}

	/* 트리맵 그리드 핵심 설정 */
	.treemap-grid {
	    display: grid;
	    grid-template-columns: repeat(4, 1fr); /* 4열 */
	    grid-template-rows: repeat(3, 220px); /* 3행 */
	    gap: 12px;
	    /* 영역 정의 */
	    grid-template-areas: 
	        "r1 r1 r2 r3"
	        "r1 r1 r2 r4"
	        "r5 r6 r7 r4";
	}

	/* 각 순위별 영역 할당 */
	.rank-1 { grid-area: r1; }
	.rank-2 { grid-area: r2; }
	.rank-3 { grid-area: r3; }
	.rank-4 { grid-area: r4; }
	.rank-5 { grid-area: r5; }
	.rank-6 { grid-area: r6; }
	.rank-7 { grid-area: r7; }

	/* 공통 아이템 스타일 */
	.best-item {
	    position: relative;
	    border-radius: 15px;
	    overflow: hidden;
	    background-color: #f0f0f0;
	}

	.best-item a { display: block; width: 100%; height: 100%; }

	.product-img {
	    width: 100%;
	    height: 100%;
	    object-fit: cover;
	    transition: transform 0.6s cubic-bezier(0.165, 0.84, 0.44, 1);
	}

	/* 호버 오버레이 (숨김 상태) */
	.info-overlay {
	    position: absolute;
	    inset: 0; /* top, left, right, bottom: 0 */
	    background: rgba(0, 0, 0, 0.7);
	    backdrop-filter: blur(4px); /* 배경 살짝 흐리게 (트렌디한 효과) */
	    display: flex;
	    flex-direction: column;
	    justify-content: center;
	    align-items: center;
	    opacity: 0;
	    transition: all 0.4s ease;
	    padding: 20px;
	}

	.best-item:hover .info-overlay { opacity: 1; }
	.best-item:hover .product-img { transform: scale(1.08); }

	/* 배지 및 텍스트 */
	.rank-badge {
	    font-size: 1.5rem;
	    font-weight: 900;
	    color: #fff;
	    border-bottom: 2px solid #fff;
	    margin-bottom: 10px;
	}

	.p-title {
	    color: #fff;
	    font-size: 1rem;
	    font-weight: 400;
	    text-align: center;
	    margin: 5px 0;
	    /* 긴 제목 처리 */
	    display: -webkit-box;
	    -webkit-line-clamp: 2;
	    -webkit-box-orient: vertical;
	    overflow: hidden;
	}

	.p-price {
	    color: #fff; /* 가격에 포인트 색상 */
	    font-size: 1.1rem;
	    font-weight: 700;
	}

	/* 상위권 특별 크기 조절 */
	.rank-1 .rank-badge { font-size: 3rem; }
	.rank-1 .p-title { font-size: 1.4rem; }
	.rank-2 .p-title, .rank-4 .p-title { font-size: 1.1rem; }

	/* 반응형 모바일 (2열로 변경) */
	@media (max-width: 900px) {
	    .treemap-grid {
	        grid-template-columns: repeat(2, 1fr);
	        grid-template-rows: auto;
	        grid-template-areas: none;
	    }
	    .best-item { grid-area: auto !important; height: 250px; }
	    .rank-1 { grid-column: 1 / 3; height: 350px; }
	}
</style>
<script>
	const contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/trendPic.js"></script>
</head>
<body>
	<header id="main-header">
		<%@ include file="/WEB-INF/views/common/header.jsp" %>
	</header>
	<div class="main-layout-container">
	    <div class="main-layout-inner"> <!-- 가로 배치를 담당하는 부모 -->
	        
	        <!-- 왼쪽 텍스트 섹션 -->
	        <div class="left-section">
	            <div class="birth-date">${flowerInfo.f_birth}</div>
	            <div class="main-title">오늘의 꽃</div>
	            
	            <div class="flower-info-section">
	                 <c:if test="${not empty flowerInfo}">
	                     <div>${flowerInfo.f_name}</div>
	                     <div>${flowerInfo.f_ename}</div>
	                     <div>꽃말: ${flowerInfo.f_language}</div>
	                 </c:if>
	            </div>

	            <div class="text-box">
	                <span class="badge">Flower Story</span>
	                <div class="scroll-content-wrapper">
	                    <p class="content-slide active"><strong>상세정보:</strong><br>${flowerInfo.f_detail}</p>
	                    <p class="content-slide"><strong>용도:</strong><br>${flowerInfo.f_use}</p>
	                    <p class="content-slide"><strong>기르는 법:</strong><br>${flowerInfo.f_raise}</p>
	                </div>
	            </div>
	        </div> <!-- left-section 끝 -->

	        <!-- 오른쪽 이미지 섹션 (반드시 inner 안에 있어야 가로로 배치됨) -->
			<div class="right-section">
			    <div class="custom-slider">
			        <!-- 모든 이미지를 가로로 한 줄 배치할 컨테이너 -->
					<div class="slider-wrapper" id="sliderWrapper">
					    <c:set var="imageUrls" value="${fn:split(flowerInfo.f_image, ',')}" />
					    <c:forEach var="imageUrl" items="${imageUrls}">
					        <%-- 1. 앞뒤 공백 제거 --%>
					        <c:set var="tempUrl" value="${fn:trim(imageUrl)}" />
					        <%-- 2. 파일명 중간에 숨은 모든 공백 제거 (replace 사용) --%>
					        <c:set var="cleanUrl" value="${fn:replace(tempUrl, ' ', '')}" />
					        
					        <div class="slide">
					            <img src="${pageContext.request.contextPath}/flower_img/${cleanUrl}" alt="꽃 이미지">
					        </div>
					    </c:forEach>
					</div>
			        
			        <button class="prev-btn" onclick="moveSlide(-1)">❮</button>
			        <button class="next-btn" onclick="moveSlide(1)">❯</button>
			    </div>
			</div><!--right-section 끝-->

	    </div> <!-- main-layout-inner 끝 (확인) -->
	</div> <!-- main-layout-container 끝 (확인) -->
	<div class="seconde-love-container"> 
	    <!-- 상단 텍스트 영역 -->
	    <div class="love-text-group">
	        <span class="love-title">사랑과 고백</span>
	        <span class="love-text">"첫눈에 반한 순간부터 오늘까지, 꽃으로 쓰는 사랑의 편지"</span>
	    </div>
	    
	    <div class="seconde-love-inner"> 
	        <c:forEach var="product" items="${productList}">
	            <div class="product-box">
	                <div class="image-container">
	                    <a href="${pageContext.request.contextPath}/guest/productDetail?p_no=${product.p_no}" class="product-link">
	                        <c:set var="imgs" value="${fn:split(product.p_image, ',')}" />
	                        <c:if test="${not empty imgs}">
	                            <img src="${pageContext.request.contextPath}/product_img/${fn:trim(imgs[0])}" 
	                                 class="product-img" alt="대표 이미지" />
	                        </c:if>
	                        
	                        <div class="product-overlay">
	                            <div class="overlay-content">
	                                <h3 class="overlay-title">${product.p_title}</h3>
	                                <p class="overlay-price">
	                                    <fmt:formatNumber value="${product.p_price}" type="number"/>원
	                                </p>
	                            </div>
	                        </div>
	                    </a>
	                </div>
	            </div>
	        </c:forEach>
	    </div>
	</div>
	<div class="third-apology-container"> 
	    <!-- 상단 헤더 영역 -->
	    <div class="apology-text-group">
	        <span class="apology-label">화해와 용서</span>
	        <h2 class="apology-main-title">말보다 깊은 진심, 화해의 꽃</h2>
	        <p class="apology-sub-text">서툰 마음을 대신 전하는 정갈한 꽃 한 송이</p>
	    </div>
	    
	    <div class="third-apology-inner"> 
	        <c:forEach var="product" items="${productList}">
	            <div class="apology-item-card">
	                <a href="${pageContext.request.contextPath}/guest/productDetail?p_no=${product.p_no}" class="apology-link">
	                    <div class="apology-thumb-wrap">
	                        <c:set var="imgs" value="${fn:split(product.p_image, ',')}" />
	                        <c:if test="${not empty imgs}">
	                            <img src="${pageContext.request.contextPath}/product_img/${fn:trim(imgs[0])}" 
	                                 class="apology-thumb-img" alt="사과와 화해" />
	                        </c:if>
	                        
	                        <!-- Hover 시 나타날 정보 영역 -->
	                        <div class="apology-hover-overlay">
	                            <div class="hover-content">
	                                <p class="hover-title">${product.p_title}</p>
	                                <div class="hover-line"></div>
	                                <p class="hover-price">
	                                    <fmt:formatNumber value="${product.p_price}" type="number"/>원
	                                </p>
	                                <span class="hover-view-more">VIEW MORE</span>
	                            </div>
	                        </div>
	                    </div>
	                </a>
	            </div>
	        </c:forEach>
	    </div>
	</div>
	<div class="best-products-container">
	    <h2><span>판매량 베스트 TOP 7</span></h2>
	    <div class="treemap-grid">
	        <!-- end="6"으로 설정하여 0~6까지 총 7개 출력 -->
	        <c:forEach var="best" items="${bestProducts}" varStatus="status" end="6">
	            <c:set var="firstImg" value="${fn:trim(fn:split(best.p_image, ',')[0])}" />
	            
	            <div class="best-item rank-${status.count}">
	                <a href="${pageContext.request.contextPath}/guest/productDetail?p_no=${best.p_no}">
	                    <img src="${pageContext.request.contextPath}/product_img/${firstImg}" class="product-img" alt="상품" />
	                    
	                    <div class="info-overlay">
	                        <div class="rank-badge">${status.count}</div>
	                        <div class="text-group">
	                            <p class="p-title">${best.p_title}</p>
	                            <p class="p-price"><fmt:formatNumber value="${best.p_price}" type="number"/>원</p>
	                        </div>
	                    </div>
	                </a>
	            </div>
	        </c:forEach>
	    </div>
	</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>