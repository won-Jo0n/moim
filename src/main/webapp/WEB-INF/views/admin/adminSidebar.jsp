<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="../resources/css/adminSidebar.css">
 <aside class="sidebar">
        <div class="logo">
            <h2>Admin</h2>
        </div>
        <nav class="main-nav">
            <a href="/admin/" class="${activeMenu == 'admin' ? 'active' : ''}">
                <i class="fa-solid fa-house"></i> 대시보드
            </a>
            <a href="/admin/report" class="${activeMenu == 'report' ? 'active' : ''}">
                <i class="fa-solid fa-flag"></i> 신고 관리
            </a>
            <a href="/admin/chart" class="${activeMenu == 'chart' ? 'active' : ''}">
                <i class="fa-solid fa-chart-line"></i> 통계 분석
            </a>
            <a href="/admin/penalties" class="${activeMenu == 'penalties' ? 'active' : ''}">
                <i class="fa-solid fa-users"></i> 사용자 관리
            </a>
        </nav>
</aside>
