<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>게시글 상세</title>
    <style>
       body {
           font-family: 'Arial', sans-serif;
           background-color: #fafafa;
           margin: 0;
           display: flex;
           justify-content: center;
           padding: 60px 0;
       }

       .detail-container {
           background-color: #fff;
           padding: 40px;
           border-radius: 20px;
           width: fit-content;         /* ✅ 내용에 맞게 너비 조정 */
           max-width: 90vw;            /* ✅ 최대 너비 제한 */
           min-width: 400px;           /* ✅ 최소 너비 확보 */
           height: auto;               /* ✅ 높이는 내용에 따라 자동 */
           box-shadow: 0 0 15px rgba(0,0,0,0.1);
           word-break: break-word;     /* ✅ 줄바꿈 처리 */
       }

       h1 {
           font-size: 26px;
           margin-bottom: 10px;
       }

       .meta {
           color: #999;
           margin-bottom: 20px;
       }

       .content {
           font-size: 16px;
           line-height: 1.6;
           color: #333;
           margin-bottom: 1rem;
       }

       .actions {
           text-align: right;
       }

       .actions a,
       .actions input[type="submit"] {
           background-color: #3897f0;
           color: white;
           border: none;
           padding: 10px 14px;
           border-radius: 8px;
           font-weight: bold;
           text-decoration: none;
           cursor: pointer;
           margin-left: 10px;
       }

       .comment-section {
           margin-top: 40px;
           max-height: 500px;
           overflow-y: auto;
       }

       .comment {
           border-top: 1px solid #ccc;
           padding: 10px 0;
           max-width: 700px;              /* ✅ 내부 요소가 container 넘지 않도록 제한 */
           box-sizing: border-box;
       }

       .reply {
           margin-left: 20px;
           padding: 10px;
           border-left: 2px solid #ccc;
           background-color: #f7f7f7;
           max-width: 680px;              /* ✅ 대댓글도 마찬가지 제한 */
           box-sizing: border-box;
       }

       .comment-meta {
           font-size: 13px;
           color: #666;
       }

       .comment-form textarea {
           width: 100%;
           padding: 10px;
           border-radius: 8px;
           border: 1px solid #ccc;
           margin-top: 10px;
           box-sizing: border-box;
       }

       .comment-form input[type="submit"] {
           margin-top: 10px;
           background-color: #28a745;
           color: #fff;
           padding: 10px 14px;
           border: none;
           border-radius: 8px;
           cursor: pointer;
       }

       .reply-btn {
           font-size: 12px;
           color: #007bff;
           cursor: pointer;
           margin-top: 5px;
       }

       .reply-form {
           margin-top: 10px;
           max-width: 680px;
           box-sizing: border-box;
       }
    </style>
</head>
<body>
<div class="detail-container">
    <h1>${board.title}</h1>
    <div class="meta">작성자: ${board.authorInfo} | 작성일: ${board.formattedCreatedAt}</div>
    <div class="content">${board.content}</div>

    <div class="actions">
        <c:if test="${isAuthor}">
            <a href="/mbti/board/edit/${board.id}">수정</a>
            <form action="/mbti/board/delete/${board.id}" method="post" style="display:inline;">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <input type="hidden" name="boardId" value="${board.id}" />
                <input type="submit" value="삭제"/>
            </form>
        </c:if>
    </div>

    <div class="comment-section">
        <h3>댓글</h3>

        <c:forEach var="comment" items="${commentList}">
            <c:if test="${comment.parentId == 0}">
                <!-- 부모 댓글 -->
                <div class="comment">
                    <div class="comment-meta">
                        ${comment.authorNickname} / ${comment.createdAt}
                    </div>
                    <div id="content-${comment.id}">
                        ${comment.content}
                    </div>

                    <c:if test="${sessionScope.userId == comment.author}">
                        <button onclick="toggleEdit(${comment.id})">수정</button>
                        <form action="/mbti/board/comment/delete/${comment.id}" method="post" style="display:inline;">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <input type="hidden" name="boardId" value="${board.id}" />
                            <input type="submit" value="삭제" />
                        </form>
                    </c:if>

                    <form id="edit-form-${comment.id}" action="/mbti/board/comment/update" method="post" style="display:none;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <input type="hidden" name="id" value="${comment.id}" />
                        <textarea name="content">${comment.content}</textarea>
                        <input type="hidden" name="boardId" value="${board.id}" />
                        <input type="submit" value="수정 완료" />
                    </form>

                    <div class="reply-btn" onclick="toggleReplyForm(${comment.id})">↪ 대댓글 작성</div>

                    <form id="reply-form-${comment.id}" class="reply-form" action="/mbti/board/comment/save" method="post" style="display:none;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <input type="hidden" name="boardId" value="${board.id}" />
                        <input type="hidden" name="parentId" value="${comment.id}" />
                        <textarea name="content" placeholder="대댓글을 입력하세요" required></textarea>
                        <input type="submit" value="작성" />
                    </form>

                    <!-- 대댓글 출력 -->
                    <c:forEach var="reply" items="${commentList}">
                        <c:if test="${reply.parentId == comment.id}">
                            <div class="reply">
                                <div class="comment-meta">
                                    ${reply.authorNickname} / ${reply.createdAt}
                                </div>
                                <div id="content-${reply.id}">
                                    ${reply.content}
                                </div>

                                <c:if test="${sessionScope.userId == reply.author}">
                                    <button onclick="toggleEdit(${reply.id})">수정</button>
                                    <form action="/mbti/board/comment/delete/${reply.id}" method="post" style="display:inline;">
                                    <input type="hidden" name="boardId" value="${board.id}" />
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <input type="submit" value="삭제" />
                                    </form>
                                </c:if>

                                <form id="edit-form-${reply.id}" action="/mbti/board/comment/update" method="post" style="display:none;">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <input type="hidden" name="id" value="${reply.id}" />
                                    <input type="hidden" name="boardId" value="${board.id}" />
                                    <textarea name="content">${reply.content}</textarea>
                                    <input type="submit" value="수정 완료" />
                                </form>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </c:if>
        </c:forEach>

        <!-- 댓글 작성 폼 -->
        <form class="comment-form" action="/mbti/board/comment/save" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <input type="hidden" name="boardId" value="${board.id}" />
            <input type="hidden" name="parentId" value="0" />
            <textarea name="content" placeholder="댓글을 입력하세요" required></textarea>
            <input type="submit" value="댓글 작성"/>
        </form>
    </div>

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
</body>
</html>
