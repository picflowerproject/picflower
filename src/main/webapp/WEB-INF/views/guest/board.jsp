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
	const isLogin = ${pageContext.request.userPrincipal != null};
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
								<sec:authorize access="isAuthenticated()">
								           <!-- ✅ 본인 글이거나 관리자일 때만 버튼(⋮) 자체를 생성 -->
								           <c:if test="${pageContext.request.userPrincipal.name == board.m_id || pageContext.request.isUserInRole('ROLE_ADMIN')}">
								               <button class="menu-btn" onclick="toggleMenu(${board.b_no})">⋮</button>
								               <div id="dropdown-${board.b_no}" class="dropdown-menu">
								                   <!-- 수정하기는 본인만 -->
								                   <c:if test="${pageContext.request.userPrincipal.name == board.m_id}">
								                       <button type="button" onclick="showEditForm(${board.b_no})">수정하기</button>
								                   </c:if>
								                   <!-- 삭제하기는 본인 또는 관리자 -->
								                   <button type="button" onclick="deleteReview(${board.b_no})">삭제하기</button>
								               </div>
								           </c:if>
									</sec:authorize>
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
												<!-- 로그인한 경우에만 점 3개 버튼 출력 -->
												<sec:authorize access="isAuthenticated()">
												       <!-- ✅ 본인 댓글이거나 관리자일 때만 버튼(⋮)과 메뉴 그룹 생성 -->
												       <c:if test="${pageContext.request.userPrincipal.name == reply.m_id || pageContext.request.isUserInRole('ADMIN')}">
												           <button type="button" class="menu-dot-btn" id="reply-dot-${reply.r_no}" onclick="showInlineMenu(${reply.r_no})">⋮</button>
												           
												           <div class="inline-menu-group" id="inline-menu-${reply.r_no}" style="display:none;">
												               <!-- 수정은 본인만 -->
												               <c:if test="${pageContext.request.userPrincipal.name == reply.m_id}">
												                   <button type="button" class="inline-btn edit" onclick="showReplyEditForm(${reply.r_no})">수정</button>
												               </c:if>
												               <!-- 삭제는 본인 또는 관리자 -->
												               <button type="button" class="inline-btn delete" onclick="deleteReply(${reply.r_no}, ${board.b_no})">삭제</button>
												               <!-- 취소 버튼 -->
												               <button type="button" class="inline-btn cancel" onclick="hideInlineMenu(${reply.r_no})">취소</button>
												           </div>
												       </c:if>
												   </sec:authorize>
											    <!-- [클릭 후] 전환될 메뉴 그룹 (기본 숨김) -->
											    <div class="inline-menu-group" id="inline-menu-${reply.r_no}" style="display:none;">
											        <c:if test="${pageContext.request.userPrincipal.name == reply.m_id}">
											            <button type="button" class="inline-btn edit" onclick="showReplyEditForm(${reply.r_no})">수정</button>
											        </c:if>
											        <c:if test="${pageContext.request.userPrincipal.name == reply.m_id || pageContext.request.isUserInRole('ADMIN')}">
											            <button type="button" class="inline-btn delete" onclick="deleteReply(${reply.r_no}, ${board.b_no})">삭제</button>
											        </c:if>
											        <!-- 다시 점으로 돌아가는 취소 버튼 -->
											        <button type="button" class="inline-btn cancel" onclick="hideInlineMenu(${reply.r_no})">취소</button>
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
						    <input type="text" 
						           id="reply-input-${board.b_no}" 
						           placeholder="${pageContext.request.userPrincipal != null ? '댓글을 입력하세요...' : '로그인이 필요한 서비스입니다.'}"
						           ${pageContext.request.userPrincipal == null ? 'readonly' : ''}>
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
							<!-- [B] 게시글 수정 모드 내부 이미지 행 -->
							<tr>
							    <td colspan="2" class="edit-image-cell">
							        <div class="file-input-wrapper">
										<!-- 2. 버튼이 그 아래 왼쪽으로 배치됨 -->
											<div class="file-btn-area">
											<input type="file" id="edit-file-${board.b_no}" name="b_upload_list" multiple style="display:none;" onchange="updatePreview(this, '${board.b_no}')">
											<label for="edit-file-${board.b_no}" class="file-input-label">
											  📸 사진 변경하기
											</label>
										</div>										
										
							            <!-- 1. 사진 미리보기가 먼저 나옴 (가로 나열) -->
							            <div id="edit-preview-container-${board.b_no}" class="edit-preview-container">
							                <c:forEach var="imgName" items="${board.b_image_list}">
							                    <img src="${pageContext.request.contextPath}/img/${imgName}" class="edit-preview-img">
							                </c:forEach>
							            </div>
							            
							            
							        </div>
							    </td>
							</tr>
							<!-- 3행: 텍스트 (가로 꽉 채우기) -->
							            <tr>
							                <td colspan="2">
							                    <textarea id="edit-text-${board.b_no}" name="b_text" class="edit-textarea" rows="5">${board.b_text}</textarea>
							                </td>
							            </tr>
							        </table>

							        <!-- ✅ 수정/취소 버튼을 테이블 밖 오른쪽 하단으로 배치 -->
							        <div class="edit-btn-wrapper">
							            <button type="button" class="btn-edit-action btn-save" onclick="submitUpdate(${board.b_no}, this)">수정 완료</button>
							            <button type="button" class="btn-edit-action btn-cancel" onclick="cancelEdit(${board.b_no})">취소</button>
							        </div>
							    </form>
	            </div> <!-- #edit-mode 닫기 -->
	        </div> <!-- .result-container 닫기 -->
	    </c:forEach>
	</div> <!-- #review-list 닫기 -->
			</div> <!-- .content-container 닫기 -->
		<%@ include file="/WEB-INF/views/common/footer.jsp" %>    
	</body>
</html>