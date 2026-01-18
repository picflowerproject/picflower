<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/memberwrite.css">
    <!-- 외부 CDN을 사용하여 MIME 타입 에러 및 로드 실패 방지 -->
    

</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
<script src="${pageContext.request.contextPath}/js/memberValidation.js"></script>
    <main class="content-wrapper">
        <div class="content-container">
            <h2>회원가입</h2>
           <form name="member" method="post" action="/guest/memberWrite" onsubmit="return validateForm()">
				<input type="hidden" name="m_auth" value="MEMBER">

                <table border="1">
                    <tr>
					    <td>아이디</td> 
					    <td>
						    <div class="id-group">
						        <!-- 1. 메시지가 위로 -->
						        <div id="id_msg" class="id-msg"></div>
						        <!-- 2. 입력창과 버튼이 아래로 (이 둘은 가로 배치) -->
						        <div class="id-input-area">
						            <input type="text" id="m_id" name="m_id" placeholder="아이디 입력(4자 이상)">
						            <button type="button" onclick="checkDuplicateId()" class="check-btn">중복확인</button>
						        </div>
						    </div>
						</td>
					</tr>
                    <tr>
                        <td>비밀번호</td>
                        <td><input type="password" name="m_pwd"></td>
                    </tr>
                    <tr>
                        <td>비밀번호 확인</td>
                        <td><input type="password" name="m_pwd2"></td>
                    </tr>
                    <tr>
                        <td>이름</td>
                        <td><input type="text" name="m_name"></td>
                    </tr>
                    <tr>
                        <td>성별</td>
                        <td>
                            <input type="radio" name="m_gender" value="남자" checked>남자 
                            <input type="radio" name="m_gender" value="여자">여자
                        </td>
                    </tr>
                    <tr>
                        <td>생일</td>
                        <td><input type="text" name="m_birth" maxlength="8" placeholder="8자리로 입력해 주세요(20260119)"></td>
                    </tr>
                    <tr>
                        <td>연락처</td>
                        <td>
                            <select name="m_tel1">
                                <option value="010">010</option>
                                <option value="011">011</option>
                                <option value="017">017</option>
                                <option value="019">019</option>
                            </select>-
                            <input type="text" name="m_tel2" size="2" maxlength="4">-
                            <input type="text" name="m_tel3" size="2" maxlength="4">
                        </td>
                    </tr>
                    <!-- 주소 입력 영역 -->
					<tr>
					    <td>주소</td>
					    <td>
					       <div class="addr-group">
							    <input type="text" name="m_zipcode" id="m_zipcode" placeholder="우편번호" readonly>
							    <button type="button" onclick="goPopup()" class="btn-addr">주소 검색</button>
							</div>
					        <input type="text" name="m_addr_base" id="m_addr_base" placeholder="기본 주소" readonly style="width:100%; margin-bottom:5px;">
					        <input type="text" name="m_addr_detail" id="m_addr_detail" placeholder="상세 주소 입력" style="width:100%;">
					    </td>
					</tr>
					<tr>
                        <td>이메일</td>
                        <td>
                            <input type="text" name="m_email1">@
                            <select name="m_email2">
                                <option value="gmail.com">gmail.com</option>
                                <option value="naver.com">naver.com</option>
                                <option value="apple.com">apple.com</option>
                                <option value="hanmail.net">hanmail.net</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>좋아하는 꽃</td>
                        <td><input type="text" name="m_flower"></td>
                    </tr>
                    
                </table>
                <div class="button-group">
                    <input type="submit" class="btn-submit" value="가입하기">
                </div>
            </form>
        </div>
</main>

<script type="text/javascript">
let isIdChecked = false; // 중복 확인 여부 상태 변수

function checkDuplicateId() {
    const idField = document.getElementById('m_id');
    const mid = idField.value.trim();
    const msg = document.getElementById('id_msg');

 // [추가] 빈 값일 때 중복 확인 중단
    if (mid === "") {
        alert("중복 확인을 하기 전에 아이디를 입력해주세요.");
        idField.focus();
        return;
    }
    
    console.log("검색 요청 아이디: [" + mid + "]");

    // [핵심 수정] URL 뒤에 타임스탬프 추가하여 캐시 방지
    fetch('/guest/idCheck?m_id=' + mid + '&t=' + new Date().getTime())
    .then(res => res.json())
    .then(count => {
            console.log("브라우저가 받은 결과값:", count);
            
            if (count == 0) { 
                msg.innerText = "사용 가능한 아이디입니다.";
                msg.style.color = "#A36CD9";
                idField.dataset.check = "ok";
                isIdChecked = true; 
            } else {
                msg.innerText = "이미 사용 중인 아이디입니다.";
                msg.style.color = "red";
                idField.dataset.check = "fail";
            }
        })
        .catch(err => console.error("API 호출 실패:", err));
}

//✅ 핵심 수정: 사용자가 한 글자라도 타이핑하면 즉시 상태와 메시지 초기화
document.getElementById('m_id').addEventListener('input', function() {
 const msg = document.getElementById('id_msg');
 
 // 이미 중복 확인을 통과했거나 에러 메시지가 떠 있는 상태에서 수정을 시작하면
 if (isIdChecked || msg.innerText !== "") {
     isIdChecked = false;
     this.dataset.check = "fail";
     msg.innerText = "아이디가 변경되었습니다. 중복 확인을 눌러주세요.";
     msg.style.color = "orange"; // 경고 의미의 주황색
 }
});


function goPopup(){
    // 팝업 파일의 경로를 프로젝트 구조에 맞게 수정하세요 (예: /guest/jusoPopup)
    var pop = window.open("${pageContext.request.contextPath}/guest/jusoPopup", "pop", "width=570,height=420, scrollbars=yes, resizable=yes"); 
}

// 팝업에서 호출할 콜백 함수 (변수 순서 유지 필수)
function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo){
    document.getElementById('m_zipcode').value = zipNo;
    document.getElementById('m_addr_base').value = roadAddrPart1 + " " + roadAddrPart2;
    document.getElementById('m_addr_detail').value = addrDetail;
    document.getElementById('m_addr_detail').focus(); // 상세주소로 포커스 이동
}
</script>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>