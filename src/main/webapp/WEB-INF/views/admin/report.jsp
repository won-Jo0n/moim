<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 신고함</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7f6;
            margin: 0;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: auto;
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
        }

        .table-container {
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 0;
        }

        thead th {
            background-color: #007bff;
            color: white;
            padding: 15px 12px;
            text-align: left;
            font-weight: bold;
        }

        tbody tr {
            border-bottom: 1px solid #ddd;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        tbody tr:last-child {
            border-bottom: none;
        }

        tbody tr:hover:not(.status-processed) {
            background-color: #e6f2ff;
        }

        tbody td {
            padding: 12px;
            vertical-align: middle;
        }

        .status-processed {
            background-color: #e9ecef;
            color: #888;
            cursor: default;
        }

        .status-processed:hover {
             background-color: #e9ecef;
        }

        .status-pending {
            color: #dc3545; /* Red for pending */
            font-weight: bold;
        }

        .status-completed {
            color: #28a745; /* Green for completed */
            font-weight: bold;
        }

        .action-button {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.2s ease;
        }

        .action-button:hover {
            background-color: #218838;
        }

        .action-button:disabled {
            background-color: #6c757d;
            cursor: not-allowed;
        }

        .pagination {
            text-align: center;
            margin-top: 20px;
        }

        .pagination a {
            display: inline-block;
            padding: 8px 16px;
            text-decoration: none;
            color: #007bff;
            border: 1px solid #ddd;
            margin: 0 4px;
            border-radius: 4px;
            transition: background-color 0.2s ease;
        }

        .pagination a:hover:not(.active) {
            background-color: #e9ecef;
        }

        .pagination a.active {
            background-color: #007bff;
            color: white;
            border: 1px solid #007bff;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>신고 내역 관리</h2>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>신고 ID</th>
                    <th>신고자</th>
                    <th>피신고자</th>
                    <th>상태</th>
                    <th>제목</th>
                    <th>신고일시</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="report" items="${reportPage}">
                    <tr onclick="handleReportClick(${report.id})" class="${report.status == 0 ? 'status-processed' : ''}">
                        <td>${report.id}</td>
                        <td>${reportUserMap[report.id]}</td>
                        <td>${reportedUserMap[report.id]}</td>
                        <td class="${report.status == 1 ? 'status-pending' : 'status-completed'}">
                            <c:choose>
                                <c:when test="${report.status == 1}">처리대기</c:when>
                                <c:when test="${report.status == 0}">처리완료</c:when>
                                <c:otherwise>알 수 없음</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${report.title}</td>
                        <td>${formattedDates[report.id]}</td>
                        <td>
                            <c:if test="${report.status == 1}">
                                <button class="action-button" onclick="event.stopPropagation(); processReport(${report.id})">처리 완료</button>
                            </c:if>
                            <c:if test="${report.status == 0}">
                                <button class="action-button" disabled>완료됨</button>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

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
</div>

<script>
    const handleReportClick = (reportId) => {
        location.href = "/report/detail?id=" + reportId;
    }

    const processReport = (reportId) => {
        if(confirm(reportId + "번 신고를 처리 완료하시겠습니까?")) {
            console.log(reportId + "번 신고 처리 완료.");
            location.href="/admin/processReport?id=" + reportId;
        }
    }
</script>
</body>
</html>