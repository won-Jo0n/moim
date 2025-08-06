<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>신고하기</title>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
</head>
<body>
    <p>신고번호: ${report.id}</p>
    <p>신고자: ${reportUser.nickName}</p>
    <p>피신고자: ${reportedUser.nickName}</p>
    <p>신고 제목: ${report.title}</p>
    <p>신고 내용: ${report.content}</p>
    <p>신고 일자: ${report.reportedAt}</p>
    <a href="/${report.type}/detail?id=${report.boardId}">신고한 페이지 가기</a>
</body>
</html>