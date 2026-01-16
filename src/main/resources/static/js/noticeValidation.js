document.addEventListener('submit', function (e) {
    const f = e.target;

    if (!f.n_title) return;
    if (f.n_title.value.trim() === "") {
        alert("공지 제목을 입력해주세요.");
        e.preventDefault();
        f.n_title.focus();
        return;
    }

    // 2️⃣ 공지 내용
    if (f.n_text && f.n_text.value.trim() === "") {
        alert("공지 내용을 입력해주세요.");
        e.preventDefault();
        f.n_text.focus();
    }
});