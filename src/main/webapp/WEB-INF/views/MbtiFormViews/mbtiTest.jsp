<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>MBTI 성향 테스트</title>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            margin: 0;
            padding: 40px;
            background: #f5f6fa;
        }

        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.1);
        }

        .question-box {
            display: none;
        }

        .question-box.active {
            display: block;
        }

        .question-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .option {
            display: block;
            padding: 12px;
            margin: 10px 0;
            background: #ecf0f1;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .option:hover {
            background: #dcdde1;
        }

        .option.selected {
            background: #3498db;
            color: white;
        }

        .navigation {
            margin-top: 20px;
            text-align: right;
        }

        .next-btn {
            padding: 10px 20px;
            background: #2ecc71;
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .next-btn:hover {
            background: #27ae60;
        }

        .progress {
            height: 8px;
            background: #ecf0f1;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 20px;
        }

        .progress-bar {
            height: 100%;
            background: #3498db;
            width: 0%;
            transition: width 0.3s;
        }
        .prev-btn {
            padding: 10px 20px;
            background: #bdc3c7;
            color: #2c3e50;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            margin-right: 10px;
            transition: background-color 0.2s;
            text-decoration: none;
        }

        .prev-btn:hover {
            background: #95a5a6;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>MBTI 성향 테스트</h2>
    <div class="progress"><div class="progress-bar" id="progressBar"></div></div>

    <form action="${pageContext.request.contextPath}/mbti/submit" method="post" id="mbtiForm">
        <c:forEach var="question" items="${questions}" varStatus="status">
            <div class="question-box <c:if test='${status.index == 0}'>active</c:if>" data-index="${status.index}">
                <p class="question-title">Q${status.index + 1}. ${question.question}</p>
                <div class="navigation">
                    <button type="button" class="prev-btn">이전</button>
                    <a href="${pageContext.request.contextPath}/profile" class="prev-btn">마이페이지로 돌아가기</a>
                </div>
                <div class="option" data-value="0">전혀</div>
                <div class="option" data-value="1">때때로</div>
                <div class="option" data-value="2">그렇다</div>
                <div class="option" data-value="3">주로그렇다</div>
                <div class="option" data-value="4">매우그렇다</div>

                <input type="hidden" name="answers${status.index}" id="answer-${status.index}" />

                <div class="navigation">
                    <button type="button" class="next-btn">다음</button>
                </div>
            </div>
        </c:forEach>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>
</div>

<script>
    const questions = document.querySelectorAll('.question-box');
    const progressBar = document.getElementById('progressBar');
    let current = 0;

    questions.forEach((qBox, idx) => {
        const options = qBox.querySelectorAll('.option');
        const input = qBox.querySelector(`input[type=hidden]`);

        options.forEach(opt => {
            opt.addEventListener('click', () => {
                options.forEach(o => o.classList.remove('selected'));
                opt.classList.add('selected');
                input.value = opt.getAttribute('data-value');
            });
        });

        const nextBtn = qBox.querySelector('.next-btn');
        nextBtn.addEventListener('click', () => {
            if (input.value === "") {
                alert("옵션을 선택해주세요!");
                return;
            }
            qBox.classList.remove('active');
            if (idx + 1 < questions.length) {
                questions[idx + 1].classList.add('active');
                updateProgress(idx + 1, questions.length);
            } else {
                document.getElementById("mbtiForm").submit();
            }
        });
    });

    function updateProgress(currentIndex, total) {
        const percent = Math.floor((currentIndex / total) * 100);
        progressBar.style.width = percent + "%";
    }
    const prevBtns = document.querySelectorAll('.prev-btn');

    prevBtns.forEach((btn, idx) => {
        btn.addEventListener('click', () => {
            if (idx > 0) {
                questions[idx].classList.remove('active');
                questions[idx - 1].classList.add('active');
                updateProgress(idx - 1, questions.length);
            }
        });
    });
</script>
</body>
</html>
