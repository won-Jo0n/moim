<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>MBTI 게시판 목록</title>
</head>
<body>
    <h1>MBTI 게시판</h1>
    <a href="/mbti/board/write">글 작성</a>
    <table border="1">
        <tr>
            <th>번호</th>
            <th>제목</th>
            <th>작성자</th>
            <th>내용</th>
            <th>작성일</th>
        </tr>
        <c:forEach var="board" items="${boardList}">
            <tr>
                <td>${board.id}</td>
                <td><a href="/mbti/board/detail/${board.id}">${board.title}</a></td>
                <td>${board.author}</td>
                <td>${board.authorName}</td>
                <td>${board.createdAt}</td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>
