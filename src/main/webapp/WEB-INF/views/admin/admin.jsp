<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 대시보드</title>
    <link rel="stylesheet" href="../resources/css/admin.css">
</head>
<body>
<header>
    관리자 대시보드
</header>
<nav>
    <a href="/admin/report">신고 내역</a>
    <a href="/admin/chart">MBTI 통계</a>
    <a href="/admin/penalties">사용자 제재</a>
</nav>

<div class="container">
    <div class="card" id="reports">
        <h3>신고 내역 확인</h3>
        <div class="placeholder">신고 리스트 테이블 자리</div>
    </div>

    <div class="card" id="stats">
        <h3>MBTI별 통계</h3>
        <ul>
            <li>댓글 수 상위 MBTI</li>
            <li>모임 활동 많은 MBTI</li>
            <li>리뷰 점수 높은 MBTI</li>
            <li>최근 활동 급증 MBTI</li>
            <li>가입자 수 분포</li>
        </ul>
        <div class="placeholder">차트 영역</div>
    </div>

    <div class="card" id="penalties">
        <h3>사용자 제재하기</h3>
        <div class="placeholder">제재 대상 사용자 목록/버튼</div>
    </div>
</div>

</body>
</html>
