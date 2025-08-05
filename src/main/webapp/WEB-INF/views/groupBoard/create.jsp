<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>글 작성</title>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
</head>
<body>
    <h2>글 작성</h2>

<form action="/groupboard/create" method="post">

    <!-- 그룹 ID -->
    <input type="hidden" name="groupId" value="${groupId}" />

    <label for="title">제목:</label><br>
    <input type="text" id="title" name="title" required><br><br>

    <label for="content">내용:</label><br>
    <textarea id="content" name="content" rows="10" cols="50" required></textarea><br><br>

    <%-- 파일 업로드는 추후 추가 예정 --%>

    <input type="submit" value="등록">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
</form>


</body>


</html>