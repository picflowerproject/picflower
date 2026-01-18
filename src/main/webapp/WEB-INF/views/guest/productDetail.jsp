<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품상세정보</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/productDetail.css">
<script src="${pageContext.request.contextPath}/js/productDetail.js"></script>

<script>
    // [로그인 체크 변수] Spring Security 태그를 이용해 로그인 여부를 판단
    const isGuest = <sec:authorize access="isAnonymous()">true</sec:authorize>
                    <sec:authorize access="isAuthenticated()">false</sec:authorize>;

    // 공통 로그인 체크 함수
    function checkLogin() {
        if (isGuest) {
            alert("로그인이 필요한 서비스입니다.");
            // 여기서 로그인이 필요한 알람만 띄우고 끝납니다. 
            // (이미 구현된 로그인 팝업이 있다면 여기서 띄우는 함수를 추가로 호출해도 됩니다.)
            return false;
        }
        return true;
    }

    function addToCart() {
        // [추가] 로그인 체크 실행
        if (!checkLogin()) return;

        const form = document.getElementById('orderForm');
        const countInput = document.getElementById('o_count');
        
        // name을 장바구니용 c_count로 원복
        if(countInput) countInput.setAttribute("name", "c_count");

        if (!form) return;

        const formData = new FormData(form);
        fetch("/member/addCart", {
            method: "POST",
            body: new URLSearchParams(formData)
        })
        .then(res => {
            document.getElementById('cartModal').style.display = 'flex';
        })
        .catch(err => alert("오류가 발생했습니다."));
    }

    function closeCartModal() {
        document.getElementById('cartModal').style.display = 'none';
    }
    
    function directOrder() {
        // [추가] 로그인 체크 실행
        if (!checkLogin()) return;

        const form = document.getElementById('orderForm');
        const countInput = document.getElementById('o_count');
        
        if(!countInput || !countInput.value) {
            alert("수량을 확인해주세요.");
            return;
        }

        // 1. 가격 정보 가져오기
        const priceElement = document.querySelector('.price-text');
        let priceText = priceElement ? priceElement.innerText : "${detail.p_price}";
        
        const price = parseInt(priceText.replace(/[^0-9]/g, '')) || 0;
        const count = parseInt(countInput.value) || 1;
        const totalPrice = price * count;

        if(totalPrice <= 0) {
            alert("결제 금액 계산에 실패했습니다. 다시 시도해주세요.");
            return;
        }

        // 2. 총 결제 금액 hidden 필드 생성/수정
        let totalInput = form.querySelector('input[name="o_total_price"]');
        if(!totalInput) {
            totalInput = document.createElement('input');
            totalInput.type = 'hidden';
            totalInput.name = 'o_total_price';
            form.appendChild(totalInput);
        }
        totalInput.value = totalPrice;

        // 3. 목적지 변경 및 전송
        form.action = "/member/directOrderForm"; 
        countInput.setAttribute("name", "o_count"); 
        
        form.submit();
    }
</script>

