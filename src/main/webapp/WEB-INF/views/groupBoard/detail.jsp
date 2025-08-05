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
    <p><strong>내용:</strong></p>
    <p>${board.content}</p>

    <!-- 수정/삭제 버튼: 작성자 본인만 표시 -->
    <c:if test="${isAuthor}">
        <a href="/groupboard/update?id=${board.id}">수정</a>

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