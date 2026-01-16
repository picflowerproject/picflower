document.addEventListener('submit', function (e) {
    const f = e.target;
    if (!f.b_text) return;

    if (!f.p_no || !f.p_no.value) {
        alert("후기를 작성할 상품을 선택해주세요.");
        e.preventDefault();
        return;
    }

    if (!f.b_rating.value) {
        alert("별점을 선택해주세요.");
        e.preventDefault();
        return;
    }

    if (!f.b_upload_list || f.b_upload_list.files.length === 0) {
        alert("후기 사진을 등록해주세요.");
        e.preventDefault();
        return;
    }

    const txt = f.b_text.value.trim();
    if (!txt) {
        alert("후기 내용을 입력해주세요.");
        e.preventDefault();
        return;
    }

    if (txt.length > 50) {
        alert("후기 내용은 50자 이하로 작성해주세요.");
        e.preventDefault();
    }
});