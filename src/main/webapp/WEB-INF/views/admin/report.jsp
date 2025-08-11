<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 신고함</title>
    <link rel="stylesheet" href="/resources/css/admin.css">
</head>
<body>
    <%@ include file="adminSidebar.jsp" %>

    <div class="main-content">
        <!-- 상단바 -->
        <header class="topbar">
            <h1>신고 내역 관리</h1>
            <div class="user-profile">
                <span>관리자님</span>
                <i class="fa-solid fa-user-circle"></i>
            </div>
        </header>

        <!-- 신고 테이블 -->
        <section class="main-panel">
            <div class="panel-header">
                <h3>신고 목록</h3>
            </div>
            <div class="panel-content">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th class="first-th">신고 ID</th>
                            <th>신고자</th>
                            <th>피신고자</th>
                            <th>상태</th>
                            <th>제목</th>
                            <th>신고일시</th>
                            <th class="last-th">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="report" items="${reportPage}">
                            <tr onclick="handleReportClick(${report.id})" class="${report.status == 0 ? 'row-completed' : ''}">
                                <td>${report.id}</td>
                                <td>${reportUserMap[report.id]}</td>
                                <td>${reportedUserMap[report.id]}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${report.status == 1}">
                                            <span class="status pending">처리대기</span>
                                        </c:when>
                                        <c:when test="${report.status == 0}">
                                            <span class="status completed">처리완료</span>
                                        </c:when>
                                        <c:otherwise>알 수 없음</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${report.title}</td>
                                <td>${formattedDates[report.id]}</td>
                                <td>
                                    <c:if test="${report.status == 1}">
                                        <button class="action-button" onclick="event.stopPropagation(); processReport(${report.id})">
                                            처리 완료
                                        </button>
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
        </section>

        <!-- 페이지네이션 -->
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
            if (confirm(reportId + "번 신고를 처리 완료하시겠습니까?")) {
                location.href = "/admin/processReport?id=" + reportId;
            }
        }
    </script>
</body>
</html>
