<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 입력</title>
</head>
<body>
	<h1>공지 사항 입력</h1>
	<form name ="notice" method="post" action="n_insert" enctype="multipart/form-data">
		<table border ="1">
			<tr>
				<td>
				 	제목
				</td>
				<td>
					<input type="text" name="n_title">
				</td>
			</tr>
			<tr>
				<td>
				 	내용
				</td>
				<td>
					<input type="text" name="n_text">
				</td>
			</tr>
			<tr>
				<td>
				 	이미지
				</td>
				<td>
					<input type="file" name="n_image">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="submit" value="등록하기">
					<input type="reset" value ="초기화">
					<input type="button" value="뒤로" onclick="history.back()">
				</td>
			</tr>
		</table>
	</form>
</body>
</html>