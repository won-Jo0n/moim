<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>차트 시각화</title>

    <!-- Chart.js CDN은 사용자(당신)가 연결한다 했으므로 여기선 생략 -->
    <style>
        .chart-container {
            width: 80%;
            margin: 40px auto;
        }
    </style>
</head>
<body>

<div class="chart-container">
    <h2>통계 차트</h2>
    <canvas id="chartCanvas"></canvas>
</div>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // 서버에서 전달된 JSON 문자열을 JS 객체로 파싱
    const statsList = JSON.parse('${statsJson}');

    // 예제에서는 하나의 차트만 있다고 가정
    const chartData = statsList[0];

    const ctx = document.getElementById('chartCanvas').getContext('2d');
    new Chart(ctx, {
        type: chartData.type,
        data: {
            labels: chartData.labels,
            datasets: [{
                label: chartData.label,
                data: chartData.data,
                backgroundColor: chartData.backgroundColors,
                borderColor: chartData.borderColors,
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            plugins: {
                title: {
                    display: true,
                    text: chartData.title,
                    font: {
                        size: 20
                    }
                },
                legend: {
                    display: true,
                    position: 'top'
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        precision: 0
                    }
                }
            }
        }
    });
</script>

</body>
</html>
