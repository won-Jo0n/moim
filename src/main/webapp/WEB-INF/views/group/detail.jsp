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

    <!-- 로그인한 사용자가 모임장일 때만 수정/삭제 버튼 보이기 -->
    <c:if test="${sessionScope.userId == group.leader}">
        <form action="/group/update" method="get">
            <input type="hidden" name="id" value="${group.id}"/>
            <button type="submit">수정</button>
        </form>

        <form action="/group/delete" method="get" onsubmit="return confirm('정말 삭제하시겠습니까?');">
            <input type="hidden" name="id" value="${group.id}" />
            <button type="submit">삭제</button>
        </form>
    </c:if>

    <a href="/group/list">← 목록으로 </a>
</body>
</html>