<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>관리자 통계 대시보드</title>

    <!-- AdminLTE CSS와 스크립트 경로가 올바른지 다시 확인해주세요. -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='../resources/css/adminlte.min.css'/>">
    <style>
        .chart-container {
            height: 300px;
            width: 100%;
        }
    </style>
</head>
<body class="hold-transition sidebar-mini">
<div class="wrapper">
    <div class="content-wrapper" style="min-height: 100vh; padding: 20px;">
        <div class="container-fluid">
            <div class="row">
                <!-- JSTL forEach를 사용하여 통계 자료 개수만큼 차트 카드를 동적으로 생성 -->
                <c:forEach var="stat" items="${statsList}" varStatus="status">
                    <div class="col-md-6">
                        <div class="card card-primary card-outline">
                            <div class="card-header">
                                <h3 class="card-title">${stat.title}</h3>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <!-- 각 차트에 고유한 ID를 부여 -->
                                    <canvas id="chart-${status.index}" style="height: 300px;"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<!-- REQUIRED SCRIPTS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="<c:url value='../resources/plugins/bootstrap.bundle.min.js'/>"></script>
<script src="<c:url value='../resources/plugins/Chart.min.js'/>"></script>
<script src="<c:url value='../resources/plugins/adminlte.min.js'/>"></script>

<script>
    $(function () {
        // 컨트롤러에서 JSON 문자열로 넘어온 모든 통계 데이터를 파싱
        const statsList = JSON.parse('${statsJson}');

        if (statsList && statsList.length > 0) {
            // statsList 배열을 순회하며 각 통계 데이터에 대해 차트 생성
            statsList.forEach((stat, index) => {
                // 고유한 ID를 가진 canvas 요소를 선택
                const chartCanvas = $(`#chart-${index}`).get(0).getContext('2d');

                // 차트 타입, 라벨, 데이터 등은 stat 객체에서 동적으로 가져옴
                const chartData = {
                    labels: stat.labels,
                    datasets: [{
                        label: stat.label,
                        data: stat.data,
                        backgroundColor: stat.backgroundColors,
                        borderColor: stat.borderColors,
                        borderWidth: 1
                    }]
                };

                const chartOptions = {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                };

                new Chart(chartCanvas, {
                    type: stat.type, // bar, doughnut, pie 등 DTO에 정의된 타입 사용
                    data: chartData,
                    options: chartOptions
                });
            });
        }
    });
</script>
</body>
</html>
