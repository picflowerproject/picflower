document.addEventListener('submit', function (e) {
    const f = e.target;
    if (!f.p_title) return;

    if (f.p_title.value.trim() === "") {
        alert("상품 제목을 입력해주세요.");
        e.preventDefault();
        return;
    }

    if (f.p_pirce && (f.p_pirce.value === "" || isNaN(f.p_pirce.value))) {
        alert("상품 가격을 숫자로 입력해주세요.");
        e.preventDefault();
        return;
    }

    if (f.p_category && f.p_category.value === "") {
        alert("상품 카테고리를 선택해주세요.");
        e.preventDefault();
        return;
    }

    if (f.p_image && !f.p_image.value) {
        alert("상품 이미지를 등록해주세요.");
        e.preventDefault();
    }
});