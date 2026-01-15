<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<html>
<head>
<meta charset="UTF-8">
<title>후기 작성</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/boardForm.css">
<style>


   
</style>
</head>
<body>
<div class="content-container">
		
<!-- 실제 후기 작성 페이지 영역 -->
<div class="review-trigger-container" style="text-align: center; margin: 40px 0;">
    <div class="fake-input" onclick="openProductModal()" 
         style="width: 80%; max-width: 600px; height: 50px; border: 2px solid #dcbbf2; border-radius: 25px; margin: 0 auto; display: flex; align-items: center; padding: 0 20px; color: #a36cd9; cursor: pointer; background: #fff;">
        꽃과 함께한 행복한 순간을 적어주세요 (상품 선택 필요)
    </div>
</div>

<!-- 상품 선택 모달 (팝업) -->
<div id="productModal" class="modal-overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center;">
    <div class="modal-content" style="background: #fff; padding: 30px; border-radius: 15px; width: 90%; max-width: 500px; position: relative;">
        <span class="close-btn" onclick="closeModal()" style="position: absolute; right: 20px; top: 15px; cursor: pointer; font-size: 24px;">&times;</span>
        <h3 style="text-align:center; margin-bottom: 20px;">후기를 작성할 상품을 선택하세요</h3>
        
        <div class="product-selection-modal" style="display: flex; gap: 15px; flex-wrap: wrap; justify-content: center;">
            <c:forEach items="${productList}" var="p">
			    <%-- 1. 이미지 split 및 첫 번째 파일명 추출 후 공백 제거(trim) --%>
			    <c:set var="p_img_array" value="${fn:split(p.p_image, ',')}" />
			    <c:set var="clean_img" value="${fn:trim(p_img_array[0])}" />
			    
				<div class="product-item" 
				     onclick="confirmProduct(this, '${p.p_no}', '${p.p_title}', '${pageContext.request.contextPath}/product_img/${clean_img}')" 
				     style="cursor: pointer; width: 100px; text-align: center;">
				    <img src="${pageContext.request.contextPath}/product_img/${clean_img}" 
				         style="width: 80px; height: 80px; object-fit: cover; border-radius: 10px;">
				    <p style="font-size: 12px; margin-top: 5px;">${p.p_title}</p>
				</div>
			</c:forEach>
        </div>
    </div>
</div>

    <form name="reviewForm" id="reviewForm" method="post" 
          action="${pageContext.request.contextPath}/member/b_insert" 
          enctype="multipart/form-data">
          
		  <div id="selected_product_info" style="display:none; align-items:center; justify-content:center; gap:10px; padding:15px; background:#f2e9fb; border-radius:10px; margin-bottom:20px;">
		      <!-- 이미지는 ID만 부여하고 src는 비워둠 -->
		      <img id="display_img" src="" style="width:60px; height:60px; object-fit:cover; border-radius:5px;">
		      
		      <div style="text-align:left;">
		          <span style="display:block; font-size:12px; color:#666;">선택된 상품</span>
		          <!-- 상품명이 들어갈 곳 -->
		          <span id="display_title" style="font-weight:bold; color:#a36cd9; font-size:16px;"></span>
		      </div>
		  </div>

		  <!-- 기존 hidden input -->
		  <input type="hidden" name="p_no" id="selected_p_no">
        <table>
            <!-- 1행: 별점 -->
            <tr>
                <td colspan="2" class="bg-point">
                    <div class="star-rating">
                        <input type="radio" id="ins-5-stars" name="b_rating" value="5" />
                        <label for="ins-5-stars">★</label>
                        <input type="radio" id="ins-4-stars" name="b_rating" value="4" />
                        <label for="ins-4-stars">★</label>
                        <input type="radio" id="ins-3-stars" name="b_rating" value="3" />
                        <label for="ins-3-stars">★</label>
                        <input type="radio" id="ins-2-stars" name="b_rating" value="2" />
                        <label for="ins-2-stars">★</label>
                        <input type="radio" id="ins-1-star" name="b_rating" value="1" />
                        <label for="ins-1-star">★</label>
                    </div>
                </td>
            </tr>
            <!-- 2행: 다중 이미지 선택 및 미리보기 -->
            <tr>
                <td colspan="2">
                    <div class="edit-row file-input-wrapper">
                        <!-- multiple 속성 추가, name을 b_upload_list로 변경 -->
                        <input type="file" id="b_upload_insert" name="b_upload_list" 
                               multiple onchange="previewMultipleImages(this)">
                        
                        <label for="b_upload_insert" class="file-input-label">
                            📸 사진 여러 장 선택하기
                        </label>
                        <!-- 여러 장의 이미지가 보일 컨테이너 -->
                        <div id="image-preview-container"></div>
                    </div>
                </td>
            </tr>
			
			<!-- 3행: 텍스트 (가로 전체 차지) -->
			<tr>
			   <td colspan="2">
			       <textarea name="b_text" id="content" rows="6" placeholder="꽃과 함께한 행복한 순간을 적어주세요."></textarea>
			    </td>
			 </tr>
			</table>

			 <!-- ✅ 표 아래 오른쪽 배치를 위한 버튼 영역 -->
			 <div class="submit-btn-wrapper">
			    <input type="button" value="등록" class="btn-submit" onclick="submitReview()">
			 </div>
		</form>
