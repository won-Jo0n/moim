<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>사용자 통계</title>
    <link rel="stylesheet" href="/resources/css/admin.css" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <%@ include file="adminSidebar.jsp" %>

    <div class="main-content">
        <header class="topbar">
            <h1>사용자 통계</h1>
            <div class="user-profile">
                <span>관리자님</span>
                <i class="fa-solid fa-user-circle"></i>
            </div>
        </header>

        <section class="main-panel">
            <div class="panel-header">
                <h3>통계 차트</h3>
            </div>
            <div class="panel-content">
                <div class="chart-grid">
                    <c:forEach var="chart" items="${statsList}" varStatus="status">
                        <div class="chart-card">
                            <h4 class="chart-title">${chart.title}</h4>
                            <canvas id="chart-${status.index}" class="chart-canvas"></canvas>
                        </div>

                        <script>
                            const ctx${status.index} = document.getElementById('chart-${status.index}').getContext('2d');
                            new Chart(ctx${status.index}, {
                                type: '${chart.type}',
                                data: {
                                    labels: [
                                        <c:forEach var="label" items="${chart.labels}" varStatus="i">
                                            "${label}"<c:if test="${!i.last}">,</c:if>
                                        </c:forEach>
                                    ],
                                    datasets: [{
                                        label: '${chart.label}',
                                        data: [
                                            <c:forEach var="d" items="${chart.data}" varStatus="i">
                                                ${d}<c:if test="${!i.last}">,</c:if>
                                            </c:forEach>
                                        ],
                                        backgroundColor: [
                                            <c:forEach var="bg" items="${chart.backgroundColors}" varStatus="i">
                                                "${bg}"<c:if test="${!i.last}">,</c:if>
                                            </c:forEach>
                                        ],
                                        borderColor: [
                                            <c:forEach var="bc" items="${chart.borderColors}" varStatus="i">
                                                "${bc}"<c:if test="${!i.last}">,</c:if>
                                            </c:forEach>
                                        ],
                                        borderWidth: 1
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    plugins: {
                                        legend: {
                                            display: true,
                                            position: 'bottom'
                                        }
                                    },
                                    scales: {
                                        y: { beginAtZero: true },
                                        x: { grid: { display: false } }
                                    }
                                }
                            });
                        </script>
                    </c:forEach>
                </div>
            </div>
        </section>
    </div>
</body>
</html>
