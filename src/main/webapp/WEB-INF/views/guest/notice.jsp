<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/notice.css">
<script>
	const contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/notice.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<div class="content-container">
	<h1>공지사항</h1>
	
		<!-- 1. 제목 바로 아래에 공지 입력 링크 추가 -->
	    <div class="add-notice-container">
	        <a href="/admin/n_insertForm">
	            ➕ 새 공지사항 등록하기
	        </a>
	    </div>
	
		<c:forEach var="dto" items="${list}">
		    <details id="notice_${dto.n_no}" name="notice-item" class="notice-item">
		        <summary>
		            <strong>${dto.n_title}</strong>
		            <span><fmt:formatDate value="${dto.n_date}" pattern="yyyy-MM-dd"/></span>
		        </summary>
		        
		        <div class="notice-body">
		            <!-- [보기 모드] -->
		            <div id="view_area_${dto.n_no}" class="view-area">
		                <div class="notice-text">${dto.n_text}</div>
		                <c:if test="${not empty dto.n_image_name}">
		                    <div class="notice-image">
		                        <img src="/img/${dto.n_image_name}">
		                    </div>
		                </c:if>
		                
		                <div class="action-buttons">
		                    <a href="javascript:void(0);" onclick="toggleEdit('${dto.n_no}', true)" class="btn-update">수정</a>
		                    <a href="javascript:void(0);" onclick="/admin/n_delete('${dto.n_no}')">삭제</a>
		                </div>
		            </div>

		
		            <!-- [수정 모드] -->
		            <div id="edit_area_${dto.n_no}" class="edit-area" style="display: none;">
		                <form action="/admin/n_update" method="post" enctype="multipart/form-data">
		                    <input type="hidden" name="n_no" value="${dto.n_no}">
		                    <input type="hidden" name="n_image_name" value="${dto.n_image_name}">
		                    
		                    <div class="edit-row">
		                        <label>제목:</label>
		                        <input type="text" name="n_title" value="${dto.n_title}">
		                    </div>
		                    
		                    <div class="edit-row">
		                        <label>내용:</label>
		                        <textarea name="n_text">${dto.n_text}</textarea>
		                    </div>
		                    
		                    <div class="edit-row file-input">
							    <label> </label>
							    <div class="file-input-wrapper">
							        <!-- 실제 파일 input (ID를 고유하게 설정) -->
							        <input type="file" id="file_${dto.n_no}" 
							               onchange="readURL(this, 'edit_preview_${dto.n_no}')" name="n_image">
							        
							        <!-- 디자인된 라벨 버튼 -->
							        <label for="file_${dto.n_no}" class="file-input-label">
							            📸 사진 변경하기
							        </label>
							    </div>
		                        
		                        <div class="preview-container">
		                            <img id="edit_preview_${dto.n_no}" 
		                                 src="${not empty dto.n_image_name ? '/img/' : '#'}${dto.n_image_name}" 
		                                 class="edit-preview ${empty dto.n_image_name ? 'hidden' : ''}">
		                        </div>
		                    </div>
		                                        
		                    <div class="action-buttons">
		                        <button type="submit" class="btn-save">저장</button>
		                        <button type="button" class="btn-cancel" onclick="toggleEdit('${dto.n_no}', false)">취소</button>
		                    </div>
		                </form>
		            </div>
		        </div>
		    </details>
		</c:forEach>

	<c:choose>
		<c:when test="${not empty pageContext.request.userPrincipal}">
        	<c:choose>
            	<c:when test="${pageContext.request.userPrincipal.name == 'admin'}">
                	<div class="add">
						 <a href="/admin/n_insertForm">공지 입력하기</a>
					</div>
            	</c:when>
            	<c:otherwise>
            
            	</c:otherwise>
        	</c:choose>
    	</c:when>
    	<c:otherwise>

    	</c:otherwise>
	</c:choose>
<%@ include file="/WEB-INF/views/common/pagination.jsp"%>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>