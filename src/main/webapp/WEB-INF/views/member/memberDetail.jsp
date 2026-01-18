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

/*주문취소 환불로직  */
function cancelOrder(btn) {
    // 1. 쉼표 제거 로직 추가
    let imp_uid = btn.dataset.impUid;
    if (imp_uid && imp_uid.startsWith(',')) {
        imp_uid = imp_uid.replace(/^,+/, ''); // 앞부분의 모든 쉼표 제거
    }
    
    const o_no = btn.dataset.oNo;

    console.log("수정된 imp_uid =", imp_uid); // 쉼표가 제거되었는지 확인

    if (!imp_uid || !o_no) {
        alert("결제 정보가 올바르지 않습니다.");
        return;
    }

    if (!confirm("정말로 환불하시겠습니까?")) return;

    $.ajax({
        url: '/member/orderCancel',
        method: 'POST',
        data: {
            imp_uid: imp_uid, // 정제된 데이터 전송
            o_no: o_no
        },
        success: function(response) {
            console.log("서버 응답 원문:", response); // F12 콘솔에서 확인용
            
            if (response.trim() === 'success') {
                alert('주문 취소 완료');
                location.reload();
            } else {
                // 서버에서 "fail"이나 "error occurred..." 메시지를 보낼 경우 출력
                alert('취소 실패 사유: ' + response);
            }
        },
        error: function(xhr, status, error) {
            console.error("에러 발생:", error);
            alert("서버 연결에 실패했습니다. 관리자에게 문의하세요.");
        }
    });
}


/* 비밀번호 체크 로직 */
function openPwCheck() { document.getElementById('pwModal').style.display = 'flex'; document.getElementById('confirmPw').focus(); }
function closePwCheck() { document.getElementById('pwModal').style.display = 'none'; document.getElementById('confirmPw').value = ''; }

function handleEditClick(isSocial) {
    if (isSocial) {
    	 if (confirm("보안을 위해 소셜 계정 재인증이 필요합니다.")) {
    		 
    		 showSecurityLoading(); 
    		 
    		 // 2. 0.5초~0.8초 정도 대기 후 서버로 이동 (사용자가 로딩을 인지할 시간)
             setTimeout(function() {
                 location.href = "/member/goSocialReauth";
             },600);
    		 
         }
    } else {
        openPwCheck(); 
    }
}


