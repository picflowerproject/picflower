/**
 * 공지사항 리스트 및 수정 제어 스크립트 (2026)
 */

// 페이지 로드 완료 시 실행
document.addEventListener('DOMContentLoaded', function() {
    // 1. URL 해시(#notice_123)가 있다면 해당 게시글 자동 열기
    const hash = window.location.hash;
    if (hash && hash.startsWith('#notice_')) {
        const targetId = hash.substring(1); // 'notice_번호' 추출
        const targetDetail = document.getElementById(targetId);
        
        if (targetDetail && targetDetail.tagName === 'DETAILS') {
            targetDetail.setAttribute('open', ''); // 게시글 펼치기
            
            // 해당 위치로 부드럽게 스크롤 이동
            setTimeout(() => {
                targetDetail.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }, 100);
        }
    }
});

// 1. 공지사항 삭제 함수
function n_delete(n_no) {
    if(confirm("정말 이 공지사항을 삭제하시겠습니까?")) {
        // 기존: location.href = contextPath + "/n_delete?n_no=" + n_no;
        // 수정: /admin 경로를 추가
        location.href = contextPath + "/admin/n_delete?n_no=" + n_no;
    }
}

// 2. 파일 선택 시 미리보기 업데이트
function readURL(input, previewId) {
    const preview = document.getElementById(previewId);
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function (e) {
            preview.src = e.target.result;
            preview.classList.remove('hidden'); // hidden 클래스 제거
            preview.style.display = 'block';
        }
        reader.readAsDataURL(input.files[0]);
    }
}

// 3. 보기 모드 <-> 수정 모드 전환
function toggleEdit(n_no, isEdit) {
    const viewArea = document.getElementById('view_area_' + n_no);
    const editArea = document.getElementById('edit_area_' + n_no);
    
    if (!viewArea || !editArea) {
        console.error("엘리먼트를 찾을 수 없습니다: " + n_no);
        return;
    }

    if (isEdit) {
        viewArea.style.display = 'none';
        editArea.style.display = 'block';
    } else {
        // 취소 시 수정 중이던 미리보기를 원래대로 돌리거나 폼 리셋 로직을 넣을 수 있음
        viewArea.style.display = 'block';
        editArea.style.display = 'none';
    }
}