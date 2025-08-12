document.addEventListener("DOMContentLoaded", () => {
    $.ajax({
        type : "get",
        url : "/homeFeed/getFeedList",
        contentType : "application/json",
        success : function(data){
            data.forEach(post => {
                createPostItem(post);
            });
        },error : function(xhr, status, error, err){
            console.log(err);
        }
    });
    /*
    const loadMorePosts = () => {
        loadingIndicator.classList.add("visible");
        // Simulate network delay
        setTimeout(() => {
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
    */
});

function createPostItem(post){
    const postContainer = $("#post-container");
    const postCard = $(`
        <div class="post-card" onclick="window.location.href='/mbti/board/detail/${post.id}'">
            <div class="post-header" onclick="event.stopPropagation();window.location.href='/profile/view/${post.author}'">
                <img class="post-avatar" src="/file/preview?fileId=${post.authorFileId}">
                <div class="user-info">
                    <span class="post-user">${post.authorNickName} (${post.mbti})</span>
                    ${post.isCompatible > 0 ? `<span class="compatibility-badge">나와 잘 맞을 수도 있는 사용자</span>` : ''}
                </div>
            </div>
            <img class="post-image" src="/file/preview?fileId=${post.fileId}"/>
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
                <button class="report-button">신고</button>
            </div>
            <div class="post-likes">조회수 ${post.hits}</div>
            <p class="post-caption">
                <span class="caption-user">${post.authorNickName}</span> ${post.content}
            </p>
            <div class="post-comments">${post.commentCount}개의 댓글이 있습니다.</div>
        </div>
    `);
    postContainer.append(postCard);
}