<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>모임 상세 페이지</title>
</head>
<body>
    <h2>모임 상세 페이지</h2>
    <p><strong>모임명:</strong> ${group.title}</p>
    <p><strong>모임 소개:</strong> ${group.description}</p>
    <p><strong>모임 지역:</strong> ${group.location}</p>
    <p><strong>최대 인원:</strong> ${group.maxUserNum}</p>
    <p><strong>생성일:</strong>
        <fmt:formatDate value="${group.createdAt}" pattern="yyyy-MM-dd" />
    </p>

    <a href="/group/update?id=${group.id}">수정하기</a>
    <a href="/group/list">←</a>
</body>
</html>