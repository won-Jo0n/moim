<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>게시글 상세보기</title>
</head>
<body>
    <h1>제목: ${board.title}</h1>
    <p>작성자: ${board.author}</p>
    <p>작성일: ${board.createdAt}</p>
    <p>내용:<br/>${board.content}</p>

    <a href="/mbti/board/edit/${board.id}">수정</a>
    <a href="/mbti/board/delete/${board.id}">삭제</a>
    <br/><a href="/mbti/board/${board.mbtiId}">목록으로</a>
</body>
</html>
