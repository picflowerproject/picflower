<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/footer.css">

<style>
/* 1:1 문의 플로팅 버튼 (노란색) */
.qna-float-btn {
    position: fixed;
    bottom: 30px; right: 30px; /* 맨 아래 위치 */
    width: 60px; height: 60px;
    background-color: #FEE500; color: #3A1D1D;
    border-radius: 50%;
    display: flex; justify-content: center; align-items: center;
    box-shadow: 2px 5px 15px rgba(0,0,0,0.2);
    cursor: pointer; z-index: 9999;
    transition: transform 0.3s ease;
}
.qna-float-btn:hover { transform: scale(1.1); }
.qna-float-btn svg { width: 30px; height: 30px; fill: #3A1D1D; }

/* 1:1 문의 채팅창 */
.qna-chat-box {
    display: none;
    position: fixed; bottom: 100px; right: 30px;
    width: 320px; height: 450px;
    background-color: #b2c7da;
    border-radius: 15px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.3);
    z-index: 10000; /* AI 채팅보다 위에 뜨도록 설정 */
    flex-direction: column;
    font-family: 'Malgun Gothic', sans-serif;
    text-align: left;
}
.qna-header {
    background-color: #b2c7da; color: #3A1D1D;
    padding: 15px; font-weight: bold;
    display: flex; justify-content: space-between; align-items: center;
    border-bottom: 1px solid rgba(0,0,0,0.1);
}
.qna-body {
    flex: 1; padding: 15px; overflow-y: auto;
    display: flex; flex-direction: column; gap: 10px;
}
.msg-system {
    background-color: white; padding: 8px 12px;
    border-radius: 4px; font-size: 13px; align-self: flex-start;
    max-width: 80%; box-shadow: 0 1px 2px rgba(0,0,0,0.1); color: #333;
}
.msg-my {
    background-color: #FEE500; padding: 8px 12px;
    border-radius: 4px; font-size: 13px; align-self: flex-end;
    max-width: 80%; box-shadow: 0 1px 2px rgba(0,0,0,0.1); color: #3A1D1D;
}
.qna-footer {
    padding: 10px; background-color: white; display: flex;
}
.qna-input {
    flex: 1; border: 1px solid #ddd; border-radius: 4px; padding: 8px;
    outline: none; background-color: #f8f8f8;
}
.qna-send-btn {
    margin-left: 8px; background-color: #FEE500; color: #3A1D1D;
    border: none; padding: 8px 12px; border-radius: 4px; font-weight: bold; cursor: pointer;
}

/* AI 챗봇 아이콘 위치 조정 (Q&A 버튼 위로 배치) */
#chat-icon {
    position: fixed; 
    bottom: 100px; /* Q&A 버튼(30px) + 간격 */
    right: 30px;   /* 우측 정렬 맞춤 */
    cursor: pointer; 
    z-index: 999;
}
</style>

<div class="content-wrapper"></div>
<hr>

<footer>
    <div class="footer-container">
        <div class="footer-left">
            <div class="brand-logo">
                <a href="/"><img src="/assets/picflowerLogo.jpg" alt="Logo"></a>
            </div>
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
 
        <div class="footer-right">
            <nav class="footer-nav">
                <a href="/guest/notice">공지사항</a>
                <a href="/guest/index">회사소개</a>
                <a href="/guest/termsOfUse">이용약관</a>
                <a href="/guest/servicePolicy">개인정보처리방침</a>
            </nav>

            <div class="business-info">
                <p>
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
</footer>

<div id="chat-icon" onclick="toggleChat()">
    <div style="width:60px; height:60px; background:#ffc1cc; border-radius:30px; display:flex; align-items:center; justify-content:center; box-shadow:0 4px 10px rgba(0,0,0,0.2); font-size:30px;">🌸</div>
</div>

<div id="chat-window" style="display:none; position:fixed; bottom:170px; right:30px; width:330px; height:450px; background:white; border:1px solid #ddd; border-radius:15px; box-shadow:0 5px 15px rgba(0,0,0,0.2); z-index:1000; flex-direction:column;">
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
// --- AI Chat Logic ---
function toggleChat() {
    const win = document.getElementById('chat-window');
    // Q&A 창이 열려있으면 닫기 (겹침 방지)
    const qnaBox = document.getElementById('qnaBox');
    if(qnaBox && qnaBox.style.display === 'flex') toggleQna();

    win.style.display = (win.style.display === 'none' || win.style.display === '') ? 'flex' : 'none';
}

function sendChatMessage() {
    const input = document.getElementById('chat-input');
    const content = document.getElementById('chat-content');
    const msg = input.value.trim();
    
    if(!msg) return;

    // 사용자 메시지 UI 추가
    const userDiv = document.createElement('div');
    userDiv.style.cssText = "align-self:flex-end; background:#ffeff2; padding:10px; border-radius:10px; max-width:80%; margin-bottom:5px;";
    userDiv.innerText = msg;
    content.appendChild(userDiv);
    
    input.value = "";
    content.scrollTop = content.scrollHeight;

    // API 통신
    fetch("/api/chat/send", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ message: msg })
    })
    .then(response => response.text())
    .then(data => {
        const aiDiv = document.createElement('div');
        aiDiv.style.cssText = "align-self:flex-start; background:#f1f1f1; padding:10px; border-radius:10px; max-width:80%; margin-bottom:5px;";
        aiDiv.innerText = "🌸 " + data;
        content.appendChild(aiDiv);
        content.scrollTop = content.scrollHeight;
    })
    .catch(error => console.error("Error:", error));
}