</head>
<body>
<header>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
</header>
<main>
    <h1>${detail.p_title}</h1>
    <h3>${detail.p_subtitle}</h3>

    <!-- 메인 상품 정보 레이아웃 -->
    <table class="product-info-layout">
        <tr>
            <!-- 왼쪽: 이미지 영역 -->
            <td class="info-image-zone">
                <c:set var="imageArray" value="${fn:split(detail.p_image, ',')}" />
                <c:if test="${not empty imageArray}">
                    <img src="/product_img/${imageArray[0]}" id="mainImage" class="main-img" />
                </c:if>
                <div class="thumb-container">
                    <c:forEach var="imageName" items="${imageArray}">
                        <img src="/product_img/${imageName}" class="thumb-img" 
                             onclick="document.getElementById('mainImage').src=this.src;" />
                    </c:forEach>
                </div>
            </td>

            <!-- 오른쪽: 상세 정보 및 주문 영역 -->
            <td class="info-text-zone">
                <table class="inner-info-table">
                    <tr>
                        <th>상품명</th>
                        <td><strong>${detail.p_title}</strong></td>
                    </tr>
                    <tr>
                        <th>가격</th>
                        <td>
                            <span class="price-text"><fmt:formatNumber value="${detail.p_price}"/></span>
                            <div class="order-box">
                                <form id="orderForm" action="/member/addCart" method="post" class="order-form-layout">
                                    <input type="hidden" name="p_no" value="${detail.p_no}">
                                    <div class="order-left">
                                        <label>수량</label>
                                        <input type="number" name="c_count" id="o_count" value="1" min="1">
                                        <button type="button" onclick="addToCart()" class="btn-cart-icon" title="장바구니 담기">
                                            <i class="fa-solid fa-cart-plus fa-xl"></i>
                                        </button>
                                    </div>
                                    <div class="order-right">
                                        <input type="button" value="바로 구매" onclick="directOrder()" class="btn-direct-buy">
                                    </div>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>평점</th>
                        <td>
                            <div class="rating-display">
                                <span class="stars">
                                    <c:set var="avg" value="${detail.avg_rating != null ? detail.avg_rating : 0}" />
                                    <c:forEach var="i" begin="1" end="5">
                                        <c:choose>
                                            <c:when test="${i <= avg}"><i class="fa-solid fa-star"></i></c:when>
                                            <c:when test="${i - 0.5 <= avg}"><i class="fa-solid fa-star-half-stroke"></i></c:when>
                                            <c:otherwise><i class="fa-regular fa-star"></i></c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </span>
                                <strong class="avg-score">${avg}</strong>
                                <span class="review-link" onclick="document.querySelectorAll('.tab-btn')[1].click(); location.href='#tab-review';">
                                    (${detail.review_count}개의 후기 보기)
                                </span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>분류</th>
                        <td>${detail.p_category}</td>
                    </tr>
                    <tr>
                        <th>등록일</th>
                        <td><fmt:formatDate value="${detail.p_date}" pattern="yyyy-MM-dd"/></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>

    <!-- 하단 버튼: 목록(좌), 수정/삭제(우) -->
    <div class="link-container">
        <div class="left-btns">
            <a href="productList" class="btn-list">상품 목록</a>
        </div>
        <div class="right-btns">
            <sec:authorize access="hasAuthority('ROLE_ADMIN')">
                <a href="/admin/productUpdateForm?p_no=${detail.p_no}" class="btn-edit">상품 수정</a> 
                <a href="/admin/productDelete?p_no=${detail.p_no}" class="btn-delete" onclick="return confirm('정말 삭제하시겠습니까?')">삭제하기</a>
            </sec:authorize>
        </div>
    </div>
    </div>
	<div class="tab-menu">
	    <button class="tab-btn active" onclick="openTab(event, 'tab-detail')">상세정보</button>
	    <button class="tab-btn" onclick="openTab(event, 'tab-review')">상품후기</button>
	</div>

<!-- 탭 내용 1: 상세정보 -->
<div id="tab-detail" class="tab-content active">
    <div class="detail-box">
        <!-- 상단 배송 헤더 -->
        <div class="delivery-header">
            <h1>전국 당일 퀵배송</h1>
            <p class="delivery-time">배송가능시간 : <span>오전 10시 ~ 오후 8시</span></p>
        </div>
    
        <!-- 배송 장점 카드 레이아웃 -->
        <div class="delivery-cards">
            <div class="card">
                <div class="card-icon"><i class="fa-solid fa-truck-fast"></i></div>
                <div class="card-text">당일 주문<br>당일 도착 O</div>
            </div>
            <div class="card">
                <div class="card-icon"><i class="fa-solid fa-calendar-check"></i></div>
                <div class="card-text">도착일<br>지정 O</div>
            </div>
            <div class="card">
                <div class="card-icon"><i class="fa-solid fa-clock"></i></div>
                <div class="card-text">도착 희망<br>시간 지정 O</div>
            </div>
        </div>

        <!-- 상세 이미지 영역 -->
        <div class="product-detail">
            <img src="${detail.p_detail}" alt="상세설명이미지" class="detail-main-img">
        </div>
    </div>
</div>

<!-- 탭 내용 2: 상품후기 -->
<div id="tab-review" class="tab-content">
    <div class="review-box">
        <%@ include file="simple_board.jsp" %> <!-- 후기 로직을 별도 파일로 분리하거나 위 코드를 그대로 삽입 -->
    </div>
</div>


<!-- 장바구니 모달 팝업 (기능 유지, 디자인 강화) -->
<div id="cartModal" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-icon"><i class="fa-solid fa-circle-check"></i></div>
        <h3>장바구니 담기 완료</h3>
        <p>선택하신 상품이 장바구니에 담겼습니다.</p>
        <div class="modal-buttons">
            <button onclick="closeCartModal()" class="btn-modal-sub">쇼핑 계속하기</button>
            <button onclick="location.href='/member/cartList'" class="btn-modal-main">장바구니 이동</button>
        </div>
    </div>
</div>
</main>
<footer>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>
</html>