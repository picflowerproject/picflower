function addReply(b_no) {
	const inputId = "#reply-input-" + b_no;
    const text = $(inputId).val(); // 입력창 ID와 동일한값
    
    //디버깅용
    console.log("입력창 ID:", inputId);
    console.log("입력된 값:", text);

	    if (!text.trim()) {
	
	    	alert("내용을 입력하세요.");
	        return;
	    }
	
	    $.ajax({
	    	url: contextPath + "/r_insert", // 컨트롤러의 @PostMapping 주소와 일치!
	        type: "POST",
	        data: {
	            b_no: b_no,      // ReplyDTO의 b_no 필드와 매핑
	            r_text: text     // ReplyDTO의 r_text 필드와 매핑
	        },
			success: function(res) {
			    if (res.trim() === "success") {
			        // 즉시 새로고침하여 DB에서 생성된 r_no와 함께 메뉴 버튼을 출력함
			        location.reload(); 
			    } else {
			        alert("등록 실패");
			    }
			}
	    });
	}
	
	
	
function toggleReplyMenu(event, r_no) {
    // 1. 클릭 이벤트가 document.on("click")으로 퍼지는 것을 막음 (즉시 닫힘 방지)
    event.stopPropagation();

    // 2. 다른 모든 드롭다운 메뉴 일단 닫기
    const targetId = "#reply-dropdown-" + r_no;
    $(".dropdown-menu").not(targetId).hide();

    // 3. 현재 클릭한 메뉴만 토글
    const dropdown = $(targetId);
    
    // 강제로 스타일 변경 시도
    if (dropdown.is(":visible")) {
        dropdown.attr("style", "display: none !important;");
    } else {
        dropdown.attr("style", "display: block !important; position: absolute; right: 0; top: 30px; background: white; border: 1px solid #ccc; z-index: 9999; min-width: 80px; box-shadow: 0 2px 10px rgba(0,0,0,0.2);");
    }
}


//댓글 삭제 (Ajax)
function deleteReply(r_no, b_no) {
    if(!confirm("댓글을 삭제하시겠습니까?")) return;

    $.ajax({
        url: contextPath + "/r_delete",
        type: "POST",
        data: { r_no: r_no },
        success: function(res) {
            if(res.trim() === "success") {
                $("#reply-item-" + r_no).remove(); // 화면에서 즉시 삭제
            }
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
    
    $.ajax({
        url: contextPath + "/r_update",
        type: "POST",
        data: { r_no: r_no, r_text: newText },
        success: function(res) {
            if(res.trim() === "success") {
                $("#reply-text-content-" + r_no).text(newText); // 텍스트 변경
                cancelReplyEdit(r_no); // 다시 보기 모드로
            }
        }
    });
}