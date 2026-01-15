<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원정보 수정</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/memberWrite.css">
<style>

</style>
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <main class="content-wrapper">
    <div class="content-container">
        <h2>회원정보 수정</h2>
        <form name="member" method="post" action="/member/memberUpdate">
            <!-- 회원 식별값 고정 -->
            <input type="hidden" name="m_no" value="${edit.m_no}">
            
            <table border="1">
                <tr>
                    <td>아이디</td>
                    <td class="readonly-text">${edit.m_id}</td>
                </tr>
                <tr>
                    <td>비밀번호</td>
                    <td>
                        <sec:authentication property="principal" var="principal" />
                        <c:set var="isSocial" value="${fn:contains(principal.getClass().name, 'OAuth2')}" />
                        
                        <c:choose>
                            <c:when test="${isSocial}">
                                <span class="social-notice">소셜 로그인 계정은 비밀번호를 변경할 수 없습니다.</span>
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="btn-addr" onclick="openPwUpdateModal()">비밀번호 변경</button>
                                <span id="pwStatus" style="color:blue; font-size:0.8em; margin-left:10px;"></span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <td>이름</td>
                    <td><input type="text" name="m_name" value="${edit.m_name}" required></td>
                </tr>
                <tr>
                    <td>성별</td>
                    <td>
                        <input type="radio" name="m_gender" value="남자" ${edit.m_gender=='남자'?'checked':''}>남자 
                        <input type="radio" name="m_gender" value="여자" ${edit.m_gender=='여자'?'checked':''}>여자
                    </td>
                </tr>
                <tr>
                    <td>생년월일</td>
                    <c:set var="onlyDate" value="${fn:replace(fn:substring(edit.m_birth, 0, 10), '-', '')}" />
                    <td><input type="text" name="m_birth" value="${onlyDate}" maxlength="8" placeholder="예: 19950101"></td>
                </tr>
                <tr>
                    <td>연락처</td>
                    <td>
                        <select name="m_tel1">
                            <option value="010" ${fn:startsWith(edit.m_tel,'010')?'selected':''}>010</option>
                            <option value="011" ${fn:startsWith(edit.m_tel,'011')?'selected':''}>011</option>
                        </select>-
                        <input type="text" name="m_tel2" size="2" maxlength="4" value="${edit.m_tel.substring(4,8)}">-
                        <input type="text" name="m_tel3" size="2" maxlength="4" value="${edit.m_tel.substring(9,13)}">
                    </td>
                </tr>
                <tr>
                    <td>주소</td>
                    <td>
                        <div class="addr-group">
                            <input type="text" name="m_zipcode" id="m_zipcode" value="${zipcode}" readonly placeholder="우편번호">
                            <button type="button" onclick="goPopup()" class="btn-addr">주소 검색</button>
                        </div>
                        <input type="text" name="m_addr_base" id="m_addr_base" value="${address}" readonly class="full-width" style="margin-bottom:5px;">
                        <input type="text" name="m_addr_detail" id="m_addr_detail" value="${addrDetail}" placeholder="상세 주소 입력" class="full-width">
                    </td>
                </tr>
                <tr>
                    <td>이메일</td>
                    <td>
                        <input type="text" name="m_email1" value="${edit.m_email.substring(0, edit.m_email.indexOf('@'))}">@
                        <select name="m_email2">
                            <option value="gmail.com" ${fn:contains(edit.m_email,'gmail.com')?'selected':''}>gmail.com</option>
                            <option value="naver.com" ${fn:contains(edit.m_email,'naver.com')?'selected':''}>naver.com</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>좋아하는 꽃</td>
                    <td><input type="text" name="m_flower" value="${edit.m_flower}" required></td>
                </tr>
                
                <sec:authorize access="!hasAuthority('ROLE_ADMIN')">
					<input type="hidden" name="m_auth" value="${edit.m_auth}">
				</sec:authorize>
                <sec:authorize access="hasAuthority('ROLE_ADMIN')">
                <tr>
                    <td>권한 설정</td>
                    <td>
                        <input type="radio" name="m_auth" value="ADMIN" ${edit.m_auth == 'ADMIN' ? 'checked' : ''}> 관리자 
                        <input type="radio" name="m_auth" value="MEMBER" ${edit.m_auth == 'MEMBER' ? 'checked' : ''}> 회원
                    </td>
                </tr>
                </sec:authorize>
            </table>

            <div class="button-group">
                <input type="submit" class="btn-submit" value="수정완료">
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