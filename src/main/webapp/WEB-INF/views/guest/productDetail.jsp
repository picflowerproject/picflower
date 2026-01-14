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
<style>
    /* 큰 이미지 스타일 */
    .main-img { width: 350px; height: 400px; object-fit: cover; border: 1px solid #ddd; margin-bottom: 10px; }
    /* 작은 썸네일 이미지들 정렬 */
    .thumb-container { display: flex; gap: 5px; flex-wrap: wrap; }
    .thumb-img { width: 60px; height: 60px; object-fit: cover; border: 1px solid #ccc; cursor: pointer; }
    .thumb-img:hover { border-color: #333;}
	
	
	
	.modal-overlay {
	    display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
	    background: rgba(0,0,0,0.5); z-index: 2000; align-items: center; justify-content: center;
	}
	.modal-content {
	    background: #fff; padding: 30px; border-radius: 15px; text-align: center;
	    width: 350px; box-shadow: 0 10px 30px rgba(0,0,0,0.1);
	}
	.modal-buttons { margin-top: 20px; display: flex; gap: 10px; justify-content: center; }
	.btn-main { background: #6a5acd; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; }
	.btn-sub { background: #eee; color: #333; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; }
	
</style>
<script>
	function addToCart() {
	    const form = document.querySelector('form[action="/member/addCart"]');
	    const formData = new FormData(form);

	    fetch("/member/addCart", {
	        method: "POST",
	        body: new URLSearchParams(formData)
	    })
	    .then(res => {
	        // 성공 시 모달 띄우기
	        document.getElementById('cartModal').style.display = 'flex';
	        
	        // 또는 토스트 메시지만 띄우고 싶다면 아래 주석 해제
	        /* showToast(); */
	    })
	    .catch(err => alert("오류가 발생했습니다."));
	}

	function closeCartModal() {
	    document.getElementById('cartModal').style.display = 'none';
	}
	
	function directOrder() {
	    const form = document.getElementById('orderForm');
	    const countInput = document.getElementById('o_count'); // <input id="o_count" ...> 찾기
	    
	    // 1. 입력값이 있는지 확인 (에러 방지)
	    if(!countInput || !countInput.value) {
	        alert("수량을 확인해주세요.");
	        return;
	    }

	    // 2. 비로그인 처리 (Spring Security 인증 확인)
	    <sec:authorize access="isAnonymous()">
	        if(confirm("로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?")) {
	            location.href = "/guest/loginForm";
	        }
	        return; // 로그인 안 되어 있으면 여기서 중단
	    </sec:authorize>

	    // 3. 목적지를 바로구매 전용 컨트롤러 주소로 변경
	    form.action = "/member/directOrderForm"; 
	    
	    // 4. [중요] 기존 name="c_count"를 서버가 원하는 "o_count"로 변경하여 전송
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
<h2>${detail.p_title}</h2>
<h3>${detail.p_subtitle}</h3>
<table border="0">
	<tr>
		 <td rowspan="5" width="400" align="center" valign="top">
            <c:set var="imageArray" value="${fn:split(detail.p_image, ',')}" />
            
            <c:if test="${not empty imageArray[0]}">
                <img src="/product_img/${imageArray[0]}" id="mainImage" class="main-img" />
            </c:if>

            <div class="thumb-container">
                <c:forEach var="imageName" items="${imageArray}" varStatus="status">
                    <img src="/product_img/${imageName}" class="thumb-img" 
                         onclick="document.getElementById('mainImage').src=this.src;" />
                </c:forEach>
            </div>
        </td>
	</tr>
	<tr>
		<td>상품명</td>
		<td>${detail.p_title}</td>
	</tr>
	<tr>
    <td>가격</td>
	<td class="price-row">
	    <span class="price-text"><fmt:formatNumber value="${detail.p_price}"/>원</span>
	    
	    <form id="orderForm" action="/member/addCart" method="post" style="display: inline-block; margin-left: 20px;">
	        <input type="hidden" name="p_no" value="${detail.p_no}">
	        
	        <label>수량 : </label>
	        <!-- name은 기존 장바구니용 c_count 유지, id는 바로구매용 o_count 추가 -->
	        <input type="number" name="c_count" id="o_count" value="1" min="1" style="width: 60px;">
	        
	        <!-- 장바구니 버튼: 기존 addToCart() 함수는 name="c_count"를 참조해도 문제 없음 -->
	        <input type="button" value="장바구니 담기" onclick="addToCart()" class="btn-lavender">
	        
	        <!-- 바로 구매 버튼 -->
	        <input type="button" value="바로 구매" onclick="directOrder()" class="btn-main" style="background-color: #ff4757; color: white;">
	    </form>
	</td>
	</tr>
	<tr>
		<td>분류</td>
		<td>${detail.p_category}</td>
	</tr> 
	<tr>
		<td>등록 일자</td>
		<td><fmt:formatDate value="${detail.p_date}" pattern="yyyy-MM-dd"/></td>
	</tr>
</table>
<div class="link-container">
    <a href="productList">목록</a> 
	<sec:authorize access="hasAuthority('ROLE_ADMIN')">
	    <a href="/admin/productUpdateForm?p_no=${detail.p_no}">수정</a> 
	    <a href="/admin/productDelete?p_no=${detail.p_no}" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
	</sec:authorize>
</div>
<div class="tab-menu">
    <button class="tab-btn active" onclick="openTab(event, 'tab-detail')">상세정보</button>
    <button class="tab-btn" onclick="openTab(event, 'tab-review')">상품후기</button>
</div>

<!-- 탭 내용 1: 상세정보 -->
<div id="tab-detail" class="tab-content active">
    <div class="detail-box">
	    <div>
	        <h1>전국 당일 퀵배송</h1>
	        <p>배송가능시간 : 오전 10시 ~ 오후 8시</p>
	    </div>
	
	    <div>
	        <div>
	            당일 주문, 당일 도착 O
	        </div>
	        <div>
	            도착일 지정 O
	        </div>
	        <div>
	            도착 희망 시간 지정 O
	        </div>
	    </div>
	
	    <div>
	        <p>
	            • 읍, 면, 리 지역은 배송비 1만 원이 추가됩니다. 해당 지역으로 배송을 원하시면 배송비 추가 옵션을 선택해 주세요.
	        </p>
	    </div>
        <div class="product-detail">
		    <img src="${detail.p_detail}" alt="${detail.p_detail}" style="width:100%; max-width:800px;">
		</div>
    </div>
</div>

<!-- 탭 내용 2: 상품후기 -->
<div id="tab-review" class="tab-content">
    <div class="review-box">
        <%@ include file="simple_board.jsp" %> <!-- 후기 로직을 별도 파일로 분리하거나 위 코드를 그대로 삽입 -->
    </div>
</div>


<!--장바구니 모달 팝업-->
<div id="cartModal" class="modal-overlay">
    <div class="modal-content">
        <h3>장바구니 담기 완료</h3>
        <p>선택하신 상품이 장바구니에 담겼습니다.</p>
        <div class="modal-buttons">
            <button onclick="closeCartModal()" class="btn-sub">쇼핑 계속하기</button>
            <button onclick="location.href='/member/cartList'" class="btn-main">장바구니 이동</button>
        </div>
    </div>
</div>
</main>
<footer>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>
</html>