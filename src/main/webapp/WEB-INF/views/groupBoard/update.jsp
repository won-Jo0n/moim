<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
    <link rel="stylesheet" href="../resources/css/groupBoardUpdate.css" >
</head>
<body>
    <h2>게시글 수정</h2>

    <form action="/groupboard/update" method="post">
        <!-- 게시글 ID -->
        <input type="hidden" name="id" value="${board.id}" />

        <!-- 그룹 ID -->
        <input type="hidden" name="groupId" value="${board.groupId}" />

        <label for="title">제목:</label><br>
        <input type="text" id="title" name="title" value="${board.title}" required><br><br>

        <label for="content">내용:</label><br>
        <textarea id="content" name="content" rows="10" cols="50" required>${board.content}</textarea><br><br>

        <input type="submit" value="수정 완료">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>

</body>
</html>