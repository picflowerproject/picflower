<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>후기 작성</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/boardForm.css">
</head>
<body>
<div class="content-container">
    <form name="reviewForm" id="reviewForm" method="post" action="b_insert" enctype="multipart/form-data">
        <table>
            <!-- 1행: 별점 -->
            <tr>
                <td colspan="2" class="bg-point">
                    <div class="star-rating">
                        <input type="radio" id="5-stars" name="b_rating" value="5" />
                        <label for="5-stars">★</label>
                        <input type="radio" id="4-stars" name="b_rating" value="4" />
                        <label for="4-stars">★</label>
                        <input type="radio" id="3-stars" name="b_rating" value="3" />
                        <label for="3-stars">★</label>
                        <input type="radio" id="2-stars" name="b_rating" value="2" />
                        <label for="2-stars">★</label>
                        <input type="radio" id="1-star" name="b_rating" value="1" />
                        <label for="1-star">★</label>
                    </div>
                </td>
            </tr>
            <!-- 2행: 이미지 미리보기 -->
            <tr>
                <td colspan="2">
                    <img id="preview" src="#" alt="미리보기">
                    <div class="edit-row file-input-wrapper">
					    <label></label>
					    
					    <!-- 실제 input은 숨겨짐 -->
					    <input type="file" id="b_image_${dto.b_no}" name="b_image" 
					           onchange="readURL(this, 'edit_preview_${dto.b_no}')">
					    
					    <!-- 이 label이 예쁜 버튼 역할을 함 -->
					    <label for="b_image_${dto.b_no}" class="file-input-label">
					        📸 사진 선택하기
					    </label>
					    
					    <div class="preview-container">
					        <img id="edit_preview_${dto.b_no}" class="edit-preview">
					    </div>
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
</body>
</html>