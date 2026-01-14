<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원정보 수정</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/MemberUpdate.css">
<style>
/* 비밀번호 변경 팝업 */
.modal-overlay {
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0,0,0,0.5);
    display: none; /* ← 이 부분이 제대로 되어 있는지 확인 */
    align-items: center;
    justify-content: center;
    z-index: 9999;
}

.modal-content {
    background-color: white;
    padding: 40px;
    border-radius: 15px; /* 모서리 둥글게 */
    width: 350px;
    text-align: center;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3); /* 그림자 효과 */
}

/* 팝업 내 입력창 */
.modal-content input {
    width: 100%;
    padding: 12px;
    margin-bottom: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
    box-sizing: border-box; /* 패딩 포함 너비 계산 */
}

/* 팝업 내 버튼 그룹 */
.modal-buttons {
    display: flex;
    justify-content: center;
    gap: 10px;
    margin-top: 15px;
}

/* 팝업 버튼 기본 스타일 */
.modal-buttons button {
    padding: 10px 25px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-weight: bold;
}
</style>
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <main class="content-wrapper">
        <div class="content-container">
            <h2>회원정보 수정</h2>
            <form name="member" method="post" action="/member/memberUpdate">
                <table border="1">
                    <tr>
                        <td>회원번호</td>
                        <td>${edit.m_no}<input type="hidden" name="m_no" value="${edit.m_no}"></td>
                    </tr>
                    <tr>
                        <td>아이디</td>
                        <td>${edit.m_id}</td>
                    </tr>
		            <tr>
					    <td>비밀번호</td>
					    <td>
					        <button type="button" class="btn-addr" onclick="openPwUpdateModal()">비밀번호 변경</button>
					        <span id="pwStatus" style="color:blue; font-size:0.8em; margin-left:10px;"></span>
					    </td>
					</tr>
                    <tr>
                        <td>이름</td>
                        <td><input type="text" name="m_name" value="${edit.m_name}" required></td>
                    </tr>
                    <tr>
                        <td>성별</td>
                        <td>
                            <input type="radio" name="m_gender" value="남자" <c:if test="${edit.m_gender=='남자'}">checked</c:if>>남자
                            <input type="radio" name="m_gender" value="여자" <c:if test="${edit.m_gender=='여자'}">checked</c:if>>여자
                        </td>
                    </tr>
                    <tr>
                        <td>생년월일</td>
                        <c:set var="onlyDate" value="${fn:replace(fn:substring(edit.m_birth, 0, 10), '-', '')}" />
                        <td><input type="text" name="m_birth" value="${onlyDate}" maxlength="8"></td>
                    </tr>
                    <tr>
                        <td>연락처</td>
                        <td>
                            <select name="m_tel1">
                                <option value="010" <c:if test="${fn:startsWith(edit.m_tel,'010')}">selected</c:if>>010</option>
                                <option value="011" <c:if test="${fn:startsWith(edit.m_tel,'011')}">selected</c:if>>011</option>
                            </select>-
                            <input type="text" name="m_tel2" size="4" value="${edit.m_tel.substring(4,8)}">-
                            <input type="text" name="m_tel3" size="4" value="${edit.m_tel.substring(9,13)}">
                        </td>
                    </tr>
				    <tr>
                        <td>이메일</td>
                        <td>
                            <input type="text" name="m_email1" value="${edit.m_email.substring(0, edit.m_email.indexOf('@'))}">@
                            <select name="m_email2">
                                <option value="gmail.com" ${edit.m_email.indexOf('gmail.com')>-1?'selected':''}>gmail.com</option>
                                <option value="naver.com" ${edit.m_email.indexOf('naver.com')>-1?'selected':''}>naver.com</option>
                            </select>
                        </td>
                    
                    </tr> 
                    <tr>
                        <td>좋아하는 꽃</td>
                   		<td><input type="text" name="m_flower" value="${edit.m_flower}" required></td>
                   	</tr>
                     <tr>
					    <th>주소</th>
					    <td class="address-cell">
					        <div class="zip-group">
					            <!-- 컨트롤러의 model.addAttribute("zipcode", ...) 값을 사용 -->
					            <input type="text" name="m_zipcode" id="m_zipcode" value="${zipcode}" readonly>
					            <button type="button" onclick="goPopup()" class="btn-addr">주소 검색</button>
					        </div>
					        <!-- 컨트롤러의 model.addAttribute("address", ...) 값을 사용 -->
					        <input type="text" name="m_addr_base" id="m_addr_base" value="${address}" class="full-width" readonly>
					        
					       		 <!-- 컨트롤러의 model.addAttribute("addrDetail", ...) 값을 사용 -->
					      	  <input type="text" name="m_addr_detail" id="m_addr_detail" value="${addrDetail}" placeholder="상세 주소 입력" class="full-width">
						    </td>
						</tr>
						
						<!-- 수정된 권한 처리 영역 -->
						<!-- 1. 모든 사용자에게 공통: 관리자가 아닐 때를 대비해 기본 hidden 필드를 둡니다. 
						     관리자일 경우 아래 radio 버튼의 값으로 덮어씌워집니다. -->
						<sec:authorize access="!hasAuthority('ROLE_ADMIN')">
						    <input type="hidden" name="m_auth" value="${edit.m_auth}">
						</sec:authorize>

						<!-- 2. 관리자(ADMIN)일 때만 라디오 버튼 노출 -->
						<sec:authorize access="hasAuthority('ROLE_ADMIN')">
						    <tr>
						        <td>권한</td>
						        <td>
									<input type="radio" name="m_auth" value="ADMIN" ${edit.m_auth == 'ADMIN' ? 'checked' : ''}> 관리자 
						            <input type="radio" name="m_auth" value="MEMBER" ${edit.m_auth == 'MEMBER' ? 'checked' : ''}> 회원
						        </td>
						    </tr>
						</sec:authorize>
			</table>

                <div class="button-group">
                    <input type="submit" class="btn-submit" value="수정완료">
                    <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                </div>
            </form>
        </div>
    </main>
	
	
    <!-- 비밀번호 변경 모달 (body 하단 추가) -->
					<div id="pwUpdateModal" class="modal-overlay" style="display:none;">
					    <div class="modal-content">
					        <h3>비밀번호 변경</h3>
					        <input type="password" id="new_m_pwd" placeholder="새 비밀번호 입력">
					        <input type="password" id="new_m_pwd_check" placeholder="새 비밀번호 확인">
					        <div class="modal-buttons">
					            <button type="button" onclick="updatePassword()">변경</button>
					            <button type="button" onclick="closePwUpdateModal()">취소</button>
					        </div>
					    </div>
					</div>
   <script>
   /*주소검색*/
    function goPopup(){
        window.open("${pageContext.request.contextPath}/guest/jusoPopup", "pop", "width=570,height=420, scrollbars=yes, resizable=yes"); 
    }
    function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo){
        document.getElementById('m_zipcode').value = zipNo;
        document.getElementById('m_addr_base').value = roadAddrPart1 + (roadAddrPart2 ? " " + roadAddrPart2 : "");
        document.getElementById('m_addr_detail').value = addrDetail;
    }
    
    /*비밀번호변경*/
    function openPwUpdateModal() {
    	document.getElementById('pwUpdateModal').style.display = 'flex';
	}
		
	function closePwUpdateModal() {
		 document.getElementById('pwUpdateModal').style.display = 'none';
	}
		
	function updatePassword() {
		 const pw = document.getElementById('new_m_pwd').value;
		 const pwCheck = document.getElementById('new_m_pwd_check').value;
		
		 if(!pw) { alert("새 비밀번호를 입력하세요."); return; }
		 if(pw !== pwCheck) { alert("비밀번호가 일치하지 않습니다."); return; }
		
		 // AJAX로 비밀번호만 즉시 수정
		 fetch('/member/updatePwOnly', {
		     method: 'POST',
		     headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
		     body: 'm_pwd=' + encodeURIComponent(pw) + '&m_no=${edit.m_no}'
		 })
		   .then(response => response.json())
		   .then(data => {
		if(data.success) {
		    alert("비밀번호가 변경되었습니다.");
		    document.getElementById('pwStatus').innerText = "✔ 변경완료";
		    closePwUpdateModal();
			  }
		});
	}
    </script>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>