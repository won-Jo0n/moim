<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>신고하기</title>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
    <link rel="stylesheet" href="../resources/css/reportForm.css">

</head>
<body>
<div class="report-container">
    <h1>신고하기</h1>
    <form action="/report/" method="post">
        <p><strong>신고자:</strong> ${reportUser}</p>
        <p><strong>피신고자:</strong> ${reportedUser}</p>

        <input type="text" name="title" placeholder="제목 입력" />
        <textarea name="content" placeholder="신고 내용을 작성해주세요"></textarea>

        <input type="hidden" name="reportUser" value="${reportDTO.reportUser}"/>
        <input type="hidden" name="reportedUser" value="${reportDTO.reportedUser}"/>
        <input type="hidden" name="type" value="${reportDTO.type}"/>
        <input type="hidden" name="boardId" value="${reportDTO.boardId}"/>
        <c:if test="${not empty reportDTO.commentId}">
            <input type="hidden" name="boardId" value="${reportDTO.commentId}"/>
        </c:if>

        <input type="submit" value="신고하기"/>
    </form>
</div>
</body>
</html>
