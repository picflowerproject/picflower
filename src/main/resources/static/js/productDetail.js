function openTab(evt, tabName) {
    var i, tabcontent, tablinks;

    // 모든 탭 내용 숨기기
    tabcontent = document.getElementsByClassName("tab-content");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }

    // 모든 버튼의 active 클래스 제거
    tablinks = document.getElementsByClassName("tab-btn");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }

    // 클릭한 탭 보여주기 및 버튼 활성화
    document.getElementById(tabName).style.display = "block";
    evt.currentTarget.className += " active";
}