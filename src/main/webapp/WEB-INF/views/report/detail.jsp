<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>신고 상세</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../resources/css/reportDetail.css">
    <link rel="stylesheet" href="../resources/css/admin.css">
</head>
<body>
    <%@ include file="../admin/adminSidebar.jsp" %>
    <div class="report-container">
        <div class="section">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <h2>신고 상세</h2>
                <span class="meta-text">신고번호: ${report.id}</span>
            </div>
            <span class="meta-text">신고 일자: ${reportedTime}</span>
        </div>

        <div class="section user-info-group">
            <div class="user-info">
                <span class="role">신고자</span>
                <p>${reportUser.nickName}</p>
            </div>
            <div style="color: #333333; font-size: 24px;">➡</div>
            <div class="user-info">
                <span class="role">피신고자</span>
                <p>${reportedUser.nickName}</p>
            </div>
        </div>

        <div class="section">
            <h3>신고 제목</h3>
            <p>${report.title}</p>

            <h3 style="margin-top: 16px;">신고 내용</h3>
            <div class="content-box">
                <p>${report.content}</p>
            </div>
        </div>

        <div class="section" style="text-align: center;">
            <a class="action-link" href="/${report.type}/detail?id=${report.boardId}">
                신고된 페이지로 이동
            </a>
        </div>
    </div>
</body>
</html>