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
                <button class="report-button" onclick="event.stopPropagation();window.location.href='/report/?reportedUser=${post.author}&type=mbti&boardId=${post.id}'">신고</button>
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