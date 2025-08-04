<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>게시글 상세</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mbtiBoard.css">

</head>
<body>
    <h1>${board.title}</h1>
    <p>작성자: ${board.author}</p>
    <p>작성일: ${board.formattedCreatedAt}</p>
    <p>내용:<br>${board.content}</p>

    <!-- 수정 & 삭제 -->
    <a href="/mbti/board/edit/${board.id}">수정</a>
    <form action="/mbti/board/delete/${board.id}" method="post" style="display:inline;">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <button type="submit">삭제</button>
    </form>
    <br><a href="/mbti/board">목록으로</a>

    <hr>

    <!-- 댓글 작성 -->
    <h3>댓글 작성</h3>
    <form action="/mbti/board/comment/save" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="boardId" value="${board.id}" />
        <textarea name="content" rows="3" cols="50" placeholder="댓글을 입력하세요" required></textarea><br>
        <button type="submit">작성</button>
    </form>

    <hr>

    <!-- 댓글 목록 출력 -->
    <h3>댓글 목록</h3>
    <c:forEach var="comment" items="${commentList}">
        <c:if test="${comment.parentId == null}">
            <!-- 원댓글 -->
            <div>
                <p><strong>${comment.authorNickname}</strong> - ${comment.createdAt}</p>
                <p>${comment.content}</p>

                <!-- 삭제 버튼 -->
                <form action="/mbti/board/comment/delete/${comment.id}" method="post" style="display:inline;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <input type="hidden" name="boardId" value="${board.id}" />
                    <button type="submit">삭제</button>
                </form>

                <!-- 대댓글 작성 -->
                <form action="/mbti/board/comment/save" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <input type="hidden" name="boardId" value="${board.id}" />
                    <input type="hidden" name="parentId" value="${comment.id}" />
                    <textarea name="content" rows="2" cols="50" placeholder="대댓글 입력" required></textarea>
                    <button type="submit">답글</button>
                </form>

                <!-- 대댓글 출력 -->
                <c:forEach var="reply" items="${commentList}">
                    <c:if test="${reply.parentId == comment.id}">
                        <div style="margin-left: 20px;">
                            <p><strong>${reply.authorNickname}</strong> - ${reply.createdAt}</p>
                            <p>${reply.content}</p>

                            <form action="/mbti/board/comment/delete/${reply.id}" method="post" style="display:inline;">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <input type="hidden" name="boardId" value="${board.id}" />
                                <button type="submit">삭제</button>
                            </form>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </c:if>
    </c:forEach>
</body>
</html>
