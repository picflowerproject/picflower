<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>꽃 등록</title>
</head>
<body>
<h2>꽃 등록</h2>
<form name="flower" method="post" action="/flowerWrite" enctype="multipart/form-data">
	<table border="1">
		<tr>
			<td>꽃 이름</td>
			<td><input type="text" name="f_name"></td>
		</tr>
		<tr>
			<td >꽃 영문 이름</td>
			<td><input type="text" name="f_ename" ></td>
		</tr>
		<tr>
			<td>이미지 등록</td>
			<td><input type="file" name="f_upload" multiple></td>
		</tr>
		<tr>
			<td>꽃말</td>
			<td><input type="text" name="f_language" ></td>
		</tr>
		<tr>
			<td>꽃 상세정보</td>
			<td><textarea name="f_detail" cols="50" rows="5"></textarea></td>
		</tr>
		<tr>
			<td>꽃 사용</td>
			<td><textarea name="f_use" cols="50" rows="5"></textarea></td>
		</tr>
		<tr>
			<td>꽃 양식</td>
			<td><textarea name="f_raise" cols="50" rows="5"></textarea></td>
		</tr>	
		<tr>
			<td>탄생일</td>
			<td><input type="text" name="f_birth"></td>
		</tr>	
	</table>
	<input type="hidden" name="m_no" value="1001">
	<input type="submit" value="꽃 등록"> <input type="reset" value="등록 취소">
</form>
</body>
</html>