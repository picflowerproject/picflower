
function moveSlide(step) {
    const wrapper = document.getElementById('sliderWrapper');
    const slides = document.querySelectorAll('.slide');
    const contentSlides = document.querySelectorAll('.content-slide'); 
    const totalSlides = slides.length;

    if (totalSlides === 0) return;

    // 1. 인덱스 계산
    currentIndex += step;

    if (currentIndex >= totalSlides) {
        currentIndex = 0;
    } else if (currentIndex < 0) {
        currentIndex = totalSlides - 1;
    }

    // 2. 이미지 이동 (Transform 방식)
    if (wrapper) {
        const translateValue = -currentIndex * 100;
        wrapper.style.transform = `translateX(${translateValue}%)`;
    }

    // 3. 텍스트 변경 (에러 방지 로직 적용)
    contentSlides.forEach((content, index) => {
        // [수정 포인트] content가 존재하는지 먼저 확인
        if (content) { 
            content.classList.remove('active');
            if (index === currentIndex) {
                content.classList.add('active');
            }
        }
    });
}