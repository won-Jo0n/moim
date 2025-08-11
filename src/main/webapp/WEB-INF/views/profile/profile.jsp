<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
    <title>${profile.nickname}님의 마이페이지</title>
    <style>
        body {
            margin: 0;
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f5f6fa;
        }
        .container {
            max-width: 900px;
            margin: 40px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.08);
            padding: 20px;
        }
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .menu-btn {
            font-size: 22px;
            background: none;
            border: none;
            cursor: pointer;
        }
        .dropdown {
            position: absolute;
            right: 50px;
            top: 80px;
            display: none;
            background: white;
            border: 1px solid #ccc;
            padding: 10px;
            border-radius: 6px;
            z-index: 10;
        }
        .dropdown a {
            display: block;
            padding: 5px 10px;
            text-decoration: none;
            color: #333;
        }

        .profile-section {
            text-align: center;
            margin-top: 30px;
        }
        .profile-section img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            background: #eee;
        }
        .profile-section h2 {
            margin: 10px 0 5px;
        }
        .badge {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 20px;
            background: #e0caff;
            color: #6639a6;
            font-size: 13px;
        }
        .rating {
            color: #f5c518;
            font-size: 18px;
            margin-top: 5px;
        }

        .tabs {
            display: flex;
            margin-top: 30px;
            border-bottom: 2px solid #eee;
        }
        .tab {
            flex: 1;
            text-align: center;
            padding: 12px;
            cursor: pointer;
            font-weight: bold;
            color: #666;
        }
        .tab.active {
            border-bottom: 3px solid #2e86de;
            color: #2e86de;
        }

        .section {
            display: none;
            padding: 20px 0;
        }
        .section.active {
            display: block;
        }

        .card {
            display: flex;
            margin-bottom: 20px;
            background: #fafafa;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            cursor: pointer;
        }
        .card img {
            width: 150px;
            height: 100%;
            object-fit: cover;
        }
        .card-body {
            padding: 15px;
            flex: 1;
        }
        .card-body h4 {
            margin: 0;
            font-size: 16px;
            font-weight: bold;
        }
        .card-body p {
            margin: 8px 0;
            color: #444;
            font-size: 14px;
        }
        .card-body .meta {
            font-size: 12px;
            color: #aaa;
        }

        .friend-list {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 20px;
        }
        .friend-card {
            flex: 1 1 calc(33.33% - 10px);
            text-align: center;
            background: #f1f1f1;
            border-radius: 10px;
            padding: 15px;
        }
        .friend-card:hover {
            background: #ddd;
        }

        .empty-msg {
            text-align: center;
            color: #999;
            margin-top: 30px;
            font-size: 15px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="top-bar">
        <a href="/home">← 돌아가기</a>
        <c:if test="${sessionScope.userId == profile.userId}">
            <button class="menu-btn" onclick="toggleMenu()">☰</button>
        </c:if>
        <div class="dropdown" id="menu">
            <a href="${pageContext.request.contextPath}/profile/profile/update">수정</a>
            <a href="user/logout">로그아웃</a>
        </div>
    </div>

    <div class="profile-section">
        <img src="/img/default-profile.png" alt="프로필 이미지">
        <h2>${profile.nickname}</h2>
        <span class="badge">${profile.mbti}</span>

        <!-- 별점 -->
        <div class="rating">
            <c:forEach begin="1" end="5" var="i">
                <c:choose>
                    <c:when test="${i <= profile.rating}">★</c:when>
                    <c:otherwise>☆</c:otherwise>
                </c:choose>
            </c:forEach>
        </div>

        <!-- 친구 요청 버튼: 본인 페이지가 아닐 때만 -->
        <c:if test="${sessionScope.userId ne profile.userId}">
            <button id="friendBtn" data-target="${profile.userId}" onclick="toggleFriendRequest(this)">
                친구 요청
            </button>
        </c:if>
    </div>

    <div class="tabs">
        <div class="tab active" data-target="posts">📝 작성 글</div>
        <div class="tab" data-target="friends">👥 친구 목록</div>
    </div>

    <!-- 작성 글 -->
    <div class="section active" id="posts">
        <c:forEach var="board" items="${boardList}">
            <div class="card" onclick="location.href='/mbti/board/detail/${board.id}'">
                <c:choose>
                    <c:when test="${not empty board.fileId}">
                        <img src="/file/preview?fileId=${board.fileId}" alt="썸네일" onerror="this.src='/resources/images/default-thumb.jpg'">
                    </c:when>
                    <c:otherwise>
                        <img src="/resources/images/default-thumb.jpg" alt="기본 썸네일">
                    </c:otherwise>
                </c:choose>
                <div class="card-body">
                    <h4>${board.title}</h4>
                    <p>${fn:substring(board.content, 0, 50)}...</p>
                    <div class="meta">${board.formattedCreatedAt}</div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- 친구 목록 -->
    <div class="section" id="friends">
        <c:if test="${empty friendList}">
            <div class="empty-msg">친구가 없어요 😢<br>친구를 추가해보세요!</div>
        </c:if>
        <div class="friend-list">
            <c:forEach var="friend" items="${friendList}">
                <div class="friend-card" onclick="location.href='/profile/view/${friend.userId}'">
                    <div>👤</div>
                    <div>${friend.nickname}</div>
                    <div>${friend.mbti}</div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const tabs = document.querySelectorAll('.tab');
        const sections = document.querySelectorAll('.section');

        tabs.forEach(tab => {
            tab.addEventListener('click', () => {
                tabs.forEach(t => t.classList.remove('active'));
                sections.forEach(s => s.classList.remove('active'));

                tab.classList.add('active');
                const targetId = tab.getAttribute('data-target');
                document.getElementById(targetId).classList.add('active');
            });
        });
    });

    function toggleMenu() {
        const menu = document.getElementById('menu');
        menu.style.display = menu.style.display === 'block' ? 'none' : 'block';
    }

    function toggleFriendRequest(btn){
        const targetId = btn.getAttribute("data-target");
        const isRequesting = btn.textContent.trim() === "친구 요청";

        const url = isRequesting
            ? '${pageContext.request.contextPath}/friends/request'
            : '${pageContext.request.contextPath}/friends/cancel';

        const payload = { responseUserId: targetId };

        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': '${_csrf.token}'
            },
            body: JSON.stringify(payload)
        })
        .then(res => {
            if(res.ok){
                btn.textContent = isRequesting ? "친구 요청 취소" : "친구 요청";
            } else {
                alert("요청 처리 실패");
            }
        })
        .catch(err => console.error(err));
    }
</script>
</body>
</html>
