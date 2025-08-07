<%@ page contentType="text/html;charset=UTF-8" language="java"  isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 신고함</title>
    <link rel="stylesheet" href="../resources/css/report.css">
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
</head>
<body>

<h2>신고 내역 관리</h2>

<table>
    <thead>
        <tr>
            <th>신고 ID</th>
            <th>신고자</th>
            <th>피신고자</th>
            <th>상태</th>
            <th>제목</th>
            <th>신고일시</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="report" items="${reportPage}">
            <tr onclick="handleReportClick(${report.id})">
                <td>${report.id}</td>
                <td>${reportUserMap[report.id]}</td>
                <td>${reportedUserMap[report.id]}</td>
                <td>
                    <c:choose>
                        <c:when test="${report.status == 1}">처리대기</c:when>
                        <c:when test="${report.status == 0}">처리완료</c:when>
                        <c:otherwise>알 수 없음</c:otherwise>
                    </c:choose>
                </td>
                <td>${report.title}</td>
                <td>
                    <fmt:formatDate value="${report.reportedAt}" pattern="yyyy-MM-dd"/>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<div class="pagination">
    <c:if test="${pageInfo.currentPage > 1}">
        <a href="/admin/report?page=${pageInfo.currentPage - 1}">이전</a>
    </c:if>

    <c:forEach begin="1" end="${pageInfo.totalPage}" var="pageNumber">
        <a href="/admin/report?page=${pageNumber}" class="${pageNumber eq pageInfo.currentPage ? 'active' : ''}">
            ${pageNumber}
        </a>
    </c:forEach>

    <c:if test="${pageInfo.currentPage < pageInfo.totalPage}">
        <a href="/admin/report?page=${pageInfo.currentPage + 1}">다음</a>
    </c:if>
</div>

<script>
    const handleReportClick = (reportId)=>{
        location.href="/report/detail?id="+reportId;
    }
</script>
</body>
</html>