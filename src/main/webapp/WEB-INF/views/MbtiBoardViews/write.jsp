<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>글 작성</title>
</head>
<body>
    <h1>MBTI 게시글 작성</h1>
    <form action="/mbti/board/write" method="post">
        <input type="hidden" name="mbtiId" value="1" />
        작성자: <input type="text" name="author" required /><br/>
        제목: <input type="text" name="title" required /><br/>
        내용:<br/>
        <textarea name="content" rows="10" cols="50" required></textarea><br/>
        <input type="hidden" name="fileId" value="1"/>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <button type="submit">등록</button>
    </form>
</body>
</html>
