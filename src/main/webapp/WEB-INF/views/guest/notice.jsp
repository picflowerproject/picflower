<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> 
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/summernote/summernote-lite.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/notice.css">
<script>
	const contextPath = "${pageContext.request.contextPath}";

</script>

</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- Summernote Lite CDN -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

  <script src="${pageContext.request.contextPath}/summernote/summernote-lite.js"></script>
  <script src="${pageContext.request.contextPath}/summernote/lang/summernote-ko-KR.js"></script>

<script src="${pageContext.request.contextPath}/js/notice.js"></script>
<div class="content-container">
	<h1>공지사항</h1>
	
		<sec:authorize access="hasAuthority('ROLE_ADMIN')">
		    <div class="add-notice-container">
		        <a href="/admin/n_insertForm">➕ 새 공지사항 등록하기</a>
		    </div>
		</sec:authorize>
	
		<c:forEach var="dto" items="${list}">
		    <details id="notice_${dto.n_no}" name="notice-item" class="notice-item">
		        <summary>
		            <strong>${dto.n_title}</strong>
		            <span><fmt:formatDate value="${dto.n_date}" pattern="yyyy-MM-dd"/></span>
		        </summary>
		        
		        <div class="notice-body">
		            <!-- [보기 모드] -->
		            <div id="view_area_${dto.n_no}" class="view-area">
		                <!-- n_text 안에 이미지가 포함되어 있으므로 n_image_name 체크 로직 삭제 -->
		                <div class="notice-text">${dto.n_text}</div>
	
						<div class="action-buttons">
						    <sec:authorize access="hasAuthority('ROLE_ADMIN')">
						        <a href="javascript:void(0);" onclick="toggleEdit('${dto.n_no}', true)" class="btn-update">수정</a>
						        <a href="javascript:void(0);" onclick="n_delete('${dto.n_no}')" class="btn-delete">삭제</a>
						    </sec:authorize>
						</div>
		            </div>

		            <!-- [수정 모드] -->
					<sec:authorize access="hasAuthority('ROLE_ADMIN')">
		            <div id="edit_area_${dto.n_no}" class="edit-area" style="display: none;">
					    <form action="/admin/n_update" method="post">
					        <input type="hidden" name="n_no" value="${dto.n_no}">
					        
					        <div class="edit-row">
					            <label>제목:</label>
					            <input type="text" name="n_title" value="${dto.n_title}">
					        </div>
					        
					        <div class="edit-row">
					            <label>내용:</label>
					            <!-- ID 뒤에 n_no를 붙여 고유하게 만듭니다. class를 이용해 한꺼번에 에디터를 적용합니다. -->
					            <textarea id="edit_summernote_${dto.n_no}" name="n_text" class="summernote-edit">${dto.n_text}</textarea>
					        </div>
					        
					        <div class="action-buttons">
					            <button type="submit" class="btn-save">저장</button>
					            <button type="button" class="btn-cancel" onclick="toggleEdit('${dto.n_no}', false)">취소</button>
					        </div>
					    </form>
					</div>
					</sec:authorize>
		        </div>
		    </details>
		</c:forEach>

<script type="text/javascript">

$(document).ready(function() {
    // 등록 폼 에디터 (기존 유지)
    $('#summernote').summernote({
        height: 400,
        lang: "ko-KR"
    });

    // 수정 폼 에디터 (class가 summernote-edit인 모든 요소를 에디터로 변환)
    $('.summernote-edit').summernote({
        height: 300,
        lang: "ko-KR",
        placeholder: '수정할 내용을 입력하세요.',
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'underline', 'clear']],
            ['insert', ['link', 'picture', 'video']],
            ['view', ['fullscreen', 'codeview']]
        ]
    });
});

</script>
<%@ include file="/WEB-INF/views/common/pagination.jsp"%>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>


</body>
</html>