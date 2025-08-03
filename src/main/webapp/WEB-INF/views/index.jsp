<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <link rel="stylesheet" href="/resources/css/index.css">
</head>
<body>

<div class="container">
    <!-- 로고 이미지 영역 -->
    <div class="image-section">
        <img src="/resources/images/logo.png" alt="로고 이미지">
        <!-- 로고 이미지는 /static/img/logo.png 경로에 위치한다고 가정 -->
    </div>

    <!-- 로그인 폼 영역 -->
    <div class="form-section">
        <form action="/login" method="post">
            <input type="text" name="loginId" placeholder="아이디" required />
            <input type="password" name="password" placeholder="비밀번호" required />
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <button type="submit">로그인</button>
        </form>

        <div class="signup-link">
            아직 계정이 없으신가요? <a href="/user/join">회원가입</a>
        </div>

        <div class="social-login">
            <a href="/oauthLogin">
                <img src="https://static.nid.naver.com/oauth/small_g_in.PNG" alt="네이버 로그인">
            </a>
        </div>
    </div>
</div>

</body>
</html>
