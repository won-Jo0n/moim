<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<title>게시글 수정</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mbtiBoard.css">
</head>
<body>
    <h1>게시글 수정</h1>
    <form action="/mbti/board/edit" method="post">
        <input type="hidden" name="id" value="${board.id}">
        제목: <input type="text" name="title" value="${board.title}"><br>
        내용: <textarea name="content">${board.content}</textarea><br>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="submit" value="수정하기">
    </form>
</body>
</html>
