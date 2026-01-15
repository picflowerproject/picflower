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
<script src="${pageContext.request.contextPath}/js/simple_board.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/simple_board.css">
<script>
    const contextPath = "${pageContext.request.contextPath}";
	const isLogin = ${pageContext.request.userPrincipal != null};
</script>

</head>
<body>
<!-- 후기 섹션 시작 -->
<div class="product-review-container" style=" padding: 20px;">
    <table class="review-table">
        <thead>
            <tr>
            	<th width="15%">후기사진</th>
            	<th width="35%">후기글 및 댓글</th>
                <th width="15%">작성자</th>
                <th width="15%">별점</th>
                <th width="20%">등록일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="board" items="${reviewList}">
                <tr>
                
                	<!-- 3. 후기사진 (첫 번째 사진만 썸네일로 표시) -->
                    <td class="text-center">
                        <c:if test="${not empty board.b_image_list}">
                            <img src="${pageContext.request.contextPath}/img/${board.b_image_list[0]}" 
                                 class="review-thumb" 
                                 style="width: 80px; height: 80px; object-fit: cover; border-radius: 8px;">
                        </c:if>
                        <c:if test="${empty board.b_image_list}">
                            <span style="color: #ccc; font-size: 12px;">사진 없음</span>
                        </c:if>
                    </td>
                    
                    
                     <!-- 4. 후기글 및 댓글 -->
                    <td>
					    <!-- 1. 후기 글 -->
					    <div class="review-text-content">
					        <strong><c:out value="${board.b_text}" /></strong>
					    </div>
					    
					    <!-- 2. 댓글 토글 버튼 -->
					    <c:if test="${not empty board.replies}">
					        <button type="button" class="btn-reply-toggle">
					            댓글 보기 <span class="icon">▼</span>
					        </button>
					
					        <!-- 버튼 바로 다음에 와야 .next()가 작동합니다 -->
					        <div class="review-replies" style="display: none;"> 
					            <c:forEach var="reply" items="${board.replies}">
					                <div class="reply-item">
					                    <strong>${reply.m_id}</strong> : ${reply.r_text}
					                </div>
					            </c:forEach>
					        </div>
					    </c:if>
					</td>

                    <!-- 1. 작성자 -->
                    <td class="text-center">${board.m_id}</td>

                    <!-- 2. 별점 (고정된 별 표시) -->
                    <td class="text-center">
                        <span class="star-display" style="color: #ffb800;">
                            <c:forEach var="i" begin="1" end="5">
                                ${i <= board.b_rating ? '★' : '☆'}
                            </c:forEach>
                        </span>
                    </td>

                    
                   

                    <!-- 5. 등록일 -->
                    <td class="text-center">
                        <fmt:formatDate value="${board.b_date}" pattern="yyyy-MM-dd HH:mm"/>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    
    <c:if test="${empty reviewList}">
              
                    <div colspan="5" class="text-center" style="padding: 50px; color: #999;">
                        아직 작성된 후기가 없습니다. 첫 번째 후기를 남겨보세요! 🌸
                    </div>
               
    </c:if>
</div>
	</body>
</html>