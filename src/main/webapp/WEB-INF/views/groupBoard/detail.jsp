<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


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
        <div>
            <strong>${comment.author}</strong>: ${comment.content}
            <c:if test="${comment.author == sessionScope.nickName}">
                <form action="/groupboardcomment/delete" method="post" >
                    <input type="hidden" name="id" value="${comment.id}" />
                    <input type="hidden" name="boardId" value="${board.id}" />
                    <input type="submit" value="삭제" />
                </form>
            </c:if>
        </div>
    </c:forEach>

    <form action="/groupboardcomment/create" method="post">
        <input type="hidden" name="groupId" value="${board.groupId}" />
        <input type="hidden" name="boardId" value="${board.id}" />
        <textarea name="content" rows="3" cols="50" placeholder="댓글을 입력하세요."></textarea><br>
        <input type="submit" value="댓글 작성" />
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>


    <!-- 수정/삭제 버튼: 작성자 본인만 표시 -->
    <c:if test="${isAuthor}">
        <a href="/groupboard/update?id=${board.id}">수정</a>
        <a href="/report/?reportUser=${sessionScope.userId}&reportedUser=${board.author}&type=groupboard&boardId=${board.id}">신고하기</a>

        <form action="/groupboard/delete" method="post" onsubmit="return confirm('삭제하시겠습니까?');">
            <input type="hidden" name="id" value="${board.id}">
            <input type="hidden" name="groupId" value="${board.groupId}">
            <input type="submit" value="삭제">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </form>
    </c:if>

    <a href="/group/detail?groupId=${board.groupId}">← 목록으로 </a>
</body>
</html>