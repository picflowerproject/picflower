function submitReview() {
    const f = document.reviewForm;
    
    // 1. 상품 선택 체크
    const p_no_val = document.getElementById('selected_p_no').value;
    if(!p_no_val) {
        alert("후기를 작성할 상품을 먼저 선택해주세요!");
        openProductModal();
        return false;
    }
    
    // 2. 별점 선택 여부 체크 (CSS 가림 현상 완벽 대응)
    // 폼(f) 안에서 b_rating 이름의 라디오 버튼 중 체크된 것이 있는지 확인
    const ratingValue = f.querySelector('input[name="b_rating"]:checked')?.value;
    
    console.log("선택된 별점 값:", ratingValue); // 디버깅용

    if (!ratingValue) {
        alert("상품에 대한 별점을 선택해주세요!");
        return false;
    }

    // 3. 사진 파일 체크
    const fileInput = document.getElementById('b_upload_insert');
    if (!fileInput.files || fileInput.files.length === 0) {
        alert("최소 1장의 사진을 업로드해주세요!");
        return false;
    }

    // 4. 내용 입력 및 글자 수 체크
    const contentVal = f.b_text.value.trim();
    if(!contentVal) {
        alert("내용을 입력해주세요!");
        f.b_text.focus();
        return false;
    }
    
    if(contentVal.length < 5) {
        alert("내용은 최소 5자 이상 작성해주세요.");
        f.b_text.focus();
        return false;
    }

    // 5. 최종 전송
    if(confirm("작성하신 후기를 등록하시겠습니까?")) {
        f.submit(); 
    }
}