<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
</head>
<body>

    <c:if test="${param.error != null}">
        <div style="color:red;">로그인 실패: 아이디 또는 비밀번호를 확인해주세요.</div>
    </c:if>

    <c:if test="${param.logout != null}">
        <div style="color:blue;">로그아웃 되었습니다.</div>
    </c:if>

    <form action="/user/login" method="post">
        <label for="loginId">아이디:</label>
        <input type="text" name="loginId" id="loginId" />
        <br />
        <label for="password">비밀번호:</label>
        <input type="password" name="password" id="password" />
        <br />
        <button type="submit">로그인</button>

        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>
    <a href="/user/join">회원가입</a>
    <a href="/oauthLogin">
        <img height="50" src="https://static.nid.naver.com/oauth/small_g_in.PNG"/>
    </a>
</body>
</html>