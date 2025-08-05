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
    <form action="/report/" method="post">
        <p>신고자: ${reportUser}</p>
        <p>피신고자: ${reportedUser}</p>
        <input type="text" name="title" placeholder="제목 입력" />
        <textarea name="content" placeholder="신고 내용"></textarea>
        <input type="hidden" name="reportUser" value="${reportDTO.reportUser}"/>
        <input type="hidden" name="reportedUser" value="${reportDTO.reportedUser}"/>
        <input type="hidden" name="type" value="${reportDTO.type}"/>
        <input type="hidden" name="boardId" value="${reportDTO.boardId}"/>
        <c:if test="${not empty reportDTO.commentId}">
            <input type="hidden" name="boardId" value="${reportDTO.commentId}"/>
        </c:if>
        <input type="submit" value="신고하기"/>
    </form>
</body>
</html>