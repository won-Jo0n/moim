<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 대시보드</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../resources/css/admin.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
 <aside class="sidebar">
        <div class="logo">
            <h2>Admin</h2>
        </div>
        <nav class="main-nav">
            <a href="/admin" class="active"><i class="fa-solid fa-house"></i> 대시보드</a>
            <a href="/admin/report"><i class="fa-solid fa-flag"></i> 신고 관리</a>
            <a href="/admin/chart"><i class="fa-solid fa-chart-line"></i> 통계 분석</a>
            <a href="/admin/penalties"><i class="fa-solid fa-users"></i> 사용자 관리</a>
        </nav>
    </aside>

    <div class="main-content">
        <header class="topbar">
            <h1>관리자 대시보드</h1>
            <div class="user-profile">
                <span>관리자님</span>
                <i class="fa-solid fa-user-circle"></i>
            </div>
        </header>

        <section class="dashboard-cards">
            <div class="card summary-card reports">
                <div class="card-icon"><i class="fa-solid fa-flag"></i></div>
                <div class="card-info">
                    <h4>대기 중인 신고</h4>
                    <span class="count">${pendingReportsCount}</span>
                </div>
            </div>

            <div class="card summary-card users">
                <div class="card-icon"><i class="fa-solid fa-users"></i></div>
                <div class="card-info">
                    <h4>총 사용자 수</h4>
                    <span class="count">${totalUserCount}</span>
                </div>
            </div>

            <div class="card summary-card penalties">
                <div class="card-icon"><i class="fa-solid fa-ban"></i></div>
                <div class="card-info">
                    <h4>정지중인 사용자 수</h4>
                    <span class="count">${penaltiesUser}</span>
                </div>
            </div>
        </section>

        <section class="main-panel">
            <div class="panel-header">
                <h3>최근 신고 내역</h3>
                <a href="/admin/report" class="view-all">전체 보기 <i class="fa-solid fa-arrow-right"></i></a>
            </div>
            <div class="panel-content">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th class="first-th">ID</th>
                            <th>제목</th>
                            <th>신고일자</th>
                            <th class="last-th">상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="report" items="${recentReports}">
                            <tr>
                                <td>${report.id}</td><td>${report.title}</td><td>${formattedDate[report.id]}</td>
                                <td>
                                    <c:if test="${report.status eq 1}">
                                        <span class="status pending">처리대기</span>
                                    </c:if>
                                    <c:if test="${report.status eq 0}">
                                        <span class="status completed">처리완료</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </section>

        <section class="main-panel">
            <div class="panel-header">
                <h3>MBTI별 사용자 분포</h3>
            </div>
            <div class="panel-content">
                <canvas id="mbtiChart" style="max-height: 400px;"></canvas>
            </div>
        </section>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const stats = ${statsJson};
            if (stats && stats.length > 0) {
                const mbtiStats = stats[0];

                const ctx = document.getElementById('mbtiChart').getContext('2d');

                new Chart(ctx, {
                    type: mbtiStats.type,
                    data: {
                        labels: mbtiStats.labels,
                        datasets: [{
                            label: mbtiStats.label,
                            data: mbtiStats.data,
                            backgroundColor: mbtiStats.backgroundColors,
                            borderColor: mbtiStats.borderColors,
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: {
                                    color: 'rgba(0, 0, 0, 0.1)'
                                },
                                ticks: {
                                    color: 'rgba(0, 0, 0, 0.8)'
                                }
                            },
                            x: {
                                grid: {
                                    color: 'rgba(0, 0, 0, 0.1)'
                                },
                                ticks: {
                                    color: 'rgba(0, 0, 0, 0.8)'
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                display: false, // 범례 숨김
                            },
                            title: {
                                display: true,
                                text: mbtiStats.title,
                                color: 'rgba(0, 0, 0, 0.8)',
                                font: {
                                    size: 16
                                }
                            }
                        }
                    }
                });
            }
        });
    </script>
</body>
</html>
