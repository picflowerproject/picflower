document.addEventListener('submit', function (e) {
    const f = e.target;
    if (!f.m_pwd) return;

    const pwd = f.m_pwd.value.trim();
    const pwd2 = f.m_pwd2?.value.trim();

    // 비밀번호 입력된 경우만 검사 (수정 화면 고려)
    if (pwd !== "") {
        const reg = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,20}$/;

        if (!reg.test(pwd)) {
            alert("비밀번호는 8~20자이며 대소문자, 숫자, 특수문자를 포함해야 합니다.");
            e.preventDefault();
            return;
        }

        if (pwd2 !== undefined && pwd !== pwd2) {
            alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
            e.preventDefault();
            return;
        }
    }

    if (f.m_birth && !/^\d{8}$/.test(f.m_birth.value)) {
        alert("생년월일은 숫자 8자리로 입력해주세요.");
        e.preventDefault();
        return;
    }

    if (f.m_tel2 && !/^\d{4}$/.test(f.m_tel2.value)) {
        alert("연락처 중간자리는 4자리 숫자입니다.");
        e.preventDefault();
        return;
    }

    if (f.m_tel3 && !/^\d{4}$/.test(f.m_tel3.value)) {
        alert("연락처 마지막 자리는 4자리 숫자입니다.");
        e.preventDefault();
        return;
    }

    if (f.m_flower && f.m_flower.value.trim() === "") {
        alert("좋아하는 꽃을 입력해주세요.");
        e.preventDefault();
    }
});