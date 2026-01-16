<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 1. JSTL 태그 라이브러리 추가 (이게 없으면 에러가 납니다) --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 정보 업데이트</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/productUpdateForm.css">
<link rel="stylesheet" href="cdnjs.cloudflare.com">
<script>
function readURL(input) {
    const previewContainer = document.getElementById('image_preview');
    if (!previewContainer) return;

    // 이전에 생성된 미리보기 삭제
    previewContainer.innerHTML = ''; 

    if (input.files && input.files.length > 0) {
        // 배열로 변환하여 반복문 실행
        Array.from(input.files).forEach(file => {
            // 이미지 파일인지 확인
            if (!file.type.startsWith('image/')) {
                alert('이미지 파일만 업로드 가능합니다.');
                return;
            }

            const reader = new FileReader();
            
            // 파일 읽기가 완료되었을 때 실행될 함수
            reader.onload = function(e) {
                const img = document.createElement('img');
                img.src = e.target.result; // 읽어온 이미지 데이터 경로
                img.style.width = '80px';
                img.style.height = '80px';
                img.style.marginRight = '10px';
                img.style.objectFit = 'cover';
                img.style.border = '2px solid #4CAF50';
                img.style.borderRadius = '4px'; // 약간의 둥근 모서리 추가
                
                previewContainer.appendChild(img);
            };
            
            // 파일을 Data URL로 읽기 시작 (이게 있어야 onload가 작동함)
            reader.readAsDataURL(file);
        });
    }
}

function handlePriceInput(obj, hiddenId) {
    let rawValue = obj.value.replace(/[^0-9]/g, "");
    // 인자로 받은 hiddenId에 값을 저장
    document.getElementById(hiddenId).value = rawValue;
    obj.value = rawValue.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// 초기 로딩 시 기존 값이 있다면 콤마 처리 (Optional)
window.onload = function() {
    const hiddenVal = document.getElementById("p_price_hidden").value;
    if(hiddenVal) {
        const displayInput = document.querySelector('input[type="text"][required]');
        displayInput.value = hiddenVal.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
};
</script>
</head>
<body>
<header>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
</header>
<main>
<h2>상품 정보 업데이트</h2>
<form name="product" method="post" action="/admin/productUpdate" enctype="multipart/form-data">
    <input type="hidden" name="p_no" value="${edit.p_no}">
	<input type="hidden" name="m_no" value="${edit.m_no}">	
    <table border="0">
        <tr>
            <td>번호</td>
            <td>${edit.p_no}</td>
        </tr>
        <tr>
            <td>상품 제목</td>
            <td><input type="text" name="p_title" value="${edit.p_title}" required></td>
        </tr>
         <tr>
            <td>상품 부제목</td>
            <td><input type="text" name="p_subtitle" value="${edit.p_subtitle}" required></td>
        </tr>
        <tr>
            <td>가격</td>
            <td>
           		 <!-- 서버 전송용 hidden 필드 -->
       			 <input type="hidden" name="p_price" id="p_price_hidden" value="${edit.p_price}">
        		 <!-- 사용자 노출용 필드 (name 제거) -->
       			 <input type="text" onkeyup="handlePriceInput(this, 'p_price_hidden')" value="${edit.p_price}" required>
            </td>
        </tr>
        <tr>
            <td>재고</td>
            <td>
				<input type="hidden" name="p_stock" id="p_stock_hidden" value="${edit.p_stock}">   
            	<input type="text" onkeyup="handlePriceInput(this, 'p_stock_hidden')" placeholder="재고수량을 입력하세요" value="${edit.p_stock}" required>
            </td>
        </tr>
        <tr>
            <td>분류</td>
            <td>
                <select name="p_category">
                        <option value="꽃선물">꽃선물</option>
                        <option value="개업화분">개업화분</option>
                        <option value="승진/취임">승진/취임</option>
                        <option value="결혼/장례">결혼/장례</option>
                    </select>
                </td>
        </tr>
        <tr>
            <td>현재 이미지 관리</td>
            <td>
                <div style="font-size: 0.85em; color: #d9534f; margin-bottom: 8px;">
                    * 삭제할 사진 좌측 상단의 체크박스를 선택하세요.
                </div>
                <div id="existing_images_container">
                    <c:set var="imgList" value="${fn:split(edit.p_image, ',')}" />
					<c:forEach var="img" items="${imgList}">
					    <c:if test="${not empty img}">
					        <div class="img-item">
					            <%-- 체크박스가 이미지 위에 오도록 배치 --%>
					            <input type="checkbox" name="delete_images" value="${fn:trim(img)}">
					            <span class="delete-label">삭제</span>
					            
					            <img src="${pageContext.request.contextPath}/product_img/${fn:trim(img)}">
					            
					            <input type="hidden" name="all_existing_images" value="${fn:trim(img)}">
					        </div>
					    </c:if>
					</c:forEach>
                </div>
            </td>
        </tr>
        <tr>
		    <td>새 이미지 추가</td>
		    <td>
		        <!-- label의 for와 input의 id를 일치시켜 연결합니다 -->
		        <label for="p_upload" class="file-label">
		            <i class="fas fa-camera"></i> 사진 선택하기
		        </label>
		        <span class="file-info">* 여러 장의 사진을 동시에 선택할 수 있습니다.</span>
		        
		        <input type="file" name="p_upload" id="p_upload" multiple onchange="readURL(this);">
		        
		        <!-- 미리보기 영역 -->
		        <div id="image_preview"></div>
		    </td>
		</tr>
        <tr>
            <td>상세정보</td>
            <td><textarea name="p_detail" cols="50" rows="5" placeholder="상세정보 링크를 입력하세요.">${edit.p_detail}</textarea></td>
        </tr>
    </table>
    
    <div class="btn-group" style="margin-top: 20px;">
        <input type="button" value="뒤로가기" onclick="history.back()">
        <input type="submit" value="정보수정">
    </div>
</form>
</main>
<footer>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>
</html>