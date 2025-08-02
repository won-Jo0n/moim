<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>게시글 수정</title>
</head>
<body>
    <h1>게시글 수정</h1>
    <form action="/mbti/board/edit" method="post">
        <input type="hidden" name="id" value="${board.id}" />
        <input type="hidden" name="mbtiId" value="${board.mbtiId}" />
        작성자: <input type="text" name="author" value="${board.author}" readonly /><br/>
        제목: <input type="text" name="title" value="${board.title}" required /><br/>
        내용:<br/>
        <textarea name="content" rows="10" cols="50" required>${board.content}</textarea><br/>
        <input type="hidden" name="fileId" value="${board.fileId}" />
        <input type="hidden" name="status" value="${board.status}" />
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <button type="submit">수정 완료</button>
    </form>
</body>
</html>
