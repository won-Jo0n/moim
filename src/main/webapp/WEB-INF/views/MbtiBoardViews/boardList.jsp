<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>자유 게시판</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mbtiBoard.css">

</head>
<body>
    <h1>자유 게시판</h1>
    <a href="/mbti/board/write">글쓰기</a>
    <table border="1">
        <tr>
            <th>번호</th>
            <th>제목</th>
            <th>작성자</th>
            <th>내용</th>
            <th>작성일</th>
        </tr>

        <c:if test="${empty boardList}">
            <tr>
                <td colspan="5" style="text-align:center;">게시글이 없습니다.</td>
            </tr>
        </c:if>

        <c:forEach var="board" items="${boardList}">
            <tr>
                <td>${board.id}</td>
                <td>
                    <a href="/mbti/board/detail/${board.id}">${board.title}</a>
                </td>
                <td>${board.author}</td>
                <td>${board.content}</td>
                <td>${board.createdAt}</td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>
