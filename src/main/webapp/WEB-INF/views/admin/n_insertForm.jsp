<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" buffer="1024kb" autoFlush="true"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 입력</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/n_insertForm.css">
<script src="${pageContext.request.contextPath}/js/n_insertForm.js"></script>

<!-- Summernote Lite CDN -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

  <script src="${pageContext.request.contextPath}/summernote/summernote-lite.js"></script>
  <script src="${pageContext.request.contextPath}/summernote/lang/summernote-ko-KR.js"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/summernote/summernote-lite.css">
</head>
<body>
<header>
	<%@ include file="/WEB-INF/views/common/header.jsp" %>
</header>
<main>
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
		    <td>내용</td>
		    <td>
		        <textarea id="summernote" name="n_text"></textarea>
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
</main>

<footer>
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>	
</footer>

<script>
$(document).ready(function() {
    $('#summernote').summernote({
        height: 400,                 // 에디터 높이
        minHeight: null,             // 최소 높이
        maxHeight: null,             // 최대 높이
        focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
        lang: "ko-KR",               // 한글 설정
        placeholder: '공지사항 내용을 입력해주세요.',
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'underline', 'clear']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['table', ['table']],
            ['insert', ['link', 'picture', 'video']],
            ['view', ['fullscreen', 'codeview', 'help']]
        ]
    });
});
</script>
</body>
</html>