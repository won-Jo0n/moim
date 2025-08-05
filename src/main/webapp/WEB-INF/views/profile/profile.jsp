<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
    <title>마이페이지</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/profile.css">
    <script>
        window.addEventListener('DOMContentLoaded', () => {
            const toggleBtn = document.getElementById('toggleBtn');
            const infoSection = document.getElementById('infoSection');
            const postSection = document.getElementById('postSection');
            let showingInfo = true;

            const swapView = () => {
                if (showingInfo) {
                    infoSection.classList.add('hidden');
                    postSection.classList.remove('hidden');
                    toggleBtn.textContent = '내 정보 보기';
                } else {
                    postSection.classList.add('hidden');
                    infoSection.classList.remove('hidden');
                    toggleBtn.textContent = '작성 글 보기';
                }
                showingInfo = !showingInfo;
            };

            toggleBtn.addEventListener('click', swapView);

            // 초기화
            infoSection.classList.remove('hidden');
            postSection.classList.add('hidden');
        });
    </script>

</head>
<body>
<div class="container">
    <h1>${profile.nickName}님의 마이페이지</h1>

    <!-- 단일 버튼 -->
    <button id="toggleBtn">작성 글 보기</button>

    <!-- 내 정보 영역 -->
    <div id="infoSection" class="tab-content user-info">
        <p><strong>MBTI:</strong> ${profile.mbti}</p>
        <p><strong>가입일:</strong>
            ${fn:substringBefore(profile.joinedAt, "T")} ${fn:substring(profile.joinedAt, 11, 16)}
        </p>
        <p><strong>등급:</strong> ${profile.grade} (${profile.rating}점)</p>
        <p><strong>포인트:</strong> ${profile.point}점</p>
    </div>

    <!-- 내가 쓴 글 영역 -->
    <div id="postSection" class="tab-content hidden">
        <h3>내가 쓴 MBTI 게시글</h3>
        <c:choose>
            <c:when test="${not empty myPosts}">
                <ul class="post-list">
                    <c:forEach var="post" items="${myPosts}">
                        <li>
                            <a href="/mbti/board/detail/${post.id}">
                                [${post.id}] ${post.title}
                            </a>
                            <small>
                                ${fn:substringBefore(post.createdAt, "T")} ${fn:substring(post.createdAt, 11, 16)}
                            </small>
                        </li>
                    </c:forEach>
                </ul>
            </c:when>
            <c:otherwise>
                <p>작성한 게시글이 없습니다.</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
