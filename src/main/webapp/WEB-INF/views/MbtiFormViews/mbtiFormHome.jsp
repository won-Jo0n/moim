<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>MBTI 결과</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap');

        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(to right, #dbeafe, #e0f2fe);
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        .result-container {
            background-color: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
            text-align: center;
            max-width: 500px;
            width: 90%;
        }

        h2 {
            font-size: 28px;
            color: #1e3a8a;
            margin-bottom: 20px;
        }

        .mbti-box {
            font-size: 36px;
            font-weight: bold;
            color: #3b82f6;
            margin-bottom: 30px;
            border: 3px dashed #3b82f6;
            padding: 20px;
            border-radius: 10px;
            background-color: #eff6ff;
        }

        .buttons {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .buttons a {
            text-decoration: none;
            background-color: #3b82f6;
            color: white;
            padding: 12px 18px;
            border-radius: 8px;
            font-weight: bold;
            transition: all 0.25s ease-in-out;
        }

        .buttons a:hover {
            background-color: #2563eb;
            transform: translateY(-2px);
        }

        @media (max-width: 480px) {
            h2 {
                font-size: 22px;
            }

            .mbti-box {
                font-size: 28px;
                padding: 16px;
            }

            .buttons a {
                padding: 10px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
<div class="result-container">
    <h2>당신의 MBTI는?</h2>
    <div class="mbti-box">${mbtiResult}</div>

    <div class="buttons">
        <a href="${pageContext.request.contextPath}/mbti/test">🔁 다시 검사하기</a>
        <a href="${pageContext.request.contextPath}/home">🏠 홈으로 이동</a>
        <a href="${pageContext.request.contextPath}/profile">👤 마이페이지</a>
    </div>
</div>
</body>
</html>
