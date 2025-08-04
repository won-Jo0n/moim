<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<title>게시글 작성</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mbtiBoard.css">
</head>
<body>
    <h1>게시글 작성</h1>
    <form action="/mbti/board/write" method="post" enctype="multipart/form-data">
        제목: <input type="text" name="title"><br>
        내용: <textarea name="content" ></textarea><br>
        <input type="file" name=:"mbtiBoardFile">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="submit" value="작성">
    </form>
</body>
</html>