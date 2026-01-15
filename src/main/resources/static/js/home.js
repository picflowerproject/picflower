document.addEventListener("DOMContentLoaded", () => {
    const wrapper = document.querySelector(".slide-wrapper");
    const container = document.querySelector(".main-slide");
    const slides = document.querySelectorAll(".slide");
    const totalSlides = slides.length;
    let currentIndex = 0;
    const duration = 800; // CSS 애니메이션 시간 (0.8s)
    const intervalTime = 5000; // 슬라이드 전환 간격 (5s)

    function moveSlide() {
        currentIndex++;
        
        // 1. 이동 애니메이션 시작
        const slideWidth = container.clientWidth;
        wrapper.style.transition = `transform ${duration}ms cubic-bezier(0.4, 0, 0.2, 1)`;
        wrapper.style.transform = `translateX(-${currentIndex * slideWidth}px)`;

        // 2. 마지막 슬라이드(복사본)에 도달했을 때 처리
        if (currentIndex === totalSlides - 1) {
            // 애니메이션이 끝나는 시점에 맞추어 실행
            setTimeout(() => {
                // 트랜지션을 끄고 첫 번째 위치로 몰래 복귀
                wrapper.style.transition = "none";
                currentIndex = 0;
                wrapper.style.transform = `translateX(0)`;
            }, duration); 
        }
    }

    // 5초마다 실행
    let slideTimer = setInterval(moveSlide, intervalTime);

    // [옵션] 브라우저 창 크기가 변할 때 슬라이드 위치를 재보정 (반응형 대응)
    window.addEventListener('resize', () => {
        wrapper.style.transition = "none";
        const slideWidth = container.clientWidth;
        wrapper.style.transform = `translateX(-${currentIndex * slideWidth}px)`;
    });
});

window.addEventListener("load", () => {
    // 애니메이션을 적용할 요소들 선택
    const storyIntro = document.querySelector('.story-intro');
    const featureItems = document.querySelectorAll('.feature-item');
    const storyFooter = document.querySelector('.story-footer');

    // Intersection Observer 설정 (화면에 10% 이상 보일 때 실행)
    const observerOptions = {
        threshold: 0.1
    };

    const storyObserver = new IntersectionObserver((entries) => {
        entries.forEach((entry) => {
            if (entry.isIntersecting) {
                // 화면에 보이면 'visible' 클래스 추가
                entry.target.classList.add('visible');
            }
        });
    }, observerOptions);

    // 관찰 대상 등록
    if(storyIntro) storyObserver.observe(storyIntro);
    featureItems.forEach(item => storyObserver.observe(item));
    if(storyFooter) storyObserver.observe(storyFooter);
});