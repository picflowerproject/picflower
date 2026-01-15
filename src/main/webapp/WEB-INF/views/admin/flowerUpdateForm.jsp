<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>꽃 정보 수정</title>
    <!-- CSS 연결 -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/flowerUpdate.css">
</head>
<body>
<header>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
</header>
<main>
    <h2>꽃 정보 수정</h2>
    <form name="flower" method="post" action="/admin/flowerUpdate" enctype="multipart/form-data">
        <!-- border="1" 제거 -->
        <table>
            <tr>
                <td>꽃 번호</td>
                <td class="f-no-text">${edit.f_no}</td>
            </tr>
            <tr>
                <td>꽃 이름</td>
                <td><input type="text" name="f_name" value="${edit.f_name}"></td>
            </tr>
            <tr>
                <td>꽃 영문 이름</td>
                <td><input type="text" name="f_ename" value="${edit.f_ename}"></td>
            </tr>
            <tr>
                <td>이미지 등록</td>
                <td><input type="file" name="f_upload" multiple></td>
            </tr>
            <tr>
                <td>꽃말</td>
                <td><input type="text" name="f_language" value="${edit.f_language}"></td>
            </tr>
            <tr>
                <td>꽃 상세정보</td>
                <td><textarea name="f_detail" rows="5">${edit.f_detail}</textarea></td>
            </tr>
            <tr>
                <td>꽃 사용</td>
                <td><textarea name="f_use" rows="5">${edit.f_use}</textarea></td>
            </tr>
            <tr>
                <td>꽃 양식</td>
                <td><textarea name="f_raise" rows="5">${edit.f_raise}</textarea></td>
            </tr>	
            <tr>
                <td>탄생일</td>
                <td><input type="text" name="f_birth" value="${edit.f_birth}"></td>
            </tr>	
        </table>
        
        <input type="hidden" name="m_no" value="1001">
        <input type="hidden" name="f_no" value="${edit.f_no}"> <!-- 수정을 위해 f_no 전송 필요 -->
        
        <div class="btn-area">
            <input type="submit" value="수정하기"> 
            <input type="reset" value="취소">
        </div>
    </form>
</main>
<footer>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>
</html>