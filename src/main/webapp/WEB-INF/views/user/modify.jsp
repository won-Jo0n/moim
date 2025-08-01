<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>수정</title>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
</head>
<body>
    <h2>회원 수정</h2>
    <form action="/user/modify" method="post">
        <input type="text" value="${user.loginId}" readOnly/>
        <input type="text" value="${user.gender}" readOnly/>
        <input type="text" value="${user.birthDate}" readOnly/>
        <input type="text" value="${user.nickName}" />
        <input type="text" value="${user.region}" />
        <input type="submit" value="수정하기"/>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>

</body>
</html>