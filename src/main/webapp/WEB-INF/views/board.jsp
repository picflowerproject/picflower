<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Flower Garden</title>
<script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/reply.css">
<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>

<!-- JS 연결 (변수 설정 아래에 위치) -->
<script src="${pageContext.request.contextPath}/js/board.js"></script>
<script src="${pageContext.request.contextPath}/js/reply.js"></script>

</head>

<body>
	<jsp:include page="boardForm.jsp" />
	<!-- 결과들이 추가될 컨테이너 -->
		<!-- 2. DB에서 가져온 리뷰 목록 출력 (JSTL 사용) -->
 		<div id="review-list">
    <c:forEach var="board" items="${list}">
        <!-- 게시글 전체 컨테이너 -->
        <div class="result-container" id="board-container-${board.b_no}">
            
            <!-- [A] 출력 모드 (기존 view-mode) -->
            <div id="view-mode-${board.b_no}" class="view-wrapper" style="width:100%;">
                <div class="image-area">
                    <c:if test="${not empty board.b_image_name}">
                        <img src="/img/${board.b_image_name}" alt="리뷰이미지">
                    </c:if>
                </div>

                <div class="text-area">
                    <div class="menu-container">
                        <span class="author-id">${board.m_id}</span>
                        <div style="position: relative;">
                            <button class="menu-btn" onclick="toggleMenu(${board.b_no})">⋮</button>
                            <div id="dropdown-${board.b_no}" class="dropdown-menu">
                                <button type="button" onclick="showEditForm(${board.b_no})">수정하기</button>
                                <a href="javascript:void(0);" onclick="deleteReview(${board.b_no})" style="color: red; text-decoration: none; padding: 10px; display: block;">삭제하기</a>
                            </div>
                        </div>
                    </div>
                    
                    <p style="color:#f5b301; font-size:1.2rem; margin:0;">
                        <c:forEach var="i" begin="1" end="5">
                            ${i <= board.b_rating ? '★' : '☆'}
                        </c:forEach>
                    </p>
                    <p id="text-p-${board.b_no}" style="margin: 10px 0; white-space: pre-wrap;">${board.b_text}</p>
                    
                    <button class="like-btn" onclick="likeUp(${board.b_no})">
                        🌸 <span id="like-count-${board.b_no}">${board.b_like}</span>
                    </button>
                      
                      
                <!-- 게시글 하단 댓글 영역 -->
				<div id="reply-list-${board.b_no}">
				    <c:forEach var="reply" items="${board.replies}">
				        <!-- 댓글 한 개 아이템 (ID 부여) -->
				        <div id="reply-item-${reply.r_no}" class="reply-item" style="border-bottom:1px solid #eee; padding:10px; position:relative;">
					            
				       	 	<!-- 댓글 메뉴 버튼 -->
				            <div class="reply-menu-container" style="position:absolute; right:10px; top:10px;">
				                <button type="button" class="menu-btn" onclick="toggleReplyMenu(event, ${reply.r_no})">⋮</button>
				                <div id="reply-dropdown-${reply.r_no}" class="dropdown-menu">
				                    <!-- 댓글 전용 수정 함수 호출 -->
				                    <button type="button" onclick="showReplyEditForm(${reply.r_no})">수정</button>
				                    <button type="button" onclick="deleteReply(${reply.r_no})">삭제</button>
				                </div>
				            </div>
				
				            <!-- [A] 댓글 보기 모드 -->
					            <div id="reply-view-${reply.r_no}">
					                🌸 <span id="reply-text-content-${reply.r_no}">${reply.r_text}</span>
					                <small style="color:gray; display:block; margin-top:5px;">(${reply.r_date})</small>
					            </div>
				
				           <!-- [B] 댓글 수정 모드 (기존 게시글 수정폼 삭제 후 새로 작성) -->
				            <div id="reply-edit-mode-${reply.r_no}" style="display:none; width: 100%;">
				                <input type="text" id="reply-edit-input-${reply.r_no}" value="${reply.r_text}" style="width:80%; border:1px solid #f5b301; padding:5px;">
				                <div style="margin-top:5px;">
				                    <button type="button" onclick="updateReply(${reply.r_no})" style="background:#f5b301; color:white; border:none; padding:3px 10px; cursor:pointer;">확인</button>
				                    <button type="button" onclick="cancelReplyEdit(${reply.r_no})" style="background:#ccc; color:white; border:none; padding:3px 10px; cursor:pointer;">취소</button>
				                </div>
	          	  			</div>
		        		</div>
		    	</c:forEach>
			</div>
			
				<!-- 댓글 입력창 -->
                    <div style="margin-top:10px;">
                        <input type="text" id="reply-input-${board.b_no}" style="width:80%;">
                        <button onclick="addReply(${board.b_no})">등록</button>
                    </div>
                </div>
            </div> <!-- [A] view-mode 끝 -->
            
            <!-- [B] 게시글 수정 모드 (반드시 view-mode와 형제 관계이고 루프 밖에 위치) -->
	            <div id="edit-mode-${board.b_no}" style="display:none; width:100%;">
	                <h3 style="margin-top:0;">후기 수정</h3>
	                <textarea id="edit-text-${board.b_no}" rows="4" style="width:100%; border:1px solid #f5b301; padding:10px;">${board.b_text}</textarea>
	                <div style="text-align:right; margin-top:10px;">
	                    <button type="button" onclick="updateReview(${board.b_no})" style="background:#f5b301; color:white; border:none; padding:5px 15px; cursor:pointer;">수정완료</button>
	                    <button type="button" onclick="cancelEdit(${board.b_no})" style="background:#ccc; color:white; border:none; padding:5px 15px; cursor:pointer;">취소</button>
	                </div>
	            </div> <!-- [B] edit-mode 끝 -->
	        </div> <!-- result-container 끝 -->
	    </c:forEach>
	</div>
</body>
</html>