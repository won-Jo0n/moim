<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>차트 시각화</title>
    <link rel="stylesheet" href="../resources/css/chart.css"
</head>
<body>

<div id="chartArea" class="chart-container">
    <h2>통계 차트</h2>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const statsList = JSON.parse('${statsJson}');
    const chartArea = document.getElementById('chartArea');

    statsList.forEach((chartData, index) => {
        // 차트 래퍼
        const chartBlock = document.createElement('div');
        chartBlock.className = 'chart-block';

        // 헤더 + 드롭다운 버튼
        const chartHeader = document.createElement('div');
        chartHeader.className = 'chart-header';
        chartHeader.innerHTML = `
            ${chartData.title}
            <span class="toggle-icon">&#9660;</span>
        `;
        chartBlock.appendChild(chartHeader);

        // 차트 콘텐츠 (캔버스)
        const chartContent = document.createElement('div');
        chartContent.className = 'chart-content';
        const canvas = document.createElement('canvas');
        canvas.id = 'chart-' + index;
        chartContent.appendChild(canvas);
        chartBlock.appendChild(chartContent);
        chartArea.appendChild(chartBlock);

        // 토글 기능
        chartHeader.addEventListener('click', () => {
            chartBlock.classList.toggle('open');
        });

        // 차트 그리기
        const ctx = canvas.getContext('2d');
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
                        display: false
                    },
                    legend: {
                        display: true,
                        position: chartData.type === 'pie' ? 'bottom' : 'top'
                    }
                },
                scales: chartData.type === 'bar' || chartData.type === 'line' ? {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            precision: 0
                        }
                    }
                } : {}
            }
        });
    });
</script>


</body>
</html>
