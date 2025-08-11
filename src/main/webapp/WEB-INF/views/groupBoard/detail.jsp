<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>글 상세 페이지</title>
    <link rel="stylesheet" href="../resources/css/groupBoardDetail.css" >
</head>
<body>
<div class="page">
  <header class="page__header">
    <h2 class="page__title">글 상세</h2>
    <a class="link-back" href="/group/detail?groupId=${board.groupId}">← 목록으로</a>
  </header>

  <!-- 게시글 카드 -->
  <section class="card">
    <div class="post">
      <div class="post__header">
        <h3 class="post__title">${board.title}</h3>
        <div class="post__meta">
          <span class="badge">${board.authorNickName}</span>
          <span class="muted">조회수 ${board.hits}</span>
        </div>
      </div>

<div class="post__body-layout">
      <c:if test="${board.fileId ne 0}">
        <div class="post__media">
          <img src="/file/preview?fileId=${board.fileId}" alt="첨부 이미지">
        </div>
      </c:if>

      <div class="post__content">
        <p>${board.content}</p>
      </div>
   </div>


      <!-- 글 수정/삭제/신고 -->
      <div class="actions">
        <c:if test="${isAuthor}">
          <a class="btn btn--ghost" href="/groupboard/update?id=${board.id}">게시글 수정</a>
          <form action="/groupboard/delete" method="post" onsubmit="return confirm('삭제하시겠습니까?');" class="inline-form">
            <input type="hidden" name="id" value="${board.id}">
            <input type="hidden" name="groupId" value="${board.groupId}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <input type="submit" class="btn btn--danger" value="게시글 삭제">
          </form>
        </c:if>
        <a class="btn btn--ghost" href="/report/?reportUser=${sessionScope.userId}&reportedUser=${board.author}&type=groupboard&boardId=${board.id}">
          신고하기
        </a>
      </div>
    </div>
  </section>

  <!-- 댓글 섹션 -->
  <section class="card">
    <h3 class="card__title">댓글</h3>

    <div class="comment-section">
      <c:forEach var="comment" items="${commentList}">
        <c:if test="${comment.parentId == 0}">
          <!-- 부모 댓글 -->
          <div class="comment" id="comment-${comment.id}">
            <div class="comment__meta">
              <span class="badge">${comment.authorNickName}</span>
              <span class="muted"><fmt:formatDate value="${comment.createdAt}" pattern="yyyy-MM-dd HH:mm" /></span>
            </div>

            <div class="comment__content" id="content-${comment.id}">
              ${comment.content}
            </div>

            <div class="actions actions--compact">
              <c:if test="${sessionScope.userId == comment.author}">
                <!-- 수정 -->
                <button type="button" class="btn btn--ghost" onclick="toggleEdit(${comment.id})">수정</button>
                <!-- 삭제 -->
                <form action="/groupboardcomment/delete" method="post" class="inline-form" onsubmit="return confirm('삭제하시겠습니까?');">
                  <input type="hidden" name="id" value="${comment.id}" />
                  <input type="hidden" name="boardId" value="${board.id}" />
                  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                  <button type="submit" class="btn btn--danger">삭제</button>
                </form>
              </c:if>
              <!-- 대댓글 -->
              <button type="button" class="btn btn--primary" onclick="toggleReplyForm(${comment.id})">대댓글</button>
            </div>


            <!-- 댓글 수정 폼 -->
            <form id="edit-form-${comment.id}" action="/groupboardcomment/update" method="post" class="edit-form" style="display:none;">
              <input type="hidden" name="id" value="${comment.id}" />
              <input type="hidden" name="boardId" value="${board.id}" />
              <textarea name="content" class="textarea">${comment.content}</textarea>
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
              <div class="actions actions--compact">
                <button type="submit" class="btn btn--primary">수정 완료</button>
              </div>
            </form>

            <!-- 대댓글 작성 폼 -->
            <form id="reply-form-${comment.id}" class="reply-form" action="/groupboardcomment/create" method="post" style="display:none;">
              <input type="hidden" name="groupId" value="${board.groupId}" />
              <input type="hidden" name="boardId" value="${board.id}" />
              <input type="hidden" name="parentId" value="${comment.id}" />
              <input type="hidden" name="depth" value="1" />
              <textarea name="content" class="textarea" placeholder="대댓글을 입력하세요" required></textarea>
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
              <div class="actions actions--compact">
                <input type="submit" class="btn btn--primary" value="작성" />
              </div>
            </form>

            <!-- 대댓글 리스트 -->
            <c:forEach var="reply" items="${commentList}">
              <c:if test="${reply.parentId == comment.id}">
                <div class="reply" id="comment-${reply.id}">
                  <div class="comment__meta">
                    <span class="badge">${reply.authorNickName}</span>
                    <span class="muted"><fmt:formatDate value="${reply.createdAt}" pattern="yyyy-MM-dd HH:mm" /></span>
                  </div>

                  <div class="comment__content" id="content-${reply.id}">
                    ${reply.content}
                  </div>

                  <div class="actions actions--compact">
                    <c:if test="${sessionScope.userId == reply.author}">
                      <!-- 수정 -->
                      <button type="button" class="btn btn--ghost" onclick="toggleEdit(${reply.id})">수정</button>
                      <!-- 삭제 -->
                      <form action="/groupboardcomment/delete" method="post" class="inline-form" onsubmit="return confirm('삭제하시겠습니까?');">
                        <input type="hidden" name="id" value="${reply.id}" />
                        <input type="hidden" name="boardId" value="${board.id}" />
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button type="submit" class="btn btn--danger">삭제</button>
                      </form>
                    </c:if>
                  </div>

                  <!-- 대댓글 수정 폼 -->
                  <form id="edit-form-${reply.id}" action="/groupboardcomment/update" method="post" class="edit-form" style="display:none;">
                    <input type="hidden" name="id" value="${reply.id}" />
                    <input type="hidden" name="boardId" value="${board.id}" />
                    <textarea name="content" class="textarea">${reply.content}</textarea>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <div class="actions actions--compact">
                      <button type="submit" class="btn btn--primary">수정 완료</button>
                    </div>
                  </form>
                </div>
              </c:if>
            </c:forEach>
          </div>
        </c:if>
      </c:forEach>
    </div>

    <!-- 댓글 입력 폼 -->
    <form class="comment-form" action="/groupboardcomment/create" method="post">
      <input type="hidden" name="groupId" value="${board.groupId}" />
      <input type="hidden" name="boardId" value="${board.id}" />
      <input type="hidden" name="parentId" value="0" />
      <input type="hidden" name="depth" value="0" />
      <textarea name="content" class="textarea" placeholder="댓글을 입력하세요" required></textarea>
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
      <div class="actions">
        <button type="submit" class="btn btn--primary">댓글 작성</button>
      </div>
    </form>
  </section>
</div>

<script>
  function toggleReplyForm(id) {
    const form = document.getElementById('reply-form-' + id);
    form.style.display = (form.style.display === 'none' || !form.style.display) ? 'block' : 'none';
  }
  function toggleEdit(id) {
    const form = document.getElementById('edit-form-' + id);
    form.style.display = (form.style.display === 'none' || !form.style.display) ? 'block' : 'none';
  }
</script>
</body>
</html>