document.getElementById('chat-input').addEventListener('keypress', function(e) {
    if(e.key === 'Enter') sendChatMessage();
});
</script>


<div class="qna-float-btn" onclick="toggleQna()">
    <svg viewBox="0 0 24 24">
        <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/>
    </svg>
</div>

<div class="qna-chat-box" id="qnaBox">
    <div class="qna-header">
        <span>1:1 문의하기</span>
        <span style="cursor:pointer;" onclick="toggleQna()">✖</span>
    </div>

    <div class="qna-body" id="chatBody">
        <div class="msg-system">
            안녕하세요! 🌸<br>문의 내용을 남겨주시면<br>관리자가 확인 후 답변드립니다.
        </div>
    </div>

    <div class="qna-footer">
        <input type="text" class="qna-input" id="qnaInput" placeholder="질문 입력..." onkeypress="if(event.key==='Enter') sendMsg()">
        <button class="qna-send-btn" onclick="sendMsg()">전송</button>
    </div>
</div>

<script>
// --- Q&A Logic ---
let pollTimer = null;
let lastLoginBlocked = false;

function toggleQna() {
    const box = document.getElementById("qnaBox");
    if (!box) return;

    // AI 채팅창이 열려있으면 닫기 (겹침 방지)
    const aiWin = document.getElementById('chat-window');
    if(aiWin && aiWin.style.display === 'flex') toggleChat();

    const cur = window.getComputedStyle(box).display;
    const open = (cur === "none");

    box.style.display = open ? "flex" : "none";
    if (open) {
        lastLoginBlocked = false;
        loadMyQna();
        startPolling();
    } else {
        stopPolling();
    }
}

function startPolling() {
    stopPolling();
    pollTimer = setInterval(loadMyQna, 3000);
}

function stopPolling() {
    if (pollTimer) clearInterval(pollTimer);
    pollTimer = null;
}

async function loadMyQna() {
    try {
        const resp = await fetch("/qna/my", { method: "GET" });
        if (resp.status === 401 || resp.status === 403) {
            if (!lastLoginBlocked) {
                lastLoginBlocked = true;
                renderSystemOnly("로그인 후 문의/답변 확인이 가능합니다. (로그인이 필요합니다)");
            }
            stopPolling();
            return;
        }

        if (!resp.ok) return;
        const list = await resp.json();
        renderChat(list);
    } catch (e) {}
}

function renderSystemOnly(message) {
    const chatBody = document.getElementById("chatBody");
    if (!chatBody) return;
    chatBody.innerHTML =
        '<div class="msg-system">안녕하세요! 🌸<br>문의 내용을 남겨주시면<br>관리자가 확인 후 답변드립니다.</div>' +
        '<div class="msg-system">' + escapeHtml(message) + '</div>';
    chatBody.scrollTop = chatBody.scrollHeight;
}

function renderChat(list) {
    const chatBody = document.getElementById("chatBody");
    if (!chatBody) return;
    chatBody.innerHTML =
        '<div class="msg-system">안녕하세요! 🌸<br>문의 내용을 남겨주시면<br>관리자가 확인 후 답변드립니다.</div>';
    if (!list || list.length === 0) {
        chatBody.innerHTML += '<div class="msg-system">아직 문의 내역이 없습니다.</div>';
        chatBody.scrollTop = chatBody.scrollHeight;
        return;
    }

    const ordered = list.slice().reverse();
    for (const q of ordered) {
        chatBody.innerHTML += '<div class="msg-my">' + escapeHtml(q.q_content || "") + '</div>';
        if (q.q_answer && String(q.q_answer).trim() !== "") {
            chatBody.innerHTML += '<div class="msg-system">' + escapeHtml(q.q_answer) + '</div>';
        } else {
            chatBody.innerHTML += '<div class="msg-system">답변 대기중입니다.</div>';
        }
    }
    chatBody.scrollTop = chatBody.scrollHeight;
}

async function sendMsg() {
    const input = document.getElementById("qnaInput");
    if (!input) return;

    const msg = input.value.trim();
    if (msg === "") return;

    try {
        const body = new URLSearchParams();
        body.append("msg", msg);

        const resp = await fetch("/qna/send", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" },
            body: body.toString()
        });
        const text = await resp.text();

        if (text === "SUCCESS") {
            input.value = "";
            setTimeout(loadMyQna, 200);
        } else if (text === "FAIL" || text.includes("로그인")) { // 로그인 체크 강화
            alert("로그인이 필요한 서비스입니다.");
            location.href = "/guest/loginForm";
        }
    } catch (e) {
        alert("로그인이 필요한 서비스입니다.");
    }
}

function escapeHtml(str) {
    return String(str)
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#039;");
}
</script>