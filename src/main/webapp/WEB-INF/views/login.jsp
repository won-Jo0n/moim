<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <h2>Login</h2>

    <!-- 인증 실패 시 에러 메시지 표시 -->
    <c:if test="${param.error != null}">
        <div style="color:red;">로그인 실패: 아이디 또는 비밀번호를 확인하세요.</div>
    </c:if>

    <form action="<c:url value='/login'/>" method="post">
        <label for="username">아이디:</label>
        <input type="text" name="username" id="username" />
        <br />
        <label for="password">비밀번호:</label>
        <input type="password" name="password" id="password" />
        <br />
        <button type="submit">로그인</button>

        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>
</body>
</html>
