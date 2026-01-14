<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <title>마이페이지</title>

<style>
/* 화면 전체를 덮는 반투명 배경 */
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.6); /* 어두운 배경 */
    display: none; /* 기본은 숨김 */
    align-items: center; /* 수직 중앙 */
    justify-content: center; /* 수평 중앙 */
    z-index: 9999; /* 최상단에 뜨도록 설정 */
}

/* 팝업 박스 디자인 */
.modal-content {
    background-color: #fff;
    padding: 30px;
    border-radius: 12px;
    width: 350px;
    text-align: center;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
}

.modal-content h3 {
    margin-top: 0;
    color: #333;
}

.modal-content input {
    width: 100%;
    padding: 12px;
    margin: 20px 0;
    box-sizing: border-box;
    border: 1px solid #ddd;
    border-radius: 4px;
}

.modal-buttons {
    display: flex;
    gap: 10px;
    justify-content: center;
}

.modal-buttons button {
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

/* 확인 버튼 (라벤더 스타일 유지) */
.modal-buttons button:first-child {
    background-color: #e6e6fa; /* 라벤더 색상 */
    color: #555;
}

/* 취소 버튼 */
.modal-buttons button:last-child {
    background-color: #ddd;
    color: #333;
}


/* 탭 메뉴 전체 스타일 */
.mypage-tabs {
    display: flex;
    list-style: none;
    padding: 0;
    border-bottom: 2px solid #f0f0f0;
    margin: 20px 0 30px 0;
}

/* 개별 탭 버튼 */
.tab-item {
    padding: 12px 25px;
    cursor: pointer;
    font-weight: bold;
    color: #888;
    border-bottom: 3px solid transparent;
    transition: all 0.3s;
}

/* 마우스 올렸을 때 */
.tab-item:hover {
    color: #5b5baf;
}

/* 활성화된 탭 스타일 */
.tab-item.active {
    color: #5b5baf;
    border-bottom: 3px solid #e6e6fa; /* 라벤더 포인트 */
}

/* 탭 컨텐츠 기본 숨김 */
.tab-content {
    display: none;
}

/* 활성화된 컨텐츠만 보임 */
.tab-content.active {
    display: block;
}

/* 주문 테이블 스타일 보정 */
.order-table {
    width: 100%;
    border-collapse: collapse;
}
.order-table th, .order-table td {
    padding: 15px;
    border: 1px solid #eee;
    text-align: center;
}
</style>    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/MemberDetail.css">
<script>
/* 탭 전환 스크립트 */
function changeTab(tabId, element) {
    document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
    document.querySelectorAll('.tab-item').forEach(tab => tab.classList.remove('active'));
    
    document.getElementById(tabId).classList.add('active');
    element.classList.add('active');
}

/* 비밀번호 체크 로직 */
function openPwCheck() { document.getElementById('pwModal').style.display = 'flex'; document.getElementById('confirmPw').focus(); }
function closePwCheck() { document.getElementById('pwModal').style.display = 'none'; document.getElementById('confirmPw').value = ''; }

function validatePw() {
    const pw = document.getElementById('confirmPw').value;
    if(!pw) { alert("비밀번호를 입력하세요."); return; }
    fetch('/member/checkPassword', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'm_pwd=' + encodeURIComponent(pw)
    })
    .then(res => res.json())
    .then(data => {
        if(data.success) location.href = '/member/memberUpdateForm?m_no=${detail.m_no}';
        else alert("비밀번호가 일치하지 않습니다.");
    });
}

/* 주문 취소(환불) 로직 */
function cancelOrder(btn) {
    const imp_uid = btn.dataset.impUid;
    const o_no = btn.dataset.oNo;
    if (!confirm("정말로 환불하시겠습니까?")) return;

    $.ajax({
        url: '/member/orderCancel',
        method: 'POST',
        data: { imp_uid: imp_uid, o_no: o_no },
        success: function(response) {
            if (response === 'success') { alert('주문 취소 완료'); location.reload(); }
            else alert('취소 실패');
        }
    });
}
</script>

