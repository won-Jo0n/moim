<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>index</title>
</head>
<body>
    <h2>Hello SpringFramework</h2>
    <form action="/group/create" method="post" target="_blank">
        <input type="hidden" name="leaderId" value="${sessionScope.userId}">
        <input type="text" name="leaderName" value="${sessionScope.userName}" readOnly>
        <textarea name="description" id="description">모임 소개</textarea>
        <input type="text" name="title" placeholder="모임 이름">
        <select name="" id=""></select>
        <input type="number" name="maxUserNum" placeholder="최대인원 ">
        <button type="submit">모임 만들기</button>
    </form>


</body>
</html>