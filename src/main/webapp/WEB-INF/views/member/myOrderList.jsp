<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 주문 내역</title>
<link rel="stylesheet" type="text/css" href="${path}/css/myOrderList.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
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
        	console.log("Server Response:", response);
            if (response === 'success') {
                alert('주문 취소 완료');
                location.reload(); // 화면 새로고침
            } else if (response === 'fail') {
                alert('주문 취소 실패');
            } else {
                alert('서버 에러 발생');
            }
        },
        error: function(xhr, status, error) {
            console.error('AJAX Error:', error, xhr.responseText);
            alert('서버와 통신 중 오류 발생');
        }
    });
}
</script>
</head>
<body>
<header>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
</header>
<main class="container">
    <h2>My Order List</h2>
    <table class="order-table">
        <thead>
            <tr>
                <th>주문번호</th>
				<th>상품명</th>
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
                    <td colspan="6" class="no-data">
                        <div style="font-size: 40px; margin-bottom: 10px;">📦</div>
                        최근 주문하신 내역이 없습니다.
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>
</main>
<footer>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>
</html>