// 시각적 로딩 레이어 생성 함수
function showSecurityLoading() {
    const loader = document.createElement('div');
    loader.id = "security-overlay";
    loader.innerHTML = `
        <div style="position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.7); 
                    z-index:10000; display:flex; flex-direction:column; justify-content:center; align-items:center; color:white;">
            <div class="spinner" style="border:5px solid #f3f3f3; border-top:5px solid #A36CD9; border-radius:50%; width:50px; height:50px; animation:spin 1s linear infinite;"></div>
            <h3 style="margin-top:20px;">카카오 보안 세션을 연결 중입니다...</h3>
            <p style="font-size:0.9em; opacity:0.8;">잠시 후 카카오 로그인 창으로 이동합니다.</p>
        </div>
        <style>@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }</style>
    `;
    document.body.appendChild(loader);
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
            	 var mno = "${detail.m_no}"; // JSP에서 서버 데이터가 잘 박혔는지 확인
            	    console.log("이동할 번호:", mno);
            	    if(!mno || mno === "") {
            	        alert("회원 번호가 없습니다. 상세페이지로 이동합니다.");
            	        location.href = "/member/memberDetailId"; 
            	        return;
            	    }
            	
            	
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

            <!-- 1. 탭 메뉴 영역 -->
            <ul class="mypage-tabs">
                <li class="tab-item active" onclick="changeTab('info', this)">회원정보</li>
                <li class="tab-item" onclick="changeTab('order', this)">주문/배송 내역</li>
            </ul>

            <!-- 2. 탭 콘텐츠 1: 회원정보 -->
            <div id="info" class="tab-content active">
                <table class="info-table">
                    <tr>
                        <th>번호</th><td>${detail.m_no}</td>
                        <th>아이디</th><td>${detail.m_id}</td>
                    </tr>
                    <tr>
                        <th>이름</th><td>${detail.m_name}</td>
                        <th>성별</th><td>${detail.m_gender}</td>
                    </tr>
                    <tr>
                        <th>생년월일</th>
                        <c:set var="birth" value="${fn:replace(fn:substring(detail.m_birth, 0, 10), '-', '')}" />
                        <td><c:out value="${fn:substring(birth,0,4)}년 ${fn:substring(birth,4,6)}월 ${fn:substring(birth,6,8)}일" /></td>
                        <th>연락처</th><td>${detail.m_tel}</td>
                    </tr>
                    <tr>
                        <th>이메일</th><td>${detail.m_email}</td>
                        <th>좋아하는 꽃</th><td>${detail.m_flower}</td>
                    </tr>
                    <sec:authorize access="hasAuthority('ROLE_ADMIN')">
                        <tr>
                            <th>가입일</th><td><fmt:formatDate value="${detail.m_date}" pattern="yyyy-MM-dd"/></td>
                            <th>권한</th><td>${detail.m_auth}</td>
                        </tr>
                    </sec:authorize>
                    <tr>
                        <th>주소</th><td colspan="3">${detail.m_addr}</td>
                    </tr>
                </table>

                <!-- 버튼 컨테이너: 좌(목록) / 우(수정,삭제) 분리 -->
                <div class="button-container">
                    <div class="left-action">
                        <sec:authorize access="hasAuthority('ROLE_ADMIN')">
                            <button type="button" class="btn-list-gray" onclick="location.href='/admin/memberList'">회원목록</button>
                        </sec:authorize>
                    </div>
                    <div class="right-action">
                        <sec:authorize access="isAuthenticated()">
                            <sec:authentication property="name" var="currentId" />
                            <sec:authentication property="principal" var="principal" />
                            <c:set var="isSocial" value="${fn:contains(principal.getClass().name, 'OAuth2')}" />
                            <sec:authorize access="hasAuthority('ROLE_ADMIN')" var="isAdmin" />
                            <c:if test="${currentId == detail.m_id || isAdmin}">
                                <button type="button" class="btn-lavender" onclick="handleEditClick(${isSocial})">정보수정</button>
                                <button type="button" class="btn-admin-list" onclick="withdrawMember(${detail.m_no})">
                                    <c:choose>
                                        <c:when test="${isAdmin}">회원 삭제</c:when>
                                        <c:otherwise>회원 탈퇴</c:otherwise>
                                    </c:choose>
                                </button>     
                            </c:if>
                        </sec:authorize>
                    </div>
                </div>
            </div> <!-- info 끝 -->

            <!-- 3. 탭 콘텐츠 2: 주문 내역 -->
            <div id="order" class="tab-content">
                <table class="order-table">
                    <thead>
                        <tr>
                            <th width="10%">주문번호</th>
                            <th width="30%">상품명</th>
                            <th width="10%">받는분</th>
                            <th width="15%">결제금액</th>
                            <th width="20%">주문일자</th>
                            <th width="15%">상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orderList}">
                            <tr>
                                <td><span class="order-no">#${order.o_no}</span></td>
                                <td class="p-title-cell">
                                    <strong><c:out value="${order.p_title}" /></strong>
                                    <c:if test="${order.product_count > 1}">
                                        <span class="count-tag">외 ${order.product_count - 1}건</span>
                                    </c:if>
                                </td>
                                <td><c:out value="${order.o_name}" /></td>
                                <td class="price-cell"><fmt:formatNumber value="${order.o_total_price}" pattern="#,###"/>원</td>
                                <td><fmt:formatDate value="${order.o_date}" pattern="yyyy.MM.dd HH:mm"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.o_status == '결제완료'}">
                                            <span class="status-badge status-paid">${order.o_status}</span>
                                            <button class="btn-cancel" data-imp-uid="${order.imp_uid}" data-o-no="${order.o_no}" onclick="cancelOrder(this)">환불하기</button>
                                        </c:when>
                                        <c:otherwise><span class="status-badge status-refunded">${order.o_status}</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>            
                        <c:if test="${empty orderList}">
                            <tr><td colspan="6" class="no-data">📦 최근 주문하신 내역이 없습니다.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div> <!-- order 끝 -->

            <!-- 4. 비밀번호 확인 모달 -->
            <div id="pwModal" class="modal-overlay">
                <div class="modal-content">
                    <h3>비밀번호 확인</h3>
                    <p>보안을 위해 비밀번호를 다시 입력해주세요.</p>
                    <input type="password" id="confirmPw" placeholder="비밀번호 입력">
                    <div class="modal-buttons">
                        <button type="button" class="btn-lavender" onclick="validatePw()">확인</button>
                        <button type="button" class="btn-list-gray" onclick="closePwCheck()">취소</button>
                    </div>
                </div>
            </div>
        </div> 
    </main>

    <script>
        // 탭 전환 스크립트
        function changeTab(tabId, element) {
            // 모든 탭 콘텐츠 숨기기
            document.querySelectorAll('.tab-content').forEach(el => {
                el.classList.remove('active');
            });
            // 모든 탭 메뉴 비활성화
            document.querySelectorAll('.tab-item').forEach(el => {
                el.classList.remove('active');
            });
            // 선택된 탭 보이기
            document.getElementById(tabId).classList.add('active');
            element.classList.add('active');
        }
      
       
    </script>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>