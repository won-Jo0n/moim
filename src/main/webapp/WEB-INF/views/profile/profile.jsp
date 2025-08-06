<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>${profile.nickname}님의 마이페이지</title>
    <style>
    /* 전체 페이지 레이아웃 */
    .profile-page {
        max-width: 900px;
        margin: 0 auto;
        padding: 20px;
        font-family: 'Noto Sans KR', sans-serif;
        background-color: #f7f9fc;
    }

    /* 상단 네비게이션 */
    .top-bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
    }

    .back-button {
        text-decoration: none;
        color: #007BFF;
        font-weight: bold;
        font-size: 16px;
    }

    .hamburger-menu button {
        margin-left: 10px;
        background: none;
        border: none;
        color: #333;
        font-size: 14px;
        cursor: pointer;
    }

    .hamburger-menu button:hover {
        color: #000;
        font-weight: bold;
    }

    /* 프로필 카드 */
    .profile-card {
        display: flex;
        align-items: center;
        background: #fff;
        padding: 25px;
        border-radius: 12px;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
        margin-bottom: 30px;
    }

    .profile-photo img {
        width: 100px;
        height: 100px;
        border-radius: 100%;
        object-fit: cover;
        margin-right: 20px;
        border: 2px solid #ddd;
    }

    .profile-text h2 {
        margin: 0 0 6px 0;
        font-size: 22px;
        font-weight: bold;
    }

    .mbti-tag {
        display: inline-block;
        background: #e4f0ff;
        color: #0066cc;
        padding: 4px 10px;
        border-radius: 20px;
        font-size: 13px;
        margin-bottom: 10px;
    }

    .rating-label {
        font-size: 14px;
        color: #555;
        margin-bottom: 4px;
    }

    .star-rating {
        color: #ffc107;
        font-size: 16px;
    }

    .rating-value {
        color: #333;
        margin-left: 6px;
        font-size: 14px;
    }

    /* 탭 메뉴 */
    .tab-menu {
        display: flex;
        justify-content: center;
        margin-bottom: 20px;
        gap: 8px;
    }

    .tab-menu button {
        flex: 1;
        padding: 10px 0;
        background-color: #e0e7ff;
        border: none;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        border-radius: 10px;
        transition: 0.2s ease;
        color: #333;
    }

    .tab-menu .active {
        background-color: #3b82f6;
        color: white;
    }

    /* 게시글 카드 리스트 */
    .post-list {
        display: flex;
        flex-direction: column;
        gap: 20px;
    }

    .post-card {
        display: flex;
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
        overflow: hidden;
        cursor: pointer;
        transition: transform 0.2s ease;
    }

    .post-card:hover {
        transform: translateY(-2px);
    }

    .post-image img {
        width: 140px;
        height: 100%;
        object-fit: cover;
    }

    .post-content {
        padding: 15px;
        flex-grow: 1;
    }

    .post-content h4 {
        font-size: 18px;
        margin: 0 0 8px;
    }

    .content-preview {
        font-size: 14px;
        color: #555;
        margin-bottom: 10px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .post-meta {
        display: flex;
        justify-content: flex-start;
        gap: 16px;
        font-size: 13px;
        color: #888;
    }

    </style>
</head>
<body>
<div class="profile-page">
    <!-- 상단 뒤로가기 & 햄버거 메뉴 -->
    <div class="top-bar">
        <a href="/home" class="back-button">← 돌아가기</a>
        <c:if test="${sessionScope.userId eq profile.userId}">
            <div class="hamburger-menu">
                <button onclick="location.href='/ProfileEdit'">수정</button>
                <button onclick="location.href='/profile/delete'">삭제</button>
            </div>
        </c:if>
    </div>

    <!-- 프로필 카드 -->
    <div class="profile-card">
        <div class="profile-photo">
            <img src="/images/default-profile.png" alt="프로필 사진"/>
        </div>
        <div class="profile-text">
            <h2>${profile.nickname}</h2>
            <span class="mbti-tag">${profile.mbti}</span>
            <p class="rating-label">모임 평점</p>
            <p class="star-rating">
                <c:forEach var="i" begin="1" end="5">
                    <c:choose>
                        <c:when test="${i <= profile.rating}">★</c:when>
                        <c:otherwise>☆</c:otherwise>
                    </c:choose>
                </c:forEach>
                <span class="rating-value">(${profile.rating}/5)</span>
            </p>
        </div>
    </div>

    <!-- 탭 메뉴 -->
    <div class="tab-menu">
        <button id="tab-posts" class="active" onclick="showTab('posts')">작성 글</button>
        <button id="tab-friends" onclick="showTab('friends')">친구 목록</button>
    </div>

    <!-- 게시글 목록 -->
    <div id="posts-tab" class="post-list">
        <c:forEach var="board" items="${boardList}">
           <div class="post-card" onclick="location.href='/profile/board/${board.id}'">
                <div class="post-image">
                    <img src="/images/sample-post.jpg" alt="썸네일">
                </div>
                <div class="post-content">
                    <h4>${board.title}</h4>
                    <p class="content-preview">${board.content}</p>
                    <div class="post-meta">
                        <span class="date">${board.formattedCreatedAt}</span>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- 친구 목록 탭 -->
    <div id="friends-tab" class="post-list" style="display:none;">
        <c:choose>
            <c:when test="${empty friends}">
                <p style="text-align:center; color:#888; margin-top:30px;">
                    아직 친구가 없습니다.<br>요청을 눌러 친구 신청을 해보세요!
                </p>
            </c:when>
            <c:otherwise>
                <c:forEach var="friend" items="${friends}">
                    <div class="post-card" onclick="location.href='/profile/${friend.userId}'">
                        <div class="post-image">
                            <img src="/images/default-profile.png" alt="친구 프로필">
                        </div>
                        <div class="post-content">
                            <h4>${friend.nickname}</h4>
                            <p class="content-preview">${friend.mbti} / ${friend.mbtiDesc}</p>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<script>
    function showTab(tabName) {
        document.getElementById('posts-tab').style.display = (tabName === 'posts') ? 'block' : 'none';
        document.getElementById('friends-tab').style.display = (tabName === 'friends') ? 'block' : 'none';

        document.getElementById('tab-posts').classList.toggle('active', tabName === 'posts');
        document.getElementById('tab-friends').classList.toggle('active', tabName === 'friends');
    }
</script>
</body>
</html>