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

    <div class="comment-section">
    <h3>댓글</h3>
    <c:forEach var="comment" items="${commentList}">
        <c:if test="${comment.parentId == 0}">
            <!-- 부모 댓글 -->
            <div class="comment">
                <div class="comment-meta">
                    ${comment.authorNickName} / <fmt:formatDate value="${comment.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                </div>
                <div id="content-${comment.id}">
                    ${comment.content}
                </div>

                <c:if test="${sessionScope.userId == comment.author}">
                    <button onclick="toggleEdit(${comment.id})">수정</button>
                    <form action="/groupboardcomment/delete" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="${comment.id}" />
                        <input type="hidden" name="boardId" value="${board.id}" />
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <input type="submit" value="삭제" />
                    </form>
                </c:if>

                <form id="edit-form-${comment.id}" action="/groupboardcomment/update" method="post" style="display:none;">
                    <input type="hidden" name="id" value="${comment.id}" />
                    <input type="hidden" name="boardId" value="${board.id}" />
                    <textarea name="content">${comment.content}</textarea>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <input type="submit" value="수정 완료" />
                </form>

                <div class="reply-btn" onclick="toggleReplyForm(${comment.id})">↪ 대댓글 작성</div>

                <form id="reply-form-${comment.id}" class="reply-form" action="/groupboardcomment/create" method="post" style="display:none;">
                    <input type="hidden" name="groupId" value="${board.groupId}" />
                    <input type="hidden" name="boardId" value="${board.id}" />
                    <input type="hidden" name="parentId" value="${comment.id}" />
                    <input type="hidden" name="depth" value="1" />
                    <textarea name="content" placeholder="대댓글을 입력하세요" required></textarea>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <input type="submit" value="작성" />
                </form>

                <!-- 대댓글 출력 -->
                <c:forEach var="reply" items="${commentList}">
                    <c:if test="${reply.parentId == comment.id}">
                        <div class="reply">
                            <div class="comment-meta">${reply.authorNickName} / <fmt:formatDate value="${reply.createdAt}" pattern="yyyy-MM-dd HH:mm" /></div>
                            <div id="content-${reply.id}">${reply.content}</div>

                            <c:if test="${sessionScope.userId == reply.author}">
                                <button onclick="toggleEdit(${reply.id})">수정</button>
                                <form action="/groupboardcomment/delete" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="${reply.id}" />
                                    <input type="hidden" name="boardId" value="${board.id}" />
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <input type="submit" value="삭제" />
                                </form>
                            </c:if>

                            <form id="edit-form-${reply.id}" action="/groupboardcomment/update" method="post" style="display:none;">
                                <input type="hidden" name="id" value="${reply.id}" />
                                <input type="hidden" name="boardId" value="${board.id}" />
                                <textarea name="content">${reply.content}</textarea>
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <input type="submit" value="수정 완료" />
                            </form>
                        </div>
                    </c:if>
                </c:forEach>

            </div>
        </c:if>
    </c:forEach>
    </div>

    <!-- 댓글 입력 폼 -->
    <form class="comment-form" action="/groupboardcomment/create" method="post">
        <input type="hidden" name="groupId" value="${board.groupId}" />
        <input type="hidden" name="boardId" value="${board.id}" />
        <input type="hidden" name="parentId" value="0" />
        <input type="hidden" name="depth" value="0" />
        <textarea name="content" placeholder="댓글을 입력하세요" required></textarea>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="submit" value="댓글 작성" />
    </form>

    <!-- 게시글 수정/삭제 버튼 -->
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
    function toggleReplyForm(id) {
        const form = document.getElementById('reply-form-' + id);
        form.style.display = form.style.display === 'none' ? 'block' : 'none';
    }

    function toggleEdit(id) {
        const form = document.getElementById('edit-form-' + id);
        form.style.display = form.style.display === 'none' ? 'block' : 'none';
    }
</script>
</html>
