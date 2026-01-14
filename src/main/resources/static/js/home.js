document.addEventListener('DOMContentLoaded', () => {
    const wrapper = document.querySelector('.slide-wrapper');
    const slides = document.querySelectorAll('.slide');
    const totalOriginalSlides = slides.length - 1; // 5개
    let currentIndex = 0;
    let isMoving = false;

    function nextSlide() {
        if (isMoving) return;
        isMoving = true;
        currentIndex++;

        wrapper.style.transition = 'transform 0.5s ease-in-out';
        wrapper.style.transform = `translateX(-${currentIndex * 100}%)`;

        // 마지막 복제본(6번째)에 도착했을 때
        if (currentIndex === totalOriginalSlides) {
            setTimeout(() => {
                wrapper.style.transition = 'none'; // 애니메이션 끄고
                currentIndex = 0; // 진짜 1번으로 워프
                wrapper.style.transform = `translateX(0%)`;
                isMoving = false;
            }, 500);
        } else {
            setTimeout(() => { isMoving = false; }, 500);
        }
    }

    // 3초마다 이동
    setInterval(nextSlide, 5000);
});