<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 신고함</title>
    <link rel="stylesheet" href="../resources/css/report.css">
</head>
<body>

<h2>신고 내역 관리</h2>

<table>
    <thead>
        <tr>
            <th>신고 ID</th>
            <th>신고자 ID</th>
            <th>피신고자 ID</th>
            <th>상태</th>
            <th>내용</th>
            <th>신고일시</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="report" items="${reportList}">
            <tr>
                <td>${report.id}</td>
                <td>${report.reportUser}</td>
                <td>${report.reportedUser}</td>
                <td>
                    <c:choose>
                        <c:when test="${report.status == 1}">처리대기</c:when>
                        <c:when test="${report.status == 0}">처리완료</c:when>
                        <c:otherwise>알 수 없음</c:otherwise>
                    </c:choose>
                </td>
                <td>${report.content}</td>
                <td>${report.reportedAt}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>

</body>
</html>
