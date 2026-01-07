// 1. 리뷰 전송 (Form Submit)
function submitReview() {
    const rating = document.querySelector('input[name="b_rating"]:checked');
    const content = document.getElementById('content').value;

    if (!rating || content.trim() === "") {
        alert("평점과 내용을 모두 입력해주세요!");
        return;
    }

    document.getElementById('reviewForm').submit();
}

// 2. 좋아요 (AJAX)
function likeUp(b_no) {
    $.ajax({
        url: contextPath + '/b_like', // 전역 변수 사용
        type: 'POST',
        data: { "b_no": b_no },
        dataType: 'text',
        success: function(newCount) {
            $("#like-count-" + b_no).text(newCount.trim());
        },
        error: function(xhr, status, error) {
            alert("좋아요 처리 중 오류가 발생했습니다.");
        }
    });
}

// 3. 메뉴 토글
function toggleMenu(b_no) {
    $(".dropdown-menu").not("#dropdown-" + b_no).hide();
    $("#dropdown-" + b_no).toggle();
}

// 화면 빈 곳 클릭 시 메뉴 닫기
$(document).on("click", function(event) {
    if (!$(event.target).closest(".menu-container").length) {
        $(".dropdown-menu").hide();
    }
});

// 4. 삭제 함수
function deleteReview(b_no) {
    if (confirm("정말로 이 후기를 삭제하시겠습니까?")) {
        // JSP 문법이 아닌 변수 조합으로 경로 설정
        location.href = contextPath + "/b_delete?b_no=" + b_no;
    }
}

// 5. 수정 폼 제어
function showEditForm(b_no) {
    $(".dropdown-menu").hide();
    $("#view-mode-" + b_no).hide();
    $("#edit-mode-" + b_no).show();
}

function cancelEdit(b_no) {
    $("#view-mode-" + b_no).show();
    $("#edit-mode-" + b_no).hide();
}

// 6. 수정 완료 처리 (AJAX)
function updateReview(b_no) {
    const newText = $("#edit-text-" + b_no).val();
    if (newText.trim() === "") {
        alert("내용을 입력해주세요.");
        return;
    }

    $.ajax({
        url: contextPath + '/b_update', // 전역 변수 사용
        type: 'POST',
        data: { "b_no": b_no, "b_text": newText },
        success: function(res) {
            if (res.trim() === "success") {
                $("#text-p-" + b_no).text(newText);
                cancelEdit(b_no);
            } else {
                alert("수정에 실패했습니다.");
            }
        },
        error: function(xhr, status, error) {
            alert("수정 중 서버 오류가 발생했습니다.");
        }
    });
}

// 7. 이미지 미리보기
function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            $('#preview').attr('src', e.target.result);
            $('#preview').show();
        }
        reader.readAsDataURL(input.files[0]);
    } else {
        $('#preview').attr('src', '#');
        $('#preview').hide();
    }
}   