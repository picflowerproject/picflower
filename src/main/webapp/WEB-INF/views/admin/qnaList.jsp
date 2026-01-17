<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 1:1 문의 관리</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
    /* 1. 전체 컨테이너 및 폰트 설정 */
    .admin-container {
        width: 85%;
        margin: 50px auto;
        font-family: 'Malgun Gothic', sans-serif;
    }

    h2 { border-bottom: 2px solid #333; padding-bottom: 10px; margin-bottom: 20px; }

    /* 2. 테이블 기본 스타일 */
    .qna-table {
        width: 100%;
        border-collapse: collapse;
        table-layout: fixed;
        margin: 0 auto;
    }
    .qna-table th { background: #f8f9fa; padding: 12px; border-bottom: 2px solid #ddd; color: #555; }
    .qna-table td { padding: 15px 12px; border-bottom: 1px solid #eee; text-align: center; color: #333; vertical-align: middle; }

    .status-badge { padding: 5px 10px; border-radius: 15px; font-size: 12px; font-weight: bold; }
    .st-0 { background: #ffeeba; color: #856404; }
    .st-1 { background: #d4edda; color: #155724; }

    /* ▼▼▼ 답변 행 스타일 (중앙 정렬 유지) ▼▼▼ */
    .reply-row { display: none; background-color: #fcfcfc; }
    .reply-row td { padding: 0 !important; border-bottom: 1px solid #ddd; }
    .reply-wrapper {
        width: 100%; display: flex; justify-content: center; align-items: center;
        padding: 30px 0; box-sizing: border-box;
    }
    .reply-box {
        width: 850px; display: flex; gap: 15px; background: #ffffff;
        padding: 25px; border: 1px solid #ced4da; border-radius: 12px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.08); margin: 0 auto;
    }
    .reply-input {
        flex: 1; padding: 15px; border: 1px solid #ddd; border-radius: 6px;
        resize: none; height: 100px; font-family: inherit; font-size: 14px;
    }

    /* 버튼 스타일 */
    .btn-save { background: #8b6fe8; color: white; border: none; padding: 0 30px; cursor: pointer; border-radius: 6px; font-weight: bold; }

    .btn-toggle {
        background: white; border: 1px solid #ccc; padding: 6px 12px; cursor: pointer;
        border-radius: 4px; font-size: 12px; margin-right: 8px;
    }
    .btn-toggle:hover { background: #f1f1f1; }

    /* ✅ 추가: 답변 버튼을 수정/삭제랑 같은 모양(색 없음)으로 */
    .btn-answer{
        background:#fff;
        color:#333;
        border:1px solid #cfcfcf;
        padding:8px 16px;
        border-radius:6px;
        font-size:13px;
        font-weight:400;
        cursor:pointer;
        margin-right:8px;
    }
    .btn-answer:hover{ background:#f5f5f5; }

    /* ✅ 요청한 스타일: 보라색 "수정" 버튼 */
    .btn-edit {
        background: #8b6fe8;
        color: #fff;
        border: 1px solid #8b6fe8;
        padding: 8px 16px;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 400;
        cursor: pointer;
        margin-right: 8px;
    }
    .btn-edit:hover { filter: brightness(0.95); }

    /* ✅ 요청한 스타일: 빨간 테두리 "삭제" 버튼 */
    .btn-delete2 {
        background: #fff;
        color: #ff3b30;
        border: 1px solid #ff3b30;
        padding: 8px 16px;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 400;
        cursor: pointer;
    }
    .btn-delete2:hover { background: rgba(255, 59, 48, 0.06); }

</style>
</head>
<body>

    <jsp:include page="../common/header.jsp" />

    <div class="admin-container">
        <h2>💬 1:1 문의 관리</h2>

        <table class="qna-table">
            <thead>
                <tr>
                    <th width="60">No</th>
                    <th width="100">상태</th>
                    <th width="120">작성자</th>
                    <th>문의 내용</th>
                    <th width="150">작성일</th>
                    <th width="160">관리</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty list}">
                        <tr><td colspan="6" style="padding:80px;">등록된 문의가 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="dto" items="${list}">
                            <tr>
                                <td>${dto.q_no}</td>
                                <td>
                                    <c:if test="${dto.q_status == '0'}"><span class="status-badge st-0">답변대기</span></c:if>
                                    <c:if test="${dto.q_status == '1'}"><span class="status-badge st-1">답변완료</span></c:if>
                                </td>
                                <td>${dto.m_id}</td>
                                <td style="text-align:left;">
                                    <div style="margin-bottom:5px;">${dto.q_content}</div>
                                    <c:if test="${dto.q_status == '1'}">
                                        <div style="background:#eef2f7; padding:10px; border-radius:5px; font-size:13px; color:#555;">
                                            <b style="color:#222;">관리자 답변:</b> ${dto.q_answer}
                                        </div>
                                    </c:if>
                                </td>
                                <td>${dto.q_date}</td>

                                <td>
                                    <c:if test="${dto.q_status == '0'}">
                                        <!-- ✅ 변경: btn-toggle → btn-answer (모양만 통일, 색 없음) -->
                                        <button class="btn-answer" type="button" onclick="toggleReply(${dto.q_no})">답변</button>
                                    </c:if>

                                    <c:if test="${dto.q_status == '1'}">
                                        <button class="btn-edit" type="button" onclick="toggleReply(${dto.q_no})">수정</button>
                                    </c:if>

                                    <button class="btn-delete2" type="button" onclick="deleteQna(${dto.q_no})">삭제</button>
                                </td>
                            </tr>

                            <tr id="replyRow-${dto.q_no}" class="reply-row">
                                <td colspan="6">
                                    <div class="reply-wrapper">
                                        <div class="reply-box">
                                            <textarea id="answer-${dto.q_no}" class="reply-input" placeholder="답변 내용을 입력하세요.">${dto.q_answer}</textarea>
                                            <button class="btn-save" type="button" onclick="saveAnswer(${dto.q_no})">저장</button>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <jsp:include page="../common/footer.jsp" />

    <script>
        // 답변창 토글 (display: table-row 유지)
        function toggleReply(no) {
            $(".reply-row").not("#replyRow-" + no).hide();

            var row = $("#replyRow-" + no);
            if (row.css("display") === "none") {
                row.css("display", "table-row");
            } else {
                row.hide();
            }
        }

        // 답변 저장
        function saveAnswer(no) {
            var content = $("#answer-" + no).val().trim();
            if(content === "") { alert("내용을 입력해주세요."); return; }

            $.ajax({
                type: "POST",
                url: "${pageContext.request.contextPath}/admin/qna/reply",
                data: { q_no: no, answer: content },
                success: function(resp) {
                    if(resp === "SUCCESS") {
                        alert("답변이 등록되었습니다.");
                        location.reload();
                    } else {
                        alert("등록 실패");
                    }
                },
                error: function() { alert("에러 발생"); }
            });
        }

        // 문의 삭제
        function deleteQna(no) {
            if(!confirm(no + "번 문의를 정말로 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.")) {
                return;
            }

            $.ajax({
                type: "POST",
                url: "${pageContext.request.contextPath}/admin/qna/delete",
                data: { q_no: no },
                success: function(resp) {
                    if(resp === "SUCCESS") {
                        alert("성공적으로 삭제되었습니다.");
                        location.reload();
                    } else {
                        alert("삭제에 실패했습니다.");
                    }
                },
                error: function() { alert("삭제 요청 중 에러가 발생했습니다."); }
            });
        }
    </script>
</body>
</html>
