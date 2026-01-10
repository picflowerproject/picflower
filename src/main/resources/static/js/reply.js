function addReply(b_no) {
    const inputId = "#reply-input-" + b_no;
    const text = $(inputId).val();
    
    if (!text.trim()) {
        showMessage("내용을 입력해 주세요. 🌸");
        return;
    }

    $.ajax({
        url: contextPath + "/member/r_insert",
        type: "POST",
        data: { b_no: b_no, r_text: text },
        success: function(res) {
            // 서버에서 VO 객체(r_no, m_id, r_text 포함)를 응답한다고 가정
            if (res != null && res.r_no !== undefined) {
                $(inputId).val(''); // 입력창 비우기

                // 1. 새 댓글 HTML 생성 (기존 리스트와 구조 통일)
                const newReplyHtml = `
                    <div class="reply-item" id="reply-item-${res.r_no}">
                        <div class="reply-menu-container">
                            <button type="button" class="menu-btn" onclick="toggleReplyMenu(event, ${res.r_no})">⋮</button>
                            <div id="reply-dropdown-${res.r_no}" class="dropdown-menu">
                                <button type="button" onclick="showReplyEditForm(${res.r_no})">수정</button>
                                <button type="button" onclick="deleteReply(${res.r_no}, ${b_no})">삭제</button>
                            </div>
                        </div>
                        <div id="reply-view-${res.r_no}">
                            <div class="reply-main">
                                <div class="reply-meta">
                                    🌸 <span class="author-id">${res.m_id}</span>
                                    <small>방금 전</small>
                                </div>
                                <span class="reply-content" id="reply-text-content-${res.r_no}">${res.r_text}</span> 
                            </div>
                        </div>
                        <div id="reply-edit-mode-${res.r_no}" class="reply-edit-mode" style="display:none;">
                            <input type="text" id="reply-edit-input-${res.r_no}" class="reply-edit-input" value="${res.r_text}">
                            <button type="button" onclick="updateReply(${res.r_no})">확인</button>
                        </div>
                    </div>`;

                // 2. 목록 상단에 추가
                $("#reply-list-" + b_no).prepend(newReplyHtml);
                
                // 3. [핵심] 댓글 개수 실시간 업데이트
                const $countElement = $("#reply-count-" + b_no);
                if ($countElement.length > 0) {
                    // text()에서 숫자만 추출하여 계산 (공백 방지)
                    let currentCount = parseInt($countElement.text().replace(/[^0-9]/g, "")) || 0;
                    $countElement.text(currentCount + 1);
                }

                // 4. 스크롤을 맨 위로 이동
                const $replySection = $("#reply-list-" + b_no).closest('.reply-section');
                $replySection.animate({ scrollTop: 0 }, 400);

                showMessage("댓글이 등록되었습니다! ✨");
            } else {
                showMessage("등록에 실패했습니다.");
            }
        },
        error: function() {
            showMessage("로그인 후 이용 가능합니다.");
        }
    });
}
	
	
function toggleReplyMenu(event, r_no) {
    event.stopPropagation();

    const targetId = "#reply-dropdown-" + r_no;
    const dropdown = $(targetId);

    // 다른 메뉴 닫기
    $(".dropdown-menu").not(targetId).hide();

    if (dropdown.is(":visible")) {
        dropdown.hide();
    } else {
        // [수정] 옆으로 튀어나오게 스타일 설정
        dropdown.attr("style", `
            display: block !important; 
            position: absolute; 
            right: 110%;         /* 버튼의 왼쪽 옆으로 배치 */
            top: 0;              /* 버튼과 높이 맞춤 */
            background: white; 
            border: 1px solid var(--border-color); 
            z-index: 10000;      /* 최상단 */
            min-width: 80px; 
            box-shadow: -4px 4px 10px rgba(0,0,0,0.1); 
            border-radius: 4px;
        `);
    }
}

// 댓글 삭제 (Ajax)
function deleteReply(r_no, b_no) {
    if(!confirm("댓글을 삭제하시겠습니까?")) return;

    $.ajax({
        url: contextPath + "/member/r_delete",
        type: "POST",
        data: { r_no: r_no },
        success: function(res) {
            if(res.trim() === "success") {
                // 1. 화면에서 해당 댓글 엘리먼트 즉시 삭제
                $("#reply-item-" + r_no).remove(); 
                
                // 2. [추가] 댓글 개수 실시간 업데이트
                const countSpan = $("#reply-count-" + b_no); // 위에서 만든 ID 선택
                const currentCount = parseInt(countSpan.text()); // 현재 숫자 가져오기
                if (currentCount > 0) {
                    countSpan.text(currentCount - 1); // 1 감소시킨 값 넣기
                }

                showMessage("댓글이 삭제되었습니다. 🗑️");
            } else {
                showMessage("삭제에 실패했습니다.");
            }
        },
        error: function() {
            showMessage("서버 오류로 인해 삭제하지 못했습니다.");
        }
    });
}

//댓글 수정 폼 전환
function showReplyEditForm(r_no) {
    $("#reply-dropdown-" + r_no).hide();
    $("#reply-view-" + r_no).hide();
    $("#reply-edit-mode-" + r_no).show();
}

//댓글 수정 취소
function cancelReplyEdit(r_no) {
    $("#reply-edit-mode-" + r_no).hide();
    $("#reply-view-" + r_no).show();
}

//댓글 수정 완료 (Ajax)
function updateReply(r_no) {
    const newText = $("#reply-edit-input-" + r_no).val();
    
    if (!newText.trim()) {
        showMessage("수정할 내용을 입력해주세요! 🌸");
        return;
    }

    $.ajax({
        url: contextPath + "/member/r_update",
        type: "POST",
        data: { r_no: r_no, r_text: newText },
        success: function(res) {
            if(res.trim() === "success") {
                // JSP 구조에 맞춰 수정된 텍스트 반영
                $("#reply-text-content-" + r_no).text(newText);
                cancelReplyEdit(r_no);
                showMessage("댓글이 수정되었습니다. ✨");
            } else {
                showMessage("수정에 실패했습니다. 다시 시도해주세요.");
            }
        },
        error: function() {
            showMessage("서버 통신 오류가 발생했습니다.");
        }
    });
}


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