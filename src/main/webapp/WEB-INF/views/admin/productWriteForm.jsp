<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/productWriteForm.css">
<link rel="stylesheet" href="cdnjs.cloudflare.com">
<script>
function readURL(input) {
    const previewContainer = document.getElementById('image_preview');
    
    // 이전에 선택했던 미리보기 이미지들을 초기화
    previewContainer.innerHTML = '';

    if (input.files && input.files.length > 0) {
        // 선택된 파일 개수만큼 반복
        Array.from(input.files).forEach(file => {
            const reader = new FileReader();

            reader.onload = function(e) {
                // 이미지 태그 생성
                const img = document.createElement('img');
                img.src = e.target.result;
                img.style.width = '80px';      // 미리보기 너비
                img.style.height = '80px';     // 미리보기 높이
                img.style.marginRight = '10px'; // 이미지 간격
                img.style.objectFit = 'cover';  // 비율 유지
                img.style.border = '1px solid #ddd';
                
                previewContainer.appendChild(img);
            };

            reader.readAsDataURL(file);
        });
    }
}
/* function inputNumberFormat(obj) {
    // 1. 숫자 이외의 문자 제거
    let value = obj.value.replace(/[^0-9]/g, "");
    
    // 2. 천 단위 콤마 추가 후 다시 input에 설정
    obj.value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
function submitForm() {
    let priceInput = document.getElementById("price");
    // 콤마 제거 후 숫자만 추출
    let rawValue = priceInput.value.replace(/[^\d]+/g, ""); 
    console.log("서버로 보낼 값:", rawValue);
} */
</script>
</head>
<body>
<header>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
</header>
<main>
     <h2>상품 등록</h2>
    <form name="product" method="post" action="/admin/productWrite" enctype="multipart/form-data">
         <table>
            <tr>
                <td>상품 제목</td>
                <td><input type="text" name="p_title" placeholder="고객의 눈길을 끄는 제목을 입력하세요" required></td>
            </tr>
            <tr>
                <td>상품 부제목</td>
                <td><input type="text" name="p_subtitle" placeholder="간단한 설명을 입력하세요" required></td>
            </tr>
            <tr>
                <td>가격</td>
                <td><input type="text" name="p_price" onkeyup="inputNumberFormat(this)" placeholder="숫자만 입력하세요" required></td>
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
                <td>연관 꽃</td>
                <td><input type="text" name="f_no" placeholder="연관 꽃번호를 적어주세요" value="112"required></td>
            </tr>
           <tr>
                <td>이미지 등록</td>
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
                <td><textarea name="p_detail" placeholder="상세정보를 적어주세요."></textarea></td>
            </tr>	
        </table>
        
        <input type="hidden" name="m_no" value="1041">
        
        <div class="btn-group">
        	<input type="reset" value="취소">
            <input type="submit" value="등록하기">
        </div>
    </form>
</main>
<footer>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>
</html>