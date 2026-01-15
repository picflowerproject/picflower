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

// 각 게시글별 현재 슬라이드 위치 저장 객체
const slideIndexMap = {};

function moveSlider(b_no, step) {
    // 해당 게시글의 현재 인덱스 초기화
    if (slideIndexMap[b_no] === undefined) {
        slideIndexMap[b_no] = 0;
    }

    const track = document.getElementById(`track-${b_no}`);
    const slides = track.getElementsByClassName('slide');
    const totalSlides = slides.length;
    const dots = document.getElementById(`dots-${b_no}`).getElementsByClassName('dot');

    // 인덱스 계산
    slideIndexMap[b_no] += step;

    if (slideIndexMap[b_no] >= totalSlides) slideIndexMap[b_no] = 0;
    if (slideIndexMap[b_no] < 0) slideIndexMap[b_no] = totalSlides - 1;

    // 트랙 이동 (X축 평행 이동)
    track.style.transform = `translateX(-${slideIndexMap[b_no] * 100}%)`;

    // 인디케이터(점) 업데이트
    for (let dot of dots) {
        dot.classList.remove('active');
    }
    dots[slideIndexMap[b_no]].classList.add('active');
}

// 2. 좋아요 (AJAX)
function likeUp(b_no) {
	// 1. 로그인 여부 체크
	   if (!isLogin) {
	       // confirm 대신 토스트 메시지만 띄움
	       if (typeof showMessage === 'function') {
	           showMessage("로그인이 필요한 서비스입니다. 🔒");
	       } else {
	           alert("로그인이 필요한 서비스입니다.");
	       }
	       return; // 더 이상 진행하지 않고 종료
	   }

    const btn = event.currentTarget;

    $.ajax({
        url: contextPath + '/member/b_like',
        type: 'POST',
        data: { "b_no": b_no },
        success: function(res) {
            const parts = res.split(":");
            const type = parts[0];   
            const count = parts[1];  

            $("#like-count-" + b_no).text(count);

            if (type === "plus") {
                $(btn).addClass("active");
                $(btn).find(".flower-icon").text("❤️");
                // ✅ alert 대신 토스트 메시지 호출
                showMessage("좋아요를 눌렀습니다! ❤️"); 
            } else {
                $(btn).removeClass("active");
                $(btn).find(".flower-icon").text("🤍");
                // ✅ 취소 시에도 토스트 출력 가능 (선택 사항)
                showMessage("좋아요를 취소했습니다. 💔");
            }
        },
        error: function(xhr) {
            // ✅ 서버 오류 시에도 alert 대신 토스트 호출
            showMessage("서버 통신 중 오류가 발생했습니다. 😥");
        }
    });
}

// 3. 메뉴 토글 (게시글용)
function toggleMenu(b_no) {
    if (event) event.stopPropagation();
    
    const $target = $("#dropdown-" + b_no);
    $(".dropdown-menu").not($target).hide();
    
    // 부모의 배치 확인 (reverse 인지)
    const isReverse = $target.closest('.view-wrapper-reverse').length > 0;
    
    if (!$target.is(":visible")) {
        if (isReverse) {
            // 텍스트가 왼쪽이면 -> 오른쪽 허공으로
            $target.css({ "left": "105%", "right": "auto" });
        } else {
            // 텍스트가 오른쪽이면 -> 왼쪽 허공으로
            $target.css({ "right": "105%", "left": "auto" });
        }
    }
    
    $target.toggle();
}
// 4. 삭제 함수
function deleteReview(b_no) {
    if (confirm("정말로 이 후기를 삭제하시겠습니까?")) {
        // 수정 전: location.href = contextPath + "/b_delete?b_no=" + b_no;
        // 수정 후: 컨트롤러 경로에 맞춰 /member 추가
        location.href = contextPath + "/member/b_delete?b_no=" + b_no;
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
        url: contextPath + '/member/b_update', // 전역 변수 사용
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
// board.js 수정
function readURL(input, previewId) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            // previewId가 있으면 해당 ID를, 없으면 기본 'preview' ID를 사용
            const targetId = previewId ? previewId : 'preview';
            $('#' + targetId).attr('src', e.target.result).show();
        }
        reader.readAsDataURL(input.files[0]);
    }
}

function scrollReply(btn, direction) {
    // 1. 클릭한 버튼의 부모(.reply-section) 내에서 슬라이더를 찾습니다.
    const slider = btn.parentElement.querySelector('.reply-slider');
    
    if (!slider) return;

    // 2. 현재 화면에 보이는 슬라이더의 너비(한 페이지 분량)를 가져옵니다.
    const scrollAmount = slider.clientWidth; 
    
    // 3. scrollBy를 사용하여 부드럽게 이동시킵니다.
    slider.scrollBy({
        left: direction * scrollAmount,
        behavior: 'smooth'
    });
}

//수정용 미리보기 함수
function updatePreview(input, b_no) {
    // 1. 이미지가 들어갈 '컨테이너'를 찾습니다.
    const container = document.getElementById("edit-preview-container-" + b_no);
    
    if (!container) {
        console.error("미리보기 컨테이너를 찾을 수 없습니다: edit-preview-container-" + b_no);
        return;
    }

    // 2. 새로운 파일을 선택했으므로 기존 미리보기 이미지들을 비웁니다.
    container.innerHTML = "";

    if (input.files && input.files.length > 0) {
        // 3. 선택된 모든 파일을 순회하며 img 태그 생성
        Array.from(input.files).forEach(file => {
            const reader = new FileReader();
            
            reader.onload = function(e) {
                const img = document.createElement('img');
                img.src = e.target.result;
                // CSS에 설정한 가로 정렬 및 작은 크기 스타일 적용
                img.classList.add('edit-preview-img'); 
                container.appendChild(img);
            };
            
            reader.readAsDataURL(file);
        });
        console.log(b_no + "번 게시글의 다중 미리보기가 업데이트되었습니다.");
    }
}

function submitUpdate(b_no, btn) {
    // 1. 버튼에서 가장 가까운 form 요소를 직접 찾습니다.
    const formElement = btn.closest('form'); 

    if (!formElement) {
        console.error("폼 요소를 찾을 수 없습니다.");
        return;
    }

    // 2. FormData 생성 (Parameter 1 에러가 사라집니다)
    const formData = new FormData(formElement);

    // 3. 별점 값 추출 (현재 폼 내부에 있는 값만)
    const ratingInput = formElement.querySelector(`input[name="b_rating"]:checked`);
    const rating = ratingInput ? ratingInput.value : 0;
    
    // 추가 데이터 세팅
    formData.set("b_no", b_no);
    formData.set("b_rating", rating);

    $.ajax({
        url: '/member/b_update', // 서버 경로 확인
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function(res) {
            if(res.trim() === "success") {
                alert("수정되었습니다.");
                location.reload();
            } else {
                alert("수정 실패");
            }
        }
    });
}