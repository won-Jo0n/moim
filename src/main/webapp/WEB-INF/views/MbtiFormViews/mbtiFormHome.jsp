<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>MBTI 결과</title>
    <style>
        :root{
            --paper:#ffffff;
            --bg:#f5f6fa;

            /* Purple theme */
            --brand:#7E57C2;   /* Purple */
            --brand-2:#5E35B1; /* Royal Purple */
            --brand-3:#4527A0; /* Deep Purple */

            --text:#333;
            --muted:#faf8ff;
            --line:#e6e3f2;
        }

        @keyframes gradientShift {
            0%{background-position:0% 50%}
            50%{background-position:100% 50%}
            100%{background-position:0% 50%}
        }

        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;

            /* 퍼플 테마 배경 */
            background:
              linear-gradient(180deg, rgba(203,170,203,.12), rgba(177,143,207,.12)),
              var(--bg);
        }

        .result-container {
            background-color: var(--paper);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 8px 24px rgba(94,53,177,.15);
            text-align: center;
            max-width: 500px;
            width: 90%;
        }

        h2 {
            font-size: 28px;
            color: var(--brand-2);
            margin-bottom: 20px;
            font-weight: 800;
        }

        .mbti-box {
            font-size: 36px;
            font-weight: 800;
            color: var(--brand);
            margin-bottom: 30px;
            border: 3px dashed var(--brand);
            padding: 20px;
            border-radius: 12px;
            background: var(--muted);
        }

        .buttons {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .buttons a {
            text-decoration: none;
            color: #fff;
            padding: 12px 18px;
            border-radius: 10px;
            font-weight: 800;
            border: 0;
            /* 퍼플 그라데이션 버튼 */
            background-image: linear-gradient(90deg, var(--brand), var(--brand-2), var(--brand-3));
            background-size: 200% 200%;
            animation: gradientShift 8s linear infinite;
            box-shadow: 0 8px 20px rgba(94,53,177,.20);
            transition: transform .12s ease, box-shadow .18s ease, filter .18s ease;
        }

        .buttons a:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 28px rgba(94,53,177,.25);
            filter: brightness(1.02);
        }

        @media (max-width: 480px) {
            h2 { font-size: 22px; }
            .mbti-box { font-size: 28px; padding: 16px; }
            .buttons a { padding: 10px; font-size: 14px; }
        }
    </style>
</head>
<body>
<div class="result-container">
    <h2>당신의 MBTI는?</h2>
    <div class="mbti-box">${mbtiResult}</div>

    <div class="buttons">
        <a href="${pageContext.request.contextPath}/mbti/test"> 다시 검사하기</a>
        <a href="${pageContext.request.contextPath}/home"> 홈으로 이동</a>
        <a href="${pageContext.request.contextPath}/profile"> 마이페이지</a>
    </div>
</div>
</body>
</html>
