<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>모임 수정</title>
</head>
<body>
    <h2>모임 수정</h2>

    <form action="/group/update" method="post">
        <input type="hidden" name="id" value="${group.id}" />

        <label for="title">모임명:</label>
        <input type="text" id="title" name="title" value="${group.title}" required />
        <br><br>

        <label for="description">모임 소개:</label><br>
        <textarea id="description" name="description" rows="4" cols="50" required>${group.description}</textarea>
        <br><br>

        <label for="location">모임 지역:</label>
        <input type="text" id="location" name="location" value="${group.location}" required />
        <br><br>

        <label for="maxUserNum">최대 인원:</label>
        <input type="number" id="maxUserNum" name="maxUserNum" value="${group.maxUserNum}" required />
        <br><br>

        <button type="submit">수정 완료</button>
        <a href="/group/detail?id=${group.id}">취소</a>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>

</body>
</html>
