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
    const form = document.getElementById('orderForm');
    const countInput = document.getElementById('o_count');
    
    // name을 장바구니용 c_count로 원복 (바로구매 클릭 후 돌아온 경우 대비)
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
	    const form = document.getElementById('orderForm');
	    const countInput = document.getElementById('o_count');
	    
	    if(!countInput || !countInput.value) {
	        alert("수량을 확인해주세요.");
	        return;
	    }

	    // 1. 가격 정보 가져오기 (가장 안전한 방법: HTML 태그의 텍스트에서 추출)
	    // ${detail.p_price}가 null이거나 포맷팅되어 깨질 경우를 대비해 화면에 표시된 숫자를 읽습니다.
	    const priceElement = document.querySelector('.price-text');
	    let priceText = priceElement ? priceElement.innerText : "${detail.p_price}";
	    
	    // 숫자 외의 모든 문자(콤마, 원 등) 제거 후 정수 변환
	    const price = parseInt(priceText.replace(/[^0-9]/g, '')) || 0;
	    const count = parseInt(countInput.value) || 1;
	    const totalPrice = price * count;

	    console.log("읽어온 가격:", price, "수량:", count, "최종 금액:", totalPrice);

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
	    // 장바구니와 충돌을 피하기 위해 name 속성을 o_count로 변경
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
	    <span class="price-text"><fmt:formatNumber value="${detail.p_price}"/></span>
	    <br>
	    <form id="orderForm" action="/member/addCart" method="post" style="display: inline-block;">
	        <input type="hidden" name="p_no" value="${detail.p_no}">

	        <label>수량 : </label>
	        <!-- name은 기존 장바구니용 c_count 유지, id는 바로구매용 o_count 추가 -->
	        <input type="number" name="c_count" id="o_count" value="1" min="1" style="width: 60px;">
	        
	       <!-- 장바구니 버튼: 아이콘으로 대체 -->
			<button type="button" onclick="addToCart()" class="btn-cart-icon" title="장바구니 담기">
			    <i class="fa-solid fa-cart-plus fa-2xl"></i>
			</button>
			
			<!-- 바로 구매 버튼 (기존 유지) -->
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