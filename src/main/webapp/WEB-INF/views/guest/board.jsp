<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Flower Garden</title>
<script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/board_style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/boardUpdateForm.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/reply.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/board.js"></script>
<script src="${pageContext.request.contextPath}/js/reply.js"></script>

</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<div class="content-container">
	    
		 <div class="form-section">
			<h1>Flower Garden</h1>
   			 <span>여러분의 소중한 후기를 작성해주세요</span>
			
		         <jsp:include page="boardForm.jsp" />
		 </div>
	<!-- 결과들이 추가될 컨테이너 -->
	<div id="review-list">
	    <c:forEach var="board" items="${list}" varStatus="status">
	        <div class="result-container" id="board-container-${board.b_no}">
	            
	            <!-- [A] 출력 모드 -->
	            <div id="view-mode-${board.b_no}" class="view-wrapper ${status.index % 2 != 0 ? 'view-wrapper-reverse' : ''}">
	                <div class="image-area">
	                    <c:if test="${not empty board.b_image_list}">
	                        <div class="slider-container" id="slider-${board.b_no}">
	                            <c:if test="${fn:length(board.b_image_list) > 1}">
	                                <button class="slider-btn prev" onclick="moveSlider(${board.b_no}, -1)">❮</button>
	                                <button class="slider-btn next" onclick="moveSlider(${board.b_no}, 1)">❯</button>
	                            </c:if>
	                            <div class="slider-track" id="track-${board.b_no}">
	                                <c:forEach var="imgName" items="${board.b_image_list}">
	                                    <div class="slide">
	                                        <img src="${pageContext.request.contextPath}/img/${imgName}" alt="후기사진">
	                                    </div>
	                                </c:forEach>
	                            </div>
	                            <c:if test="${fn:length(board.b_image_list) > 1}">
	                                <div class="slider-dots" id="dots-${board.b_no}">
	                                    <c:forEach var="imgName" items="${board.b_image_list}" varStatus="vs">
	                                        <span class="dot ${vs.first ? 'active' : ''}"></span>
	                                    </c:forEach>
	                                </div>
	                            </c:if>
	                        </div>
	                    </c:if>
	                </div>

	                <div class="text-area">
	                    <div class="menu-container">
	                        <span class="author-id">${board.m_id}</span>
	                        <div class="dropdown-wrapper">
	                            <button class="menu-btn" onclick="toggleMenu(${board.b_no})">⋮</button>
	                            <div id="dropdown-${board.b_no}" class="dropdown-menu">
	                                <c:if test="${pageContext.request.userPrincipal.name == board.m_id}">
	                                    <button type="button" onclick="showEditForm(${board.b_no})">수정하기</button>
	                                </c:if>
	                                <c:if test="${pageContext.request.userPrincipal.name == board.m_id || pageContext.request.isUserInRole('ROLE_ADMIN')}">
	                                    <button type="button" onclick="deleteReview(${board.b_no})">삭제하기</button>
	                                </c:if>
	                            </div>
	                        </div>
	                    </div>

	                    <div class="rating-like-container">
	                        <div class="stars">
	                            <c:forEach var="i" begin="1" end="5">
	                                ${i <= board.b_rating ? '★' : '☆'}
	                            </c:forEach>
	                        </div>
	                        <button class="like-btn ${board.userLiked ? 'active' : ''}" onclick="likeUp(${board.b_no})">
	                            <span class="flower-icon">${board.userLiked ? '🌸' : '☆'}</span>
	                            <span id="like-count-${board.b_no}">${board.b_like}</span>
	                        </button>
	                    </div>

	                    <!-- 텍스트 및 댓글 섹션 -->
	                        <p class="review-text" id="text-p-${board.b_no}">${board.b_text}</p>
								<!-- 댓글 개수  -->
								<div class="reply-header">
								    댓글 <span id="reply-count-${board.b_no}">${fn:length(board.replies)}</span>개
								</div>
							
	                      <div class="scroll-content">   
	                        <div class="reply-section">
	                            <div id="reply-list-${board.b_no}" class="reply-slider">
	                                <c:forEach var="reply" items="${board.replies}">
	                                    <div class="reply-item" id="reply-item-${reply.r_no}">
	                                        <div class="reply-menu-container">
	                                            <button type="button" class="menu-btn" onclick="toggleReplyMenu(event, ${reply.r_no})">⋮</button>
	                                            <div id="reply-dropdown-${reply.r_no}" class="dropdown-menu">
	                                                <c:if test="${pageContext.request.userPrincipal.name == reply.m_id}">
	                                                    <button type="button" onclick="showReplyEditForm(${reply.r_no})">수정</button>
	                                                </c:if>
	                                                <c:if test="${pageContext.request.userPrincipal.name == reply.m_id || pageContext.request.isUserInRole('ADMIN')}">
	                                                    <button type="button" onclick="deleteReply(${reply.r_no}, ${board.b_no})">삭제</button>
	                                                </c:if>
	                                            </div>
	                                        </div>
											<div id="reply-view-${reply.r_no}">
											    <!-- 왼쪽: 작성자 아이콘 + ID + 내용 -->
											    <div class="reply-main">
											        <!-- 메타 정보 (아이디 + 시간)를 한 줄로 묶음 -->
											        <div class="reply-meta">
											            🌸 <span class="author-id">${reply.m_id}</span>
											            <small><fmt:formatDate value="${reply.r_date}" pattern="MM.dd HH:mm" /></small>
											        </div>
											        
											        <!-- 내용은 다음 줄에 위치 -->
											        <span class="reply-content" id="reply-text-content-${reply.r_no}">${reply.r_text}</span> 
											    </div>
											</div>
	                                        <div id="reply-edit-mode-${reply.r_no}" class="reply-edit-mode" style="display:none;">
	                                            <input type="text" id="reply-edit-input-${reply.r_no}" class="reply-edit-input" value="${reply.r_text}">
	                                            <button type="button" onclick="updateReply(${reply.r_no})">확인</button>
	                                        </div>
	                                    </div>
	                                </c:forEach>
	                            </div>
	                        </div> <!-- .reply-section 닫기 -->
	                    </div> <!-- .scroll-content 닫기 -->

	                    <div class="reply-input-wrapper">
	                        <input type="text" id="reply-input-${board.b_no}" placeholder="댓글을 입력하세요...">
	                        <button onclick="addReply(${board.b_no})">등록</button>
	                    </div>
	                </div> <!-- .text-area 닫기 -->
	            </div> <!-- #view-mode 닫기 -->

	            <!-- [B] 게시글 수정 모드 -->
	            <div id="edit-mode-${board.b_no}" class="edit-container" style="display:none;">
	                <form id="editForm-${board.b_no}" enctype="multipart/form-data">
	                    <table class="edit-table">
	                        <tr>
	                            <td colspan="2" class="bg-point">
	                                <div class="star-rating">
	                                    <c:forEach var="i" begin="1" end="5" varStatus="vs">
	                                        <c:set var="starVal" value="${6 - vs.count}" />
	                                        <input type="radio" id="star-${starVal}-${board.b_no}" name="b_rating" value="${starVal}" ${board.b_rating == starVal ? 'checked' : ''} />
	                                        <label for="star-${starVal}-${board.b_no}">★</label>
	                                    </c:forEach>
	                                </div>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td colspan="2" class="edit-image-cell">
	                                <div class="file-input-wrapper">
	                                    <div id="edit-preview-container-${board.b_no}" class="edit-preview-container">
	                                        <c:forEach var="imgName" items="${board.b_image_list}">
	                                            <img src="${pageContext.request.contextPath}/img/${imgName}" class="edit-preview-img">
	                                        </c:forEach>
	                                    </div>
	                                    <input type="file" id="edit-file-${board.b_no}" name="b_upload_list" multiple style="display:none;" onchange="updatePreview(this, '${board.b_no}')">
	                                    <label for="edit-file-${board.b_no}" class="file-input-label">📸 사진 변경하기</label>
	                                </div>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td>
	                                <textarea id="edit-text-${board.b_no}" name="b_text" class="edit-textarea" rows="5">${board.b_text}</textarea>
	                            </td>
	                            <td class="edit-action-cell">
	                                <div class="btn-group-vertical">
	                                    <button type="button" class="btn-edit-action btn-save" onclick="submitUpdate(${board.b_no}, this)">수정</button>
	                                    <button type="button" class="btn-edit-action btn-cancel" onclick="cancelEdit(${board.b_no})">취소</button>
	                                </div>
	                            </td>
	                        </tr>
	                    </table>
	                </form>
	            </div> <!-- #edit-mode 닫기 -->
	        </div> <!-- .result-container 닫기 -->
	    </c:forEach>
	</div> <!-- #review-list 닫기 -->
			</div> <!-- .content-container 닫기 -->
		<%@ include file="/WEB-INF/views/common/footer.jsp" %>    
	</body>
</html>