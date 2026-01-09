<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 입력</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/n_insertForm.css">

<script src="${pageContext.request.contextPath}/js/n_insertForm.js" defer></script>

</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<div class="content-container">
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
               <div class="edit-row file-input-wrapper">
                   <label></label>
                   <!-- 실제 input은 숨겨짐 -->
                   <input type="file" name="n_image" id="n_image" onchange="readURL(this);">
                   
                   <!-- 이 label이 예쁜 버튼 역할을 함 -->
                   <label for="n_image" class="file-input-label">
                       📸 사진 선택하기
                   </label>
                   
               </div>
               <br>
               <div>
               <img id="preview" src="#"  />
               </div>               
            </td>
         </tr>
         <tr>
            <td colspan="2" class="button-row">
               <input type="button" value="뒤로" onclick="history.back()">
               <input type="submit" value="등록">
            </td>
         </tr>
      </table>
   </form>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>