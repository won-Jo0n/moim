<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>index</title>
</head>
<body>
    <h2>회원가입</h2>
    <form action="/user/join" method="post">
        <input type="text" name="loginId" placeholder="아이디 입력">
        <input type="password" name="password" placeholder="비밀번호 입력">
        <input type="text" name="nickName" placeholder="닉네임">
        <label>성별:</label><br>
        <input type="radio" id="male" name="gender" value="male">
        <label for="male">남성</label><br>
        <input type="radio" id="female" name="gender" value="female">
        <label for="female">여성</label><br>
        <label for="birthDate">생년월일</label><br>
        <input id="birthDate" type="date" name="birthDate">
        <input type="text" name="region" placeholder="주소">
        <input type="submit" value="가입하기">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>

</body>
</html>