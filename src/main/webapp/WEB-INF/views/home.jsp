<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>홈</title>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
</head>
<body>
    <p>home</p>
    <%@ include file="header.jsp" %>
    <img src = "/file/preview?fileId=${loginUser.fileId}" style = "width: 300px; height: 300px;"/>
    <a href="/user/modify">수정하기</a>
    <a href="/user/logout">로그아웃</a>
    <a href="/group/create">그룹생성</a>
    <a href="/mbti/test/">mbti 테스트${mbtiResult}</a>
</body>
</html>