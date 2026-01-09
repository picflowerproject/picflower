<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
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

<script>
function scrollReply(btn, direction) {
    // 1. 클릭한 버튼의 부모(.reply-section) 내에서 슬라이더를 찾습니다.
    const slider = btn.parentElement.querySelector('.reply-slider');
    
    if (!slider) return;

    // 2. 현재 화면에 보이는 슬라이더의 너비(한 페이지 분량)를 가져옵니다.
    const scrollAmount = slider.clientWidth; 
    
    // 3. scrollBy를 사용하여 부드럽게 이동시킵니다.
    slider.scrollBy({
        left: direction * scrollAmount,
        behavior: 'smooth'
    });
}

//수정용 미리보기 함수
function updatePreview(input, b_no) {
    // 1. b_no 값이 비어있는지 먼저 체크
    if (!b_no || b_no === 'undefined') {
        console.error("오류: b_no 값이 전달되지 않았습니다.");
        return;
    }

    if (input.files && input.files[0]) {
        const reader = new FileReader();
        
        reader.onload = function(e) {
            // ID를 수동으로 결합하여 찾기
            const targetId = "edit-preview-" + b_no;
            const preview = document.getElementById(targetId);
            
            if (preview) {
                preview.src = e.target.result;
                preview.style.display = 'block';
                console.log(targetId + " 요소의 이미지가 성공적으로 교체되었습니다.");
            } else {
                // 이 에러가 계속 뜬다면 JSP의 <img id="..."> 부분의 ID와 일치하는지 확인해야 합니다.
                console.error("미리보기 이미지 요소를 찾을 수 없습니다: " + targetId);
            }
        };
        
        reader.readAsDataURL(input.files[0]);
    }
}

