<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>모임 수정 페이지</title>
</head>
<body>
    <h2>모임 수정 페이지</h2>
    <form action="/group/update" method="post">
        <input type="hidden" name="id" value="${group.id}">
        <p><input type="text" name="title" value="${group.title}" required></p>
        <p><textarea name="description" rows="5" cols="30">${group.description}</textarea></p>
        <p><input type="number" name="maxUserNum" value="${group.maxUserNum}" min="1"></p>
        <button type="submit">수정하기</button>
    </form>
</body>
</html>
