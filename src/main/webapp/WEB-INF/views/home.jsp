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
    <p>${sessionScope.loginId}</p>
    <a href="/group/create">그룹생성</a>
</body>
</html>