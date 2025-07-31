<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>모임 목록</title>
</head>
<body>
    <h2>모임 목록</h2>

    <table>
        <thead>
            <tr>
                <th>모임명</th>
                <th>모임 지역</th>
                <th>최대 인원</th>
                <th>생성일</th>
                <th>상태</th>
                <th>삭제</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="group" items="${groupList}">
                <tr>

                    <td>${group.title}</td>
                    <td>${group.location}</td>
                    <td>${group.maxUserNum}</td>
                    <td>${group.createdAt}</td>
                    <td>
                        <c:choose>
                             <!--1 = 활성, 0 = 비활성, -1 = 삭제됨-->
                            <c:when test="${group.status == 1}">활성</c:when>
                            <c:when test="${group.status == 0}">비활성</c:when>
                            <c:otherwise>삭제됨</c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <form action="/group/delete" method="get" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                            <input type="hidden" name="id" value="${group.id}">
                            <button type="submit">삭제</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>