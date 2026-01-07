<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>Flower Garden</h1>
	<span>여러분의 후기를 작성해주세요</span>
	<hr>
	<form name="reviewForm" id="reviewForm" method="post" action ="b_insert" enctype="multipart/form-data">
		<table border="1">
			<tr>
				<td>
				<!-- 평점 별모양 표시 --> 
				<div class="star-rating">
   					 <!-- 5점부터 역순으로 배치 -->
						<input type="radio" id="5-stars" name="b_rating" value="5" />
						<label for="5-stars" class="star">★</label>
    
						<input type="radio" id="4-stars" name="b_rating" value="4" />
						<label for="4-stars" class="star">★</label>
    
						<input type="radio" id="3-stars" name="b_rating" value="3" />
						<label for="3-stars" class="star">★</label>
    
						<input type="radio" id="2-stars" name="b_rating" value="2" />
						<label for="2-stars" class="star">★</label>
    
    					<input type="radio" id="1-star" name="b_rating" value="1" />
    					<label for="1-star" class="star">★</label>
				</div>
				</td>
				<td rowspan="4">
					<input type="button" value="입력" onclick="submitReview()">
				</td>
			</tr>
			<tr>
				<td>
					<!--입력창 이미지 미리보기-->
					<img id="preview" src="#" alt="선택된 이미지" style="max-width: 200px; margin-top: 10px; display: none;">
				</td>
			</tr>
			<tr>
				<td>
					<input type="file" name="b_image" id="b_image" accept="image/*" onchange="readURL(this);">	
				</td>
			</tr>
			<tr>
				<td>
					<textarea name="b_text" id="content" rows="4" cols="60"></textarea>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>