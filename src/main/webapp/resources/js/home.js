// script.js
document.addEventListener("DOMContentLoaded", () => {
    const mockPosts = [
        {
            id: 1,
            user: "traveler_kim",
            avatar: "https://placehold.co/100x100/A855F7/ffffff?text=TK",
            image: "https://placehold.co/600x600/DDAAFF/43118A?text=Post+1",
            caption: "바다가 너무 아름다워요! 🌊 #여행 #바다 #휴가",
            likes: 123,
            comments: 45,
        },
        {
            id: 2,
            user: "foodie_joo",
            avatar: "https://placehold.co/100x100/6B21A8/ffffff?text=FJ",
            image: "https://placehold.co/600x600/C084FC/ffffff?text=Post+2",
            caption: "이 카페 분위기 최고! ☕️ #카페스타그램 #일상 #커피",
            likes: 256,
            comments: 88,
        },
        {
            id: 3,
            user: "developer_lee",
            avatar: "https://placehold.co/100x100/A21CAF/ffffff?text=DL",
            image: "https://placehold.co/600x600/E8D2FF/43118A?text=Post+3",
            caption: "새로운 프로젝트 시작! 💻 #코딩 #개발자 #일상",
            likes: 99,
            comments: 32,
        },
        {
            id: 4,
            user: "art_lover_park",
            avatar: "https://placehold.co/100x100/4C007D/ffffff?text=AP",
            image: "https://placehold.co/600x600/F0E6FF/43118A?text=Post+4",
            caption: "새롭게 그린 그림이에요. 어떤가요? 🎨 #그림 #미술 #취미",
            likes: 312,
            comments: 110,
        },
        {
            id: 5,
            user: "gamer_yoon",
            avatar: "https://placehold.co/100x100/7E22CE/ffffff?text=GY",
            image: "https://placehold.co/600x600/D8B4FE/ffffff?text=Post+5",
            caption: "오늘 밤샘 게임! 🎮 #게임 #일상 #취미",
            likes: 154,
            comments: 67,
        },
    ];

    let postCounter = 0;
    const feedContainer = document.getElementById("feed-container");
    const loadingIndicator = document.getElementById("loading-indicator");

    // Function to create and append a single post card
    const createPostElement = (post) => {
        $.ajax({
            type : "get",
            url : "/homeFeed/getFeedList",
            contentType : "application/json",
            success : function(data){
              console.log("피드 불러오기 성공");
              console.log(data);
            },error : function(xhr, status, error, err){
                console.log("에러 발생!");
                console.log("상태 코드: " + xhr.status); // HTTP 상태 코드 (예: 404, 500)
                console.log("에러 메시지: " + error); // 에러 메시지 (예: Not Found, Internal Server Error)
                console.log("응답 본문: " + xhr.responseText); // 서버에서 보낸 응답 본문
                console.log(err);
            }
        });
        const postCard = document.createElement("div");
        postCard.classList.add("post-card");
        postCard.innerHTML = `
            <div class="post-header">
                <img class="post-avatar" src="${post.avatar}" alt="${post.user}'s avatar">
                <span class="post-user">${post.user}</span>
            </div>
            <img class="post-image" src="${post.image}" alt="Post by ${post.user}">
            <div class="post-actions">
                <div class="post-action-icons">
                    <svg xmlns="http://www.w3.org/2000/svg" class="action-icon" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
                    </svg>
                    <svg xmlns="http://www.w3.org/2000/svg" class="action-icon" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.14 9.14 0 01-2.914-.492M3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
                    </svg>
                    <svg xmlns="http://www.w3.org/2000/svg" class="action-icon" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
                    </svg>
                </div>
            </div>
            <div class="post-likes">조회수 ${post.likes}</div>
            <p class="post-caption">
                <span class="caption-user">${post.user}</span> ${post.caption}
            </p>
            <div class="post-comments">${post.comments}개의 댓글이 있습니다.</div>
        `;
        return postCard;
    };

    // Function to load more posts
    const loadMorePosts = () => {
        loadingIndicator.classList.add("visible");

        // Simulate network delay
        setTimeout(() => {
            const newPosts = mockPosts.map((post) => ({
                ...post,
                id: postCounter + post.id,
                image: `https://placehold.co/600x600/C${(Math.random() * 999).toFixed(0)}/ffffff?text=Post+${postCounter + post.id}`,
                likes: Math.floor(Math.random() * 500) + 50,
                comments: Math.floor(Math.random() * 100) + 10,
            }));

            newPosts.forEach((post) => {
                feedContainer.appendChild(createPostElement(post));
            });

            postCounter += newPosts.length;
            loadingIndicator.classList.remove("visible");
        }, 1000); // 1 second delay
    };
    loadMorePosts();
    window.addEventListener("scroll", () => {
        const { scrollTop, scrollHeight, clientHeight } = document.documentElement;
        if (scrollTop + clientHeight >= scrollHeight - 50) {
            if (!loadingIndicator.classList.contains("visible")) {
                loadMorePosts();
            }
        }
    });
});