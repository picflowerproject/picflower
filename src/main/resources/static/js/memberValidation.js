/**
 * 회원가입 유효성 검사
 */
function validateForm() {
    const form = document.member;
    const mid = document.getElementById('m_id').value.trim();
    const mpwd = form.m_pwd.value;
    const mpwd2 = form.m_pwd2.value;
    // 변수 추가: mbirth 정의
    const mbirth = form.m_birth.value.trim();

    // 1. 아이디 검사
    if (mid === "") {
        alert("아이디를 입력해주세요.");
        document.getElementById('m_id').focus();
        return false;
    }

    if (!isIdChecked) {
        alert("아이디 중복 확인 버튼을 눌러주세요.");
        document.getElementById('m_id').focus();
        return false;
    }

    // 2. 비밀번호 유효성 검사
    const pwdRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}$/;

    if (mpwd === "") {
        alert("비밀번호를 입력해주세요.");
        form.m_pwd.focus();
        return false;
    }

    if (!pwdRegex.test(mpwd)) {
        alert("비밀번호는 영어 대/소문자, 숫자, 특수문자를 모두 포함하여 8~20자로 입력해주세요.");
        form.m_pwd.focus();
        return false;
    }
    
    // 비밀번호 확인 칸 빈칸 검사 추가
    if (mpwd2 === "") {
        alert("비밀번호 확인을 입력해주세요.");
        form.m_pwd2.focus();
        return false;
    }

    if (mpwd !== mpwd2) {
        alert("비밀번호가 일치하지 않습니다. 재입력 해주세요.");
        form.m_pwd2.focus();
        return false;
    }

    // 3. 이름 검사
    if (form.m_name.value.trim() === "") {
        alert("이름을 입력해주세요.");
        form.m_name.focus();
        return false;
    }

    // 4. 생년월일 검사 (8자리 숫자)
    const birthRegex = /^[0-9]{8}$/; 
    if (mbirth === "") {
        alert("생년월일을 입력해주세요.");
        form.m_birth.focus();
        return false;
    }
    if (!birthRegex.test(mbirth)) {
        alert("생년월일은 숫자 8자리로 입력해주세요. (예: 19950101)");
        form.m_birth.focus();
        return false;
    }
    
    // 5. 연락처(전화번호) 빈 칸 검사 추가
    if (form.m_tel2.value.trim() === "" || form.m_tel3.value.trim() === "") {
        alert("연락처를 모두 입력해주세요.");
        form.m_tel2.focus();
        return false;
    }

    // 6. 주소 검사
    if (form.m_zipcode.value === "") {
        alert("주소 검색 버튼을 눌러 주소를 입력해주세요.");
        goPopup(); 
        return false;
    }

    // 7. 이메일 검사
    if (form.m_email1.value.trim() === "") {
        alert("이메일을 입력해주세요.");
        form.m_email1.focus();
        return false;
    }

    return true; 
}