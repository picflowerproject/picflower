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

</style>    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/MemberDetail.css">
<script src="${pageContext.request.contextPath}/js/simple_board.js"></script>
<script>
/* 탭 전환 스크립트 */
function changeTab(tabId, element) {
    document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
    document.querySelectorAll('.tab-item').forEach(tab => tab.classList.remove('active'));
    
    document.getElementById(tabId).classList.add('active');
    element.classList.add('active');
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


/* 비밀번호 체크 로직 */
function openPwCheck() { document.getElementById('pwModal').style.display = 'flex'; document.getElementById('confirmPw').focus(); }
function closePwCheck() { document.getElementById('pwModal').style.display = 'none'; document.getElementById('confirmPw').value = ''; }

function handleEditClick(isSocial) {
    if (isSocial) {
        // 카카오 유저는 비번 입력 없이 바로 검증 함수 호출 (빈 값 전송)
        validatePw(""); 
    } else {
        // 일반 유저는 비밀번호 입력 모달 열기
        openPwCheck();
    }
}

/* 비밀번호 체크 및 페이지 이동 로직 */
function validatePw(inputPw) {
    // 인자로 넘어온 값이 없으면(일반유저) 입력창에서 값을 가져옴
    const pw = (inputPw !== undefined) ? inputPw : document.getElementById("confirmPw").value;
    
    if (inputPw === undefined && !pw) { 
        alert("비밀번호를 입력하세요."); 
        return; 
    }

    $.ajax({
        url: "/member/checkPassword",
        type: "POST",
        data: { m_pwd: pw },
        success: function(res) {
            if (res.success) {
                // 수정 폼으로 이동 (m_no 파라미터 포함)
                location.href = '/member/memberUpdateForm?m_no=${detail.m_no}';
            } else {
                alert("비밀번호가 일치하지 않습니다.");
            }
        },
        error: function() {
            alert("인증 중 오류가 발생했습니다.");
        }
    });
}

function withdrawMember(m_no) {
    if (confirm("정말로 탈퇴하시겠습니까?\n탈퇴 시 작성하신 게시글과 주문 내역은 '탈퇴사용자'로 전환됩니다.")) {
        // 탈퇴 처리 컨트롤러로 이동 (m_no 파라미터 전송)
        location.href = "/member/memberDelete?m_no=" + m_no;
    }
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
			    <!-- 관리자 버튼 -->
			    <sec:authorize access="hasAuthority('ROLE_ADMIN')">
			        <button type="button" class="btn-admin-list" onclick="location.href='/admin/memberList'">회원목록</button>
			    </sec:authorize>
			
			    <!-- 정보수정 및 회원탈퇴 버튼 -->
			    <sec:authorize access="isAuthenticated()">
			        <sec:authentication property="name" var="currentId" /> 
			        <c:if test="${currentId == detail.m_id}">
			            <sec:authentication property="principal" var="principal" />
			            <c:set var="isSocial" value="${fn:contains(principal.getClass().name, 'OAuth2')}" />
			            
			            <!-- 정보수정 버튼 -->
			            <button type="button" class="btn-lavender" onclick="handleEditClick(${isSocial})">정보수정</button>
			            
			            <!-- 회원탈퇴 버튼 추가 -->
			            <button type="button" class="btn-delete" onclick="withdrawMember(${detail.m_no})">
			                회원탈퇴
			            </button>
			        </c:if>
			    </sec:authorize>
			</div>
			</div>
	
            <!-- 탭 2: 나의 주문 내역 -->
            <div id="order" class="tab-content">
				<table class="order-table">
				    <thead>
				        <tr>
				            <th width="10%">주문번호</th>
				            <th width="30%">상품명</th> <!-- 추가된 열 -->
				            <th width="10%">받는분</th>
				            <th width="10%">결제금액</th>
				            <th width="20%">주문일자</th>
				            <th width="10%">주문상태</th>
				            <th width="10%">환불</th>
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