function submitUpdate(b_no, btn) {
    // 1. 버튼에서 가장 가까운 form 요소를 직접 찾습니다.
    const formElement = btn.closest('form'); 

    if (!formElement) {
        console.error("폼 요소를 찾을 수 없습니다.");
        return;
    }

    // 2. FormData 생성 (Parameter 1 에러가 사라집니다)
    const formData = new FormData(formElement);

    // 3. 별점 값 추출 (현재 폼 내부에 있는 값만)
    const ratingInput = formElement.querySelector(`input[name="b_rating"]:checked`);
    const rating = ratingInput ? ratingInput.value : 0;
    
    // 추가 데이터 세팅
    formData.set("b_no", b_no);
    formData.set("b_rating", rating);

    $.ajax({
        url: '/b_update', // 서버 경로 확인
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function(res) {
            if(res.trim() === "success") {
                alert("수정되었습니다.");
                location.reload();
            } else {
                alert("수정 실패");
            }
        }
    });
}
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<div class="content-container">
	    <h1>Flower Garden</h1>
   		 <span>여러분의 소중한 후기를 작성해주세요</span>

	<jsp:include page="boardForm.jsp" />
	<!-- 결과들이 추가될 컨테이너 -->
	<!-- DB에서 가져온 리뷰 목록 출력 (JSTL 사용) -->
 	<div id="review-list">
    <c:forEach var="board" items="${list}" varStatus="status">
        <div class="result-container" id="board-container-${board.b_no}">
            
            <!-- [A] 출력 모드  -->
            <div id="view-mode-${board.b_no}" class="view-wrapper ${status.index % 2 != 0 ? 'view-wrapper-reverse' : ''}">
                <div class="image-area">
                    <c:if test="${not empty board.b_image_name}">
                        <img src="/img/${board.b_image_name}" alt="리뷰이미지">
                    </c:if>
                </div>
                
                <div class="text-area">
                    <div class="menu-container">
                        <span class="author-id">${board.m_id}</span>
                        <div class="dropdown-wrapper">
                            <button class="menu-btn" onclick="toggleMenu(${board.b_no})">⋮</button>
                            <div id="dropdown-${board.b_no}" class="dropdown-menu">
                                <button type="button" onclick="showEditForm(${board.b_no})">수정하기</button>
                                <!-- JS 가독성을 위해 href 대신 button 권장 -->
                                <button type="button" onclick="deleteReview(${board.b_no})">삭제하기</button>
                            </div>
                        </div>
                    </div>

                    <div class="rating-like-container">
                        <div class="stars">
                            <c:forEach var="i" begin="1" end="5">
                                ${i <= board.b_rating ? '★' : '☆'}
                            </c:forEach>
                        </div>
                        <button class="like-btn" onclick="likeUp(${board.b_no})">
                            🌸 <span id="like-count-${board.b_no}">${board.b_like}</span>
                        </button>
                    </div>

                    <div class="scroll-content">
                        <p id="text-p-${board.b_no}">${board.b_text}</p>
                    

                    <!-- 댓글 섹션 (반복되는 부분 최소화) -->
                    <div class="reply-section">
                        <div id="reply-list-${board.b_no}" class="reply-slider">
                            <c:forEach var="reply" items="${board.replies}">
                                <div id="reply-item-${reply.r_no}" class="reply-item">
                                    <div class="reply-menu-container">
                                        <button type="button" class="menu-btn" onclick="toggleReplyMenu(event, ${reply.r_no})">⋮</button>
                                        <div id="reply-dropdown-${reply.r_no}" class="dropdown-menu">
                                            <button type="button" onclick="showReplyEditForm(${reply.r_no})">수정</button>
                                            <button type="button" onclick="deleteReply(${reply.r_no})">삭제</button>
                                        </div>
                                    </div>
                                    <div id="reply-view-${reply.r_no}">
									    🌸 <span class="author-id">${board.m_id}</span>
									    <span>${reply.r_text}</span> 
									    <small><fmt:formatDate value="${reply.r_date}" pattern="MM.dd HH:mm" /></small>
									</div>
                                    <div id="reply-edit-mode-${reply.r_no}" class="reply-edit-mode" style="display:none;">
                                        <input type="text" id="reply-edit-input-${reply.r_no}" class="reply-edit-input" value="${reply.r_text}">
                                        <button type="button" onclick="updateReply(${reply.r_no})">확인</button>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        </div>
                    </div>

                    <div class="reply-input-wrapper">
                        <input type="text" id="reply-input-${board.b_no}" placeholder="댓글을 입력하세요...">
                        <button onclick="addReply(${board.b_no})">등록</button>
                    </div>
                </div>
            </div>

            <!-- [B] 게시글 수정 모드 -->
				<div id="edit-mode-${board.b_no}" class="edit-container" style="display:none;">
				    <form id="editForm-${board.b_no}" enctype="multipart/form-data">
				        <table class="edit-table">
				            <!-- 1행: 별점 -->
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
				
				            <!-- 2행: 이미지 영역 -->
				            <tr>
				                <td colspan="2" class="edit-image-cell">
				                    <div class="file-input-wrapper">
				                        <img id="edit-preview-${board.b_no}" 
				                             src="${not empty board.b_image_name ? '/img/'.concat(board.b_image_name) : ''}" 
				                             class="edit-preview-img" 
				                             style="${empty board.b_image_name ? 'display:none;' : 'display:block;'}">
				                        
				                        <input type="file" id="edit-file-${board.b_no}" name="b_image" 
				                               style="display:none;" onchange="updatePreview(this, '${board.b_no}')">
				                        <label for="edit-file-${board.b_no}" class="file-input-label">📸 사진 변경하기</label>
				                    </div>
				                </td>
				            </tr>
				
				            <!-- 3행: 텍스트 및 버튼 (기존 클래스 btn-edit-action, btn-save 등 복구) -->
				            <tr>
				                <td>
				                    <textarea id="edit-text-${board.b_no}" name="b_text" class="edit-textarea" rows="5">${board.b_text}</textarea>
				                </td>
				                <td class="edit-action-cell">
				                    <div class="btn-group-vertical">
				                        <!-- 기존 CSS 클래스명을 정확히 다시 넣었습니다 -->
				                        <button type="button" class="btn-edit-action btn-save" onclick="submitUpdate(${board.b_no}, this)">수정</button>
				                        <button type="button" class="btn-edit-action btn-cancel" onclick="cancelEdit(${board.b_no})">취소</button>
				                    </div>
				                </td>
				            </tr>
				        </table>
				    </form>
				</div>
        </div>
    </c:forEach>
</div><!-- review-list 끝 -->
</div><%@ include file="/WEB-INF/views/common/footer.jsp" %>    
</body>
</html>