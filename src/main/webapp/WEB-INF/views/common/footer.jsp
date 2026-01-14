<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/footer.css">
<script>
function showMessage(msg) {
	// 1. 컨테이너가 없으면 생성
	let container = document.getElementById('toast-container');
	if (!container) {
		container = document.createElement('div');
		container.id = 'toast-container';
		document.body.appendChild(container);
	}

	// 2. 새로운 토스트 생성
	const toast = document.createElement('div');
	toast.className = 'toast';
	toast.innerText = msg;
	container.appendChild(toast);

	// 3. 살짝 시간차를 두고 등장 애니메이션
	setTimeout(() => toast.classList.add('show'), 10);

	// 4. 3초 후 사라지고 제거
	setTimeout(() => {
	toast.classList.remove('show');
	setTimeout(() => toast.remove(), 400);
	}, 3000);
}
</script>

</head>
<body>
 <!-- 1. 본문 영역: 이 태그가 핵심입니다. 내용이 없어도 남는 공간을 다 차지합니다. -->
    <div class="content-wrapper">
        <!-- 
             여기에 실제 페이지 내용(게시판 리스트, 상품 상세 등)이 들어갑니다.
             내용이 한 줄도 없어도 푸터는 바닥에 고정됩니다.
        -->
    </div>
<hr> <!-- 본문과 구분하기 위한 선 -->
<footer>
    <div class="footer-container">
        <!-- 왼쪽 영역: 로고 및 CS -->
        <div class="footer-left">
            <div class="brand-logo">
		            <a href="/"><img src="/assets/picflowerLogo.jpg" alt="Logo" ></a></div>
            <p class="slogan">당신의 소중한 순간에 꽃을 더하다.</p>
            <div class="cs-info">
                <span class="cs-title">고객센터</span>
                <strong class="cs-number">02-1234-5678</strong>
                <p class="cs-detail">
                    평일 10:00 - 18:00 (점심 12:00 - 13:00)<br>
                    주말 및 공휴일 휴무
                </p>
                <div class="social-links">
                    <a href="#">Instagram</a> <a href="#">Blog</a> <a href="#">Kakao</a>
                </div>
            </div>
        </div>

        <!-- 오른쪽 영역: 메뉴(위) + 비즈니스 정보(아래) -->
        <div class="footer-right">
            <!-- 우측 상단: 메뉴 -->
            <nav class="footer-nav">
                <a href="/guest/notice">공지사항</a>
                <a href="/guest/about">회사소개</a>
                <a href="/guest/terms">이용약관</a>
                <a href="/guest/privacy" class="priority">개인정보처리방침</a>
                <a href="/guest/customerCenter">고객센터</a>
            </nav>

            <!-- 우측 하단: 비즈니스 정보 -->
            <div class="business-info">
			    <p>
			        <!-- 각 정보 블록을 <span>으로 묶음 -->
			        <span class="info-item"><strong>Picflower (픽플라워)</strong></span> | 
			        <span class="info-item">대표: 이민나</span> | 
			        <span class="info-item">사업자번호: 123-45-67890</span> <br>
			        <span class="info-item">주소: 서울특별시 어딘가 꽃길 123</span> | 
			        <span class="info-item">통신판매업신고: 제 2026-서울강남-0000호</span><br>
			        <span class="info-item">이메일: support@picflower.com</span> | 
			        <span class="info-item">개인정보관리책임자: 이민나</span>
			    </p>
			    
			    <div class="copyright">
			        &copy; 2026 Picflower. All Rights Reserved.
			    </div>
			</div>
        </div>
    </div>
	
	<div id="chat-icon" onclick="toggleChat()" style="position:fixed; bottom:20px; right:20px; cursor:pointer; z-index:999;">
	    <div style="width:60px; height:60px; background:#ffc1cc; border-radius:30px; display:flex; align-items:center; justify-content:center; box-shadow:0 4px 10px rgba(0,0,0,0.2); font-size:30px;">🌸</div>
	</div>

	<div id="chat-window" style="display:none; position:fixed; bottom:90px; right:20px; width:330px; height:450px; background:white; border:1px solid #ddd; border-radius:15px; box-shadow:0 5px 15px rgba(0,0,0,0.2); z-index:1000; flex-direction:column;">
	    <div style="background:#ffc1cc; color:white; padding:15px; border-radius:15px 15px 0 0; font-weight:bold; display:flex; justify-content:space-between;">
	        <span>Picflower AI 플로리스트</span>
	        <span onclick="toggleChat()" style="cursor:pointer;">&times;</span>
	    </div>
	    <div id="chat-content" style="flex:1; overflow-y:auto; padding:15px; font-size:14px; display:flex; flex-direction:column; gap:10px;">
	        <div style="background:#f1f1f1; padding:10px; border-radius:10px; align-self:flex-start; max-width:80%;">안녕하세요! 어떤 꽃을 찾으시나요?</div>
	    </div>
	    <div style="padding:15px; border-top:1px solid #ddd; display:flex; gap:5px;">
	        <input type="text" id="chat-input" style="flex:1; border:1px solid #ddd; border-radius:5px; padding:8px;" placeholder="메시지를 입력하세요...">
	        <button onclick="sendChatMessage()" style="background:#ffc1cc; border:none; color:white; padding:8px 15px; border-radius:5px; cursor:pointer;">전송</button>
	    </div>
	</div>

	<script>
	// 1. 창 열기/닫기
	function toggleChat() {
	    const win = document.getElementById('chat-window');
	    win.style.display = (win.style.display === 'none' || win.style.display === '') ? 'flex' : 'none';
	}

	// 2. 메시지 전송
	function sendChatMessage() {
	    const input = document.getElementById('chat-input');
	    const content = document.getElementById('chat-content');
	    const msg = input.value.trim();
	    
	    if(!msg) return;

	    // 사용자 메시지 추가
	    const userDiv = document.createElement('div');
	    userDiv.style.cssText = "align-self:flex-end; background:#ffeff2; padding:10px; border-radius:10px; max-width:80%; margin-bottom:5px;";
	    userDiv.innerText = msg;
	    content.appendChild(userDiv);
	    
	    input.value = "";
	    content.scrollTop = content.scrollHeight;

	    // 3. fetch API를 이용한 비동기 통신 (jQuery의 $.ajax 역할)
	    fetch("/api/chat/send", {
	        method: "POST",
	        headers: { "Content-Type": "application/json" },
	        body: JSON.stringify({ message: msg })
	    })
	    .then(response => response.text()) // 컨트롤러에서 String으로 반환하므로 .text()
	    .then(data => {
	        const aiDiv = document.createElement('div');
	        aiDiv.style.cssText = "align-self:flex-start; background:#f1f1f1; padding:10px; border-radius:10px; max-width:80%; margin-bottom:5px;";
	        aiDiv.innerText = "🌸 " + data;
	        content.appendChild(aiDiv);
	        content.scrollTop = content.scrollHeight;
	    })
	    .catch(error => {
	        console.error("Error:", error);
	    });
	}

	// 4. 엔터키 이벤트
	document.getElementById('chat-input').addEventListener('keypress', function(e) {
	    if(e.key === 'Enter') sendChatMessage();
	});
	</script>
</footer>
</body>
</html>