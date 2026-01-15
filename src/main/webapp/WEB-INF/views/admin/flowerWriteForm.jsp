<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>꽃 등록</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/flowerWrite.css">
</head>
<body>
<header>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
</header>

<main>
    <h2>꽃 등록</h2>
    <form name="flower" method="post" action="/admin/flowerWrite" enctype="multipart/form-data">
        <!-- border="1"은 삭제하여 CSS가 적용되게 합니다 -->
        <table>
            <tr>
                <td>꽃 이름</td>
                <td><input type="text" name="f_name" placeholder="이름을 입력하세요"></td>
            </tr>
            <tr>
                <td>꽃 영문 이름</td>
                <td><input type="text" name="f_ename" placeholder="English Name"></td>
            </tr>
            <tr>
                <td>이미지 등록</td>
                <td><input type="file" name="f_upload" multiple></td>
            </tr>
            <tr>
                <td>꽃말</td>
                <td><input type="text" name="f_language" placeholder="꽃말을 입력하세요"></td>
            </tr>
            <tr>
                <td>꽃 상세정보</td>
                <td><textarea name="f_detail" rows="5"></textarea></td>
            </tr>
            <tr>
                <td>꽃 사용</td>
                <td><textarea name="f_use" rows="5"></textarea></td>
            </tr>
            <tr>
                <td>꽃 양식</td>
                <td><textarea name="f_raise" rows="5"></textarea></td>
            </tr>	
            <tr>
                <td>탄생일</td>
                <td><input type="text" name="f_birth" placeholder="예: 01-12"></td>
            </tr>	
        </table>
        
        <input type="hidden" name="m_no" value="1001">
        
        <div class="btn-area">
            <input type="submit" value="꽃 등록"> 
            <input type="reset" value="등록 취소">
        </div>
    </form>
</main>

<footer>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>