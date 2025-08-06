<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>글 상세 페이지</title>
</head>
<body>
    <h2>글 상세 페이지</h2>
    <p><strong>제목:</strong> ${board.title}</p>
    <p><strong>작성자:</strong> ${board.authorNickName}</p>
    <p><strong>조회수:</strong>${board.hits}</p>
    <img src="/file/preview?fileId=${board.fileId}"  width="100"/>

    <p><strong>내용:</strong></p>
    <p>${board.content}</p>

    <h3>댓글</h3>
    <c:forEach var="comment" items="${commentList}">
        <div class="comment-block"
            style="margin-left: ${comment.depth * 20}px; cursor: pointer;"
            onclick="toggleCommentOptions(${comment.id}, ${comment.depth})">

            <strong>${comment.authorNickName}</strong>
            <small><fmt:formatDate value="${comment.createdAt}" pattern="yyyy-MM-dd HH:mm"/></small><br>

            <c:choose>
                <c:when test="${comment.status == 0}">
                    <em style="color:gray;">[삭제된 댓글입니다]</em>
                </c:when>
                <c:otherwise>
                    <span>${comment.content}</span>
                </c:otherwise>
            </c:choose>

            <!-- 댓글 옵션 영역 (숨김) -->
            <div id="comment-options-${comment.id}" class="comment-options" style="display: none;">
                <c:if test="${comment.author == sessionScope.userId && comment.status == 1}">
                    <!-- 삭제 버튼 -->
                    <form action="/groupboardcomment/delete" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="${comment.id}"/>
                        <input type="hidden" name="boardId" value="${board.id}"/>
                        <input type="submit" value="삭제"/>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </form>

                    <!-- 수정 버튼 -->
                    <button type="button" onclick="event.stopPropagation(); toggleEditForm(${comment.id})">수정</button>
                    <!-- 수정 폼 (숨김) -->
                    <form id="editForm-${comment.id}" action="/groupboardcomment/update" method="post" style="display:none; margin-top:5px;">
                        <input type="hidden" name="id" value="${comment.id}"/>
                        <input type="hidden" name="boardId" value="${board.id}"/>
                        <textarea name="content" rows="2" cols="50">${comment.content}</textarea><br>
                        <input type="submit" value="수정 완료"/>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </form>
                </c:if>
            </div>
        </div>
    </c:forEach>

    <!-- 댓글 입력 폼 -->
    <form action="/groupboardcomment/create" method="post">
        <input type="hidden" name="groupId" value="${board.groupId}" />
        <input type="hidden" name="boardId" value="${board.id}" />
        <input type="hidden" name="parentId" id="parentId" value="" />
        <input type="hidden" name="depth" id="depth" value="0" />
        <textarea name="content" rows="3" cols="50" placeholder="댓글을 입력하세요."></textarea><br>
        <input type="submit" value="댓글 작성" />
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>


    <!-- 게시글 수정/삭제 버튼: 작성자 본인만 표시 -->
    <c:if test="${isAuthor}">
        <a href="/groupboard/update?id=${board.id}">게시글 수정</a>
        <a href="/report/?reportUser=${sessionScope.userId}&reportedUser=${board.author}&type=groupboard&boardId=${board.id}">신고하기</a>

        <form action="/groupboard/delete" method="post" onsubmit="return confirm('삭제하시겠습니까?');">
            <input type="hidden" name="id" value="${board.id}">
            <input type="hidden" name="groupId" value="${board.groupId}">
            <input type="submit" value="게시글 삭제">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </form>
    </c:if>

    <a href="/group/detail?groupId=${board.groupId}">← 목록으로 </a>
</body>

<script>
    // 댓글 클릭 시: 대댓글 대상 설정 + 버튼 토글
    function toggleCommentOptions(commentId, currentDepth) {
        if (currentDepth >= 1) {
                alert("답글은 한 단계까지만 작성할 수 있습니다.");
                return;
            }
        // 1. 대댓글 입력 정보
        document.getElementById("parentId").value = commentId;
        document.getElementById("depth").value = currentDepth + 1;

        // 2. 입력 폼으로 스크롤 + 포커스
        const textarea = document.querySelector("textarea[name='content']");
        textarea.focus();
        textarea.scrollIntoView({ behavior: 'smooth', block: 'center' }); // 스크롤 이동

        // 3. 모든 옵션/수정폼 숨기기
        const allOptions = document.querySelectorAll(".comment-options");
        allOptions.forEach(opt => opt.style.display = "none");

        const allEditForms = document.querySelectorAll("[id^='editForm-']");
        allEditForms.forEach(f => f.style.display = "none");

        // 4. 클릭한 댓글 옵션만 열기
        const target = document.getElementById("comment-options-" + commentId);
        if (target) {
            target.style.display = "block";
        }
    }

    // 수정 버튼 클릭 시: 해당 폼만 열기
    function toggleEditForm(commentId) {
        const form = document.getElementById("editForm-" + commentId);
        if (form.style.display === "none") {
            form.style.display = "block";
        } else {
            form.style.display = "none";
        }
    }
</script>
</html>