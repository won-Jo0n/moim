<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>모임 목록</title>
    <style>
        .clickable-row {
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .clickable-row:hover {
            background-color: #f0f0f0;
        }
    </style>
</head>
<body>
    <h2>모임 목록</h2>

    <table border="1" cellpadding="8" cellspacing="0">
        <thead>
            <tr>
                <th>모임명</th>
                <th>모임 지역</th>
                <th>최대 인원</th>
                <th>생성일</th>
                <th>상태</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="group" items="${groupList}">
                <tr class="clickable-row" data-id="${group.id}">
                    <td>${group.title}</td>
                    <td>${group.location}</td>
                    <td>${group.maxUserNum}</td>
                    <td>${group.createdAt}</td>
                    <td>
                        <c:choose>
                            <%--1 = 활성, 0 = 비활성, -1 = 삭제됨--%>
                            <c:when test="${group.status == 1}">활성</c:when>
                            <c:when test="${group.status == 0}">비활성</c:when>
                            <c:otherwise>삭제됨</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <script>
        document.querySelectorAll(".clickable-row").forEach(function(row) {
            row.addEventListener("click", function () {
                const id = this.dataset.id;
                window.location.href = "/group/detail?id=" + id;
            });
        });
    </script>
</body>
</html>