function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        
        reader.onload = function (e) {
            var preview = document.getElementById('preview');
            preview.src = e.target.result;
            preview.style.display = 'block'; // 이미지 선택 시 보이기
        }
        
        reader.readAsDataURL(input.files[0]);
    }
}

function resetPreview() {
    var preview = document.getElementById('preview');
    preview.src = "#";
    preview.style.display = 'none'; // 초기화 시 숨기기
}
