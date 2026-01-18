$(document).ready(function() {
    // 댓글 입력창 클릭(focus) 시 로그인 체크
    // [id^="reply-input-"] 는 'reply-input-'으로 시작하는 모든 ID를 의미합니다.
    $(document).on('focus', '[id^="reply-input-"]', function() {
        if (!isLogin) {
            // 1. 입력을 못 하게 포커스를 뺏음
            $(this).blur(); 
            
            // 2. 토스트 메시지 출력
            if (typeof showMessage === 'function') {
                showMessage("로그인이 필요한 서비스입니다. 🔒");
            }
            
            // 3. (선택사항) 입력창 값을 비움
            $(this).val('');
        }
    });
});

function addReply(b_no) {
    const inputId = "#reply-input-" + b_no;
    const text = $(inputId).val();
    
	if (!isLogin) {
	       showMessage("로그인이 필요한 서비스입니다. 🔒");
	       return;
	   }
	
    if (!text.trim()) {
        showMessage("내용을 입력해 주세요. 🌸");
        return;
    }

    $.ajax({
        url: contextPath + "/member/r_insert",
        type: "POST",
        data: { b_no: b_no, r_text: text },
        success: function(res) {
			console.log("새로 생성된 댓글 번호:", res.r_no); // 이제 0이 아닌 실제 시퀀스 번호가 찍힙니다!
            // 서버에서 객체(r_no, m_id, r_text 등)를 응답받음
            if (res != null && res.r_no !== undefined) {
                $(inputId).val(''); 

                // HTML 생성 시작
                const newReplyHtml = `
                    <div class="reply-item" id="reply-item-${res.r_no}">
                        <div class="reply-menu-container">
                            <!-- ✅ [수정] reply.r_no를 res.r_no로 변경 / ID와 함수명도 일치시킴 -->
                            <button type="button" class="menu-dot-btn" id="reply-dot-${res.r_no}" onclick="showInlineMenu(${res.r_no})">⋮</button>
                            
                            <!-- ✅ [수정] 인라인 메뉴 그룹 구조로 통일 -->
                            <div class="inline-menu-group" id="inline-menu-${res.r_no}" style="display:none;">
                                <button type="button" class="inline-btn edit" onclick="showReplyEditForm(${res.r_no})">수정</button>
                                <button type="button" class="inline-btn delete" onclick="deleteReply(${res.r_no}, ${b_no})">삭제</button>
                                <button type="button" class="inline-btn cancel" onclick="hideInlineMenu(${res.r_no})">취소</button>
                            </div>
                        </div>
                        
                        <div id="reply-view-${res.r_no}">
                            <div class="reply-main">
                                <div class="reply-meta">
                                    ❣️ <span class="author-id">${res.m_id}</span>
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

                $("#reply-list-" + b_no).prepend(newReplyHtml);
                
                // 댓글 개수 업데이트
                const $countElement = $("#reply-count-" + b_no);
                if ($countElement.length > 0) {
                    let currentCount = parseInt($countElement.text().replace(/[^0-9]/g, "")) || 0;
                    $countElement.text(currentCount + 1);
                }

                // 스크롤 이동
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
	
// 인라인 메뉴 표시
function showInlineMenu(r_no) {
    // 다른 열려있는 인라인 메뉴가 있다면 닫기 (선택 사항)
    $('.inline-menu-group').hide();
    $('.menu-dot-btn').show();

    // 선택한 메뉴 전환
    $(`#reply-dot-${r_no}`).hide();
    $(`#inline-menu-${r_no}`).css('display', 'flex');
}

// 인라인 메뉴 숨기기 (취소)
function hideInlineMenu(r_no) {
    $(`#inline-menu-${r_no}`).hide();
    $(`#reply-dot-${r_no}`).show();
}

// 수정 폼 진입 시 메뉴도 자동으로 숨기기 위해 기존 함수 보완
function showReplyEditForm(r_no) {
    hideInlineMenu(r_no); // 메뉴 글자 숨기기
    $(`#reply-view-${r_no}`).hide();
    $(`#reply-edit-mode-${r_no}`).show();
    $(`#reply-edit-input-${r_no}`).focus();
}


// 메뉴 바깥 클릭 시 닫기 (이 기능이 없으면 fixed 메뉴가 화면에 계속 남음)
$(document).on('click', function() {
    $(".dropdown-menu").hide();
});

// 스크롤 시 fixed 메뉴 위치 어긋남 방지를 위해 닫기 처리
$(".reply-section").on('scroll', function() {
    $(".dropdown-menu").hide();
});

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

function showReplyEditForm(r_no) {
    // 1. 해당 댓글의 메뉴 버튼 영역(점 3개 포함) 전체 숨기기
    $(`#reply-item-${r_no} .reply-menu-container`).hide();
    
    // 2. 기존 댓글 내용 영역 숨기기
    $(`#reply-view-${r_no}`).hide();
    
    // 3. 수정 입력창 보여주기
    $(`#reply-edit-mode-${r_no}`).show();
    $(`#reply-edit-input-${r_no}`).focus();
}

// 수정 취소 또는 수정 완료 후 다시 원상복구 하는 함수
function hideReplyEditForm(r_no) {
    // 1. 수정창 숨기고 기존 내용 보여주기
    $(`#reply-edit-mode-${r_no}`).hide();
    $(`#reply-view-${r_no}`).show();
    
    // 2. 메뉴 버튼 영역(점 3개) 다시 보여주기
    $(`#reply-item-${r_no} .reply-menu-container`).show();
    // 3. 인라인 메뉴가 열려있었다면 초기화(점만 보이게)
    hideInlineMenu(r_no); 
}
// 수정 취소 기능도 필요하다면 추가 (또는 updateReply 완료 후 호출)
function hideReplyEditForm(r_no) {
    $(`#reply-edit-mode-${r_no}`).hide();
    $(`#reply-view-${r_no}`).show();
    $(`#reply-dot-${r_no}`).show(); // 점 버튼 다시 보이기
}
//댓글 수정 취소
function cancelReplyEdit(r_no) {
    $("#reply-edit-mode-" + r_no).hide();
    $("#reply-view-" + r_no).show();
}

//댓글 수정 완료 (Ajax)
function updateReply(r_no) {
    const newText = $(`#reply-edit-input-${r_no}`).val();
    
    if (!newText.trim()) {
        showMessage("수정할 내용을 입력해 주세요. 🌸");
        return;
    }

    $.ajax({
        url: contextPath + "/member/r_update", 
        type: "POST",
        // replyDTO 필드명(r_no, r_text)과 100% 일치함 확인됨
        data: { 
            r_no: r_no, 
            r_text: newText 
        },
        success: function(response) {
            // response가 null이 아니고 trim했을 때 success인지 확인
            if(response && response.trim() === "success") {
                $(`#reply-text-content-${r_no}`).text(newText);
                
                $(`#reply-edit-mode-${r_no}`).hide();
                $(`#reply-view-${r_no}`).show();
                $(`#reply-item-${r_no} .reply-menu-container`).show();
                
                hideInlineMenu(r_no);
                showMessage("댓글이 수정되었습니다. ✨");
            } else {
                console.warn("수정 실패 서버 응답:", response);
                showMessage("수정에 실패했습니다.");
            }
        },
        error: function(xhr) {
            console.error("에러 상태:", xhr.status);
            showMessage("서버 통신 오류가 발생했습니다.");
        }
    });
}


function showMessage(msg) {
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.innerText = msg;
    container.appendChild(toast);

    setTimeout(() => toast.classList.add('show'), 10);
    setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 400);
    }, 3000);
}
