<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>모임 목록</title>
    <link rel="stylesheet" href="../resources/css/groupList.css" >
</head>
<body>
    <h2>모임 목록</h2>

    <form action="/group/list" method="get" class="search-form">
        <input type="text" name="keyword" placeholder="검색어를 입력하세요" value="${param.keyword}"/>
        <button type="submit">검색</button>
    </form>

    <table>
        <thead>
            <tr>
                <th>모임명</th>
                <th>대표 사진</th>
                <th>모임 지역</th>
                <th>모임 소개</th>
                <th>최대 인원</th>
                <th>생성일</th>
                <th>상태</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="group" items="${groupList}">
                <tr class="clickable-row" data-id="${group.id}">
                    <td>${group.title}</td>
                    <td>
                        <img src="/file/preview?fileId=${group.fileId}" alt="Group image" required/>
                    </td>
                    <td>${group.location}</td>
                    <td>${group.description}</td>
                    <td>${group.maxUserNum}</td>
                     <td>
                        <fmt:formatDate value="${group.createdAt}" pattern="yyyy-MM-dd" />
                    </td>
                    <td>
                        <c:choose>
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
                window.location.href = "/group/detail?groupId=" + id;
            });
        });
    </script>
</body>
</html>