</div>

<script>


	// 리뷰 제출 함수 보완
	function submitReview() {
	    const f = document.reviewForm;
	    const p_no_val = document.getElementById('selected_p_no').value;
	    
	    // 디버깅을 위해 콘솔 출력
	    console.log("전송 시도 상품 번호(p_no):", p_no_val);
	    
	    if(!p_no_val) {
	        alert("후기를 작성할 상품을 먼저 선택해주세요!");
	        openProductModal(); // 상품 미선택 시 모달 다시 띄움
	        return;
	    }
	    
	    // ... 나머지 별점 및 텍스트 체크 ...
	    
	    if(!f.b_text.value.trim()) {
	        alert("내용을 입력해주세요!");
	        f.b_text.focus();
	        return;
	    }

	    alert("후기가 등록되었습니다!");
	    f.submit(); 
	}
// 3. 여러 장 미리보기 함수
function previewMultipleImages(input) {
    const container = document.getElementById('image-preview-container');
    container.innerHTML = ""; // 기존 미리보기 초기화
    
    if (input.files) {
        Array.from(input.files).forEach(file => {
            const reader = new FileReader();
            reader.onload = function(e) {
                const img = document.createElement('img');
                img.src = e.target.result;
                img.classList.add('preview-img');
                container.appendChild(img);
            }
            reader.readAsDataURL(file);
        });
    }
}

//팝업 열기
function openProductModal() {
    document.getElementById('productModal').style.display = 'flex';
}

// 팝업 닫기
function closeModal() {
    document.getElementById('productModal').style.display = 'none';
}


//괄호 안에 p_no, p_title, img_src를 반드시 넣어주어야 합니다.
function confirmProduct(element, p_no, p_title, img_src) {
    // 1. 값(Value)과 텍스트 세팅
    document.getElementById('selected_p_no').value = p_no;
    document.getElementById('display_title').innerText = p_title + " 🌸";
    
    // 2. 이미지 src 세팅 (이미 모달에서 검증된 img_src를 그대로 대입)
    const imgTag = document.getElementById('display_img');
    imgTag.src = img_src;

    // 3. 숨겨져 있던 정보 영역 보이기
    document.getElementById('selected_product_info').style.display = 'flex';

    // 4. 모달 닫기
    closeModal();

    // 5. 폼 활성화 로직
    const form = document.getElementById('reviewForm');
    if(form) {
        form.style.display = 'block';
        form.classList.add('active');
        setTimeout(() => {
            form.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }, 100);
    }
}

</script>
</body>
</html>