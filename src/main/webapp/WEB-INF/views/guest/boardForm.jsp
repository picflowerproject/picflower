<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>후기 작성</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/boardForm.css">
<style>
    /* 다중 이미지 미리보기를 위한 스타일 추가 */
    #image-preview-container {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        margin-top: 10px;
    }
    .preview-img {
        width: 100px;
        height: 100px;
        object-fit: cover;
        border-radius: 5px;
        border: 1px solid #ddd;
    }
</style>
</head>
<body>
<div class="content-container">
    <form name="reviewForm" id="reviewForm" method="post" 
          action="${pageContext.request.contextPath}/member/b_insert" 
          enctype="multipart/form-data">
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
            <!-- 3행: 텍스트 및 등록 버튼 -->
            <tr>
                <td>
                    <textarea name="b_text" id="content" rows="6" placeholder="꽃과 함께한 행복한 순간을 적어주세요."></textarea>
                </td>
                <td style="width: 110px; text-align: center;">
                    <input type="button" value="등록" class="btn-submit" onclick="submitReview()">
                </td>
            </tr>
        </table>
    </form>
</div>

<script>
// 여러 장 미리보기 함수
function previewMultipleImages(input) {
    const container = document.getElementById('image-preview-container');
    container.innerHTML = ""; // 기존 미리보기 초기화
    
    if (input.files) {
        // 선택된 파일들을 루프 돌며 미리보기 생성
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
</script>
</body>
</html>