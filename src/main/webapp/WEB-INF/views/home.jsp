<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>홈</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" />
    <link rel="stylesheet" href="/resources/css/home.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/resources/js/home.js"></script>
</head>
<body>
    <main id="post-container"></main>
    <div id="loading-indicator">
      <div class="loading-spinner"></div>
    </div>
    <button id="fixed-add-post-button" onclick="window.location.href='/mbti/board/write'">
        +
    </button>
    <script>
        const userMbtiId = "<c:out value="${sessionScope.mbtiId}"/>";

                document.addEventListener('DOMContentLoaded', function() {
                    if (userMbtiId === "0") {
                        showMbtiModal();
                    }
                });

                function showMbtiModal() {
                    const modalHTML = `
                        <div id="mbtiModal" class="modal-overlay">
                            <div class="modal-content">
                                <button class="modal-close-button" onclick="handleMbtiResponse('no')">&times;</button>
                                <h3>MBTI 검사를 하시면 더 많은 서비스 이용이<br>가능하십니다!</h3>
                                <p>검사하시겠습니까?</p>
                                <div class="modal-buttons">
                                    <button class="yes-button" onclick="handleMbtiResponse('yes')">검사하러가기</button>
                                </div>
                            </div>
                        </div>
                    `;
                    document.body.insertAdjacentHTML('beforeend', modalHTML);
                }

                function handleMbtiResponse(response) {
                    const modal = document.getElementById('mbtiModal');
                    if (response === 'yes') {
                        window.location.href = '/mbti/test';
                    }
                    modal.remove();
                }
    </script>
</body>
</html>