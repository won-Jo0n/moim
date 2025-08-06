<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>친구 목록</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/profile.css">
</head>
<body>
<div class="friends-container">

    <h2>친구 목록</h2>

    <c:choose>
        <c:when test="${not empty friends}">
            <div class="friends-card-container">
                <c:forEach var="friend" items="${friends}">
                    <div class="friend-card" onclick="location.href='${pageContext.request.contextPath}/profile?userId=${friend.userId}'">
                        <div class="friend-nickname">${friend.nickname}</div>
                        <div class="friend-mbti">${friend.mbti}</div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <p>등록된 친구가 없습니다.</p>
        </c:otherwise>
    </c:choose>

</div>
</body>
</html>