</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <main class="content-wrapper">
        <div class="content-container">
			<h2>마이페이지</h2>

				 <!-- 탭 메뉴 영역 -->
		            <ul class="mypage-tabs">
		                <li class="tab-item active" onclick="changeTab('info', this)">회원정보</li>
		                <li class="tab-item" onclick="changeTab('order', this)">주문/배송 내역</li>
		            </ul>

            <div id="info" class="tab-content active">
            <table border="1">
                <tr>
                    <td>번호</td>
                    <td>${detail.m_no}</td>
                    <td>아이디</td>
                    <td>${detail.m_id}</td>
                </tr>
                <tr>
                    <td>이름</td>
                    <td>${detail.m_name}</td>
                    <td>성별</td>
                    <td>${detail.m_gender}</td>
                </tr>
                <tr>
                    <td>생년월일</td>
                    <c:set var="birth" value="${fn:replace(fn:substring(detail.m_birth, 0, 10), '-', '')}" />
                    <td><c:out value="${fn:substring(birth,0,4)}년 ${fn:substring(birth,4,6)}월 ${fn:substring(birth,6,8)}일" /></td>
                    <td>연락처</td>
                    <td>${detail.m_tel}</td>
                </tr>
                <tr>
                    <td>이메일</td>
                    <td>${detail.m_email}</td>
                    <td>좋아하는 꽃</td>
                    <td>${detail.m_flower}</td>
                </tr>
				<!-- 가입일과 권한 항목 수정 -->
							<sec:authorize access="hasAuthority('ROLE_ADMIN')">
							    <tr>
							        <td>가입일</td>
							        <td><fmt:formatDate value="${detail.m_date}" pattern="yyyy-MM-dd"/></td>
							        <td>권한</td>
							        <td>${detail.m_auth}</td>
							    </tr>
							</sec:authorize>
                <tr>
                    <td>주소</td>
                    <td colspan="3">${detail.m_addr}</td>
                </tr>
				
              	
            </table>
			
			<div class="button-container">
			    <!-- 1. 로그인 여부 확인 및 현재 로그인된 ID를 변수(currentId)에 저장 -->
			    <sec:authorize access="isAuthenticated()">
			        <sec:authentication property="principal.username" var="currentId" />

			        <!-- 2. 로그인된 ID와 페이지 상세정보의 ID(detail.m_id)가 일치할 때만 버튼 출력 -->
			        <c:if test="${currentId == detail.m_id}">
			            <button type="button" class="btn-lavender" onclick="openPwCheck()">정보수정</button>
			        </c:if>
			        
			    </sec:authorize>
				
				<!-- 2. 관리자(ADMIN) 권한일 때만 '회원목록' 버튼 표시 -->
				    <sec:authorize access="hasAuthority('ROLE_ADMIN')">
				        <button type="button" class="btn-lavender" onclick="location.href='/admin/memberList'">회원목록</button>
				    </sec:authorize>
			</div>
			</div>
	
            <!-- 탭 2: 나의 주문 내역 -->
            <div id="order" class="tab-content">
				<table class="order-table">
				    <thead>
				        <tr>
				            <th>주문번호</th>
				            <th>상품명</th> <!-- 추가된 열 -->
				            <th>받는분</th>
				            <th>결제금액</th>
				            <th>주문일자</th>
				            <th>주문상태</th>
				            <th>환불</th>
				        </tr>
				    </thead>
				    <tbody>
				        <c:forEach var="order" items="${orderList}">
				            <tr>
				                <td><span class="order-no">#${order.o_no}</span></td>
				                
				                <!-- 상품명 출력 영역 (서브쿼리로 가져온 p_title 활용) -->
				                <td style="text-align: left; padding-left: 20px;">
				                    <strong>
				                        <c:out value="${order.p_title}" />
				                        <c:if test="${order.product_count > 1}">
				                            <span style="color: #888; font-size: 0.9em;">
				                                외 ${order.product_count - 1}건
				                            </span>
				                        </c:if>
				                    </strong>
				                </td>
				                
				                <td><strong><c:out value="${order.o_name}" /></strong></td>
				                <td class="price-text">
				                    <fmt:formatNumber value="${order.o_total_price}" pattern="#,###"/>원
				                </td>
				                <td>
				                    <fmt:formatDate value="${order.o_date}" pattern="yyyy.MM.dd HH:mm"/>
				                </td>
				                <td>
				                    <span class="status-badge">${order.o_status}</span>
				                </td>
				                <td>
				                    <c:choose>
				                        <c:when test="${order.o_status == '결제완료'}">
				                           <button class="btn-cancel"
				                                    data-imp-uid="<c:out value='${order.imp_uid}'/>"
				                                    data-o-no="<c:out value='${order.o_no}'/>"
				                                    onclick="cancelOrder(this)">
				                                환불하기
				                            </button>
				                        </c:when>
				                        <c:otherwise>
				                            <span class="status-badge">${order.o_status}</span>
				                        </c:otherwise>
				                    </c:choose>
				                </td>
				            </tr>
				        </c:forEach>            
				        <c:if test="${empty orderList}">
				            <tr>
				                <td colspan="7" class="no-data"> <!-- colspan을 7로 변경 -->
				                    <div style="font-size: 40px; margin-bottom: 10px;">📦</div>
				                    최근 주문하신 내역이 없습니다.
				                </td>
				            </tr>
				        </c:if>
				    </tbody>
				</table>
            </div> 


            <!-- 비밀번호 확인 모달 -->
		<div id="pwModal" class="modal-overlay" style="display:none;">
   			 <div class="modal-content">
     		   <h3>비밀번호 확인</h3>
       		 <p>보안을 위해 비밀번호를 다시 입력해주세요.</p>
       	 <input type="password" id="confirmPw" placeholder="비밀번호 입력">
        <div class="modal-buttons">
            <button type="button" onclick="validatePw()">확인</button>
            <button type="button" onclick="closePwCheck()">취소</button>
        </div>
    </div>
</div>

        </div> 
    </main>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>