<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>통계 차트</title>
    <link rel="stylesheet" href="../resources/css/chart.css" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;600&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<%@ include file="adminSidebar.jsp" %>
<div class="chart-dashboard">
    <div class="dashboard-header">
        <h1 class="dashboard-title">사용자 통계</h1>
        <div class="top-button-container">
            <button onclick="window.history.back()" class="back-to-home-button">돌아가기</button>
        </div>
    </div>

    <div class="chart-grid">
        <c:forEach var="chart" items="${statsList}" varStatus="status">
            <div class="chart-card">
                <h2 class="chart-title">${chart.title}</h2>
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
</body>
</html>