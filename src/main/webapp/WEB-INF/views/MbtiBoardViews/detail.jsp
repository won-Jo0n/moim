<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html lang="ko">
<head>
  <title>게시글 상세</title>
  <meta name="${_csrf.parameterName}" content="${_csrf.token}"/>

  <style>
    :root{
      --lavender:#B18FCF; --purple:#7E57C2; --royal:#5E35B1; --deep:#4527A0;
      --bg:#F7F2FA; --paper:#fff; --ink:#1b1630; --muted:#7b7f95; --line:#ece6f5;
      --shadow-md:0 18px 40px rgba(69,39,160,.10); --shadow-sm:0 6px 18px rgba(69,39,160,.10);
      --r-xl:20px;
    }
    html,body{height:100%}
    body{
      margin:0; padding:60px 12px; display:flex; flex-direction:column; align-items:center;
      background:var(--bg); color:var(--ink);
      font-family: ui-sans-serif, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Noto Sans KR", Arial;
    }
    .wrap{
      width:600px; background:var(--paper); border-radius:var(--r-xl);
      box-shadow:var(--shadow-md); padding:28px 28px 36px;
      height:auto; max-height:none; overflow:visible;
    }
    /* 댓글 전용 컨테이너 */
    .comments-wrap{
      width:600px; background:var(--paper); border-radius:var(--r-xl);
      box-shadow:var(--shadow-md); padding:24px 24px 32px; margin-top:18px;
    }

    .top{display:flex; align-items:flex-start; justify-content:space-between; gap:12px; margin-bottom:8px}
    .title{margin:0; font-size:26px; line-height:1.35; color:var(--royal); word-break:break-word}
    .meta{margin:8px 0 16px; color:var(--muted); font-size:14px}

    .menu-btn{width:40px; height:40px; border:none; border-radius:12px; cursor:pointer; color:#fff;
      background:linear-gradient(90deg, var(--lavender), var(--royal), var(--deep));
      box-shadow:0 10px 26px rgba(69,39,160,.20)}
    .dropdown{position:fixed; display:none; z-index:2000; min-width:180px; padding:8px;
      background:var(--paper); border:1px solid var(--line); border-radius:12px; box-shadow:var(--shadow-md)}
    .dropdown a,.dropdown button{display:block; width:100%; text-align:left; padding:10px 12px; border:none; background:transparent; color:var(--ink); font-weight:700; border-radius:8px; cursor:pointer}
    .dropdown a:hover,.dropdown button:hover{background:rgba(193,168,211,.16)}

    .media{margin:12px 0 18px}
    .media img{width:100%; aspect-ratio:16/9; object-fit:cover; border-radius:16px; background:#efe8f6; box-shadow:var(--shadow-sm)}
    .content{white-space:pre-wrap; line-height:1.75; font-size:16px}
    .divider{height:1px; background:var(--line); margin:24px 0 8px}

    .c-head{font-size:18px; font-weight:900; color:var(--purple); margin:0 0 10px}
    .c-list{margin-top:4px}
    .comment-block{margin:0 0 16px; border-radius:16px; overflow:visible; position:relative; z-index:1}
    .c-item{display:flex; gap:12px; padding:16px 8px; border-top:1px solid var(--line)}
    .comment-block .c-item:first-of-type{border-top:none}

    .avatar{flex:0 0 40px; height:40px}
    .avatar img{width:40px; height:40px; display:block; border-radius:50%; object-fit:cover; background:#efe8f6; box-shadow:var(--shadow-sm)}

    .c-body{flex:1 1 auto; min-width:0}
    .c-row{display:flex; align-items:center; gap:8px; font-weight:900}
    .c-name{color:#231a45}
    .c-time{color:#8a8fa3; font-size:13px; font-weight:700}
    .c-text{margin:6px 0 8px; color:#241e3f; line-height:1.65; white-space:pre-wrap}

    .c-actions{display:flex; align-items:center; gap:10px}
    .btn-link{background:transparent; border:none; padding:6px 8px; border-radius:8px; cursor:pointer; color:var(--royal); font-weight:900}
    .btn-link:hover{background:#efe8f6}

    .reply-toggle{margin:6px 0 0; display:inline-flex; align-items:center; gap:6px; padding:6px 10px; border-radius:999px; border:1px solid var(--line); background:#f3eefc; color:var(--deep); font-weight:900; cursor:pointer}
    .reply-toggle[aria-expanded="true"] .caret{transform:rotate(180deg)}
    .caret{transition:transform .15s ease}

    .children{display:none; margin-left:52px; border-left:2px solid rgba(126,87,194,.25); padding:10px 0 0 12px; border-radius:0 0 0 8px}
    .children.open{display:block}

    .form textarea{width:100%; min-height:90px; resize:vertical; font-size:14px; line-height:1.6; border:1px solid var(--line); border-radius:12px; padding:12px; background:#fff; box-sizing:border-box}
    .form .submit{margin-top:10px; padding:10px 14px; border:none; border-radius:999px; cursor:pointer; color:#fff; font-weight:900; background:linear-gradient(90deg, var(--lavender), var(--royal), var(--deep)); box-shadow:0 10px 26px rgba(69,39,160,.22)}
    .inline{display:inline}

    /* ▼ 삭제 버튼 살짝 아래로 (기본 유지) */
    .c-actions {
        display: flex
        align-items: center;  /* ← 모든 자식 버튼/폼을 수직 가운데 정렬 */
        gap: 6px;             /* 버튼 간격 일정하게 */
    }

    .c-actions form {
        display: flex;
        align-items: center;  /* 폼 내부 버튼도 가운데 정렬 */
        margin: 0;            /* 브라우저 기본 마진 제거 */
    }

    @media (max-width:640px){
      .wrap,.comments-wrap{padding:22px}
      .avatar{flex-basis:32px; height:32px}
      .avatar img{width:32px; height:32px}
      .children{margin-left:44px}
    }
    .comment-block.is-open{z-index:100}
  </style>
</head>
<body>

<!-- ===== 게시글 본문 ===== -->
<div class="wrap">
  <div class="top">
    <h1 class="title">${board.title}</h1>

    <c:if test="${isAuthor}">
      <button type="button" class="menu-btn" aria-expanded="false" aria-controls="post-menu" onclick="toggleMenu(this)">☰</button>
      <nav id="post-menu" class="dropdown" aria-label="게시글 메뉴">
        <a href="/mbti/board/edit/${board.id}">수정</a>
        <form action="/mbti/board/delete/${board.id}" method="post" class="inline">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
          <input type="hidden" name="boardId" value="${board.id}" />
          <button type="submit">삭제</button>
        </form>
      </nav>
    </c:if>
  </div>

  <div class="meta">
    작성자: ${board.nickName}
    <span aria-hidden="true">·</span>
    작성일: ${board.formattedCreatedAt}
  </div>

  <c:if test="${board.fileId != 0}">
    <div class="media">
      <img src="/file/preview?fileId=${board.fileId}" alt="첨부 이미지" onerror="this.src='/resources/images/default-thumb.jpg'">
    </div>
  </c:if>

  <div class="content">${board.content}</div>
</div>

<!-- ===== 댓글 영역(분리) ===== -->
<div class="comments-wrap">
  <h2 class="c-head">댓글</h2>

  <div class="c-list">
    <c:forEach var="comment" items="${commentList}">
      <c:if test="${comment.parentId == 0}">
        <c:set var="replyCount" value="0"/>
        <c:forEach var="r" items="${commentList}">
          <c:if test="${r.parentId == comment.id}">
            <c:set var="replyCount" value="${replyCount + 1}"/>
          </c:if>
        </c:forEach>

        <div class="comment-block" id="block-${comment.id}">
          <article class="c-item" id="c-${comment.id}">
            <div class="avatar">
              <c:choose>
                <c:when test="${not empty comment.profileFileId and comment.profileFileId ne 0}">
                  <img src="/file/preview?fileId=${comment.profileFileId}"
                       alt="프로필"
                       loading="lazy"
                       style="width:40px;height:40px;border-radius:50%;object-fit:cover;">
                </c:when>
                <c:otherwise>
                  <img src="/resources/images/default-profile.jpg"
                       alt="기본 프로필"
                       loading="lazy"
                       style="width:40px;height:40px;border-radius:50%;object-fit:cover;">
                </c:otherwise>
              </c:choose>
            </div>
            <div class="c-body">
              <div class="c-row">
                <span class="c-name">${comment.authorNickname}</span>
                <span class="c-time">${comment.formattedCreatedAt}</span>
              </div>

              <div id="content-${comment.id}" class="c-text">${comment.content}</div>

              <div class="c-actions">
                <c:if test="${sessionScope.userId == comment.author}">
                  <button type="button" class="btn-link" data-action="edit" data-id="${comment.id}">수정</button>
                  <form action="/mbti/board/comment/delete/${comment.id}" method="post" class="inline comment-form">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <input type="hidden" name="boardId" value="${board.id}" />
                    <!-- 변경: input → button -->
                    <button type="submit" class="btn-link">삭제</button>
                  </form>
                </c:if>
                <button type="button" class="btn-link" data-action="reply" data-id="${comment.id}">답글</button>
              </div>

              <!-- 수정폼 -->
              <form id="edit-form-${comment.id}" action="/mbti/board/comment/update" method="post" class="form comment-form" style="display:none; margin-top:8px;">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <input type="hidden" name="id" value="${comment.id}" />
                <input type="hidden" name="boardId" value="${board.id}" />
                <textarea name="content">${comment.content}</textarea>
                <input type="submit" class="submit" value="수정 완료" />
              </form>

              <!-- 대댓글폼 -->
              <form id="reply-form-${comment.id}" action="/mbti/board/comment/save" method="post" class="form comment-form" style="display:none; margin-top:8px;">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <input type="hidden" name="boardId" value="${board.id}" />
                <input type="hidden" name="parentId" value="${comment.id}" />
                <textarea name="content" placeholder="답글을 입력하세요" required></textarea>
                <input type="submit" class="submit" value="작성" />
              </form>

              <c:if test="${replyCount > 0}">
                <button type="button" class="reply-toggle" data-toggle="replies" data-target="children-${comment.id}" aria-expanded="false">
                  <svg class="caret" width="16" height="16" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                    <path d="M5.23 7.21a.75.75 0 011.06.02L10 11.06l3.71-3.83a.75.75 0 111.08 1.04l-4.24 4.38a.75.75 0 01-1.08 0L5.21 8.27a.75.75 0 01.02-1.06z"/>
                  </svg>
                  답글 ${replyCount}개
                </button>
              </c:if>
            </div>
          </article>

          <div id="children-${comment.id}" class="children">
            <c:forEach var="reply" items="${commentList}">
              <c:if test="${reply.parentId == comment.id}">
                <article class="c-item" id="c-${reply.id}" style="border-top:none; padding-top:12px;">
                  <div class="avatar">
                    <c:choose>
                      <c:when test="${not empty reply.profileFileId and reply.profileFileId ne 0}">
                        <img src="/file/preview?fileId=${reply.profileFileId}"
                             alt="프로필"
                             loading="lazy"
                             style="width:36px;height:36px;border-radius:50%;object-fit:cover;">
                      </c:when>
                      <c:otherwise>
                        <img src="/resources/images/default-profile.jpg"
                             alt="기본 프로필"
                             loading="lazy"
                             style="width:36px;height:36px;border-radius:50%;object-fit:cover;">
                      </c:otherwise>
                    </c:choose>
                  </div>
                  <div class="c-body">
                    <div class="c-row">
                      <span class="c-name">${reply.authorNickname}</span>
                      <span class="c-time">${reply.formattedCreatedAt}</span>
                    </div>
                    <div id="content-${reply.id}" class="c-text">${reply.content}</div>
                    <div class="c-actions">
                      <c:if test="${sessionScope.userId == reply.author}">
                        <button type="button" class="btn-link" data-action="edit" data-id="${reply.id}">수정</button>
                        <form action="/mbti/board/comment/delete/${reply.id}" method="post" class="inline comment-form">
                          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                          <input type="hidden" name="boardId" value="${board.id}" />
                          <!-- 변경: input → button -->
                          <button type="submit" class="btn-link">삭제</button>
                        </form>
                      </c:if>
                    </div>

                    <!-- 대댓글 수정폼 -->
                    <form id="edit-form-${reply.id}" action="/mbti/board/comment/update" method="post" class="form comment-form" style="display:none; margin-top:8px;">
                      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                      <input type="hidden" name="id" value="${reply.id}" />
                      <input type="hidden" name="boardId" value="${board.id}" />
                      <textarea name="content">${reply.content}</textarea>
                      <input type="submit" class="submit" value="수정 완료" />
                    </form>
                  </div>
                </article>
              </c:if>
            </c:forEach>
          </div>
        </div>
      </c:if>
    </c:forEach>
  </div>

  <!-- 일반 댓글 작성 -->
  <form action="/mbti/board/comment/save" method="post" class="form comment-form" style="margin-top:16px;">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    <input type="hidden" name="boardId" value="${board.id}" />
    <input type="hidden" name="parentId" value="0" />
    <textarea name="content" placeholder="댓글을 입력하세요" required></textarea>
    <input type="submit" class="submit" value="댓글 작성" />
  </form>
</div>

<script>
  // 메뉴 토글
  function toggleMenu(btn){
    const menu = document.getElementById('post-menu'); if(!menu || !btn) return;
    const open = menu.dataset.open === 'true';
    if(!open){
      const r = btn.getBoundingClientRect(); const w = Math.max(180, menu.offsetWidth || 180);
      menu.style.position='fixed';
      menu.style.top=(r.bottom+8)+'px';
      menu.style.left=Math.max(12, Math.min(window.innerWidth - w - 12, r.right - w))+'px';
      menu.style.display='block'; menu.dataset.open='true'; btn.setAttribute('aria-expanded','true');
    }else{
      menu.style.display='none'; menu.dataset.open='false'; btn.setAttribute('aria-expanded','false');
    }
  }
  document.addEventListener('click', function(e){
    const menu=document.getElementById('post-menu'); const btn=document.querySelector('.menu-btn');
    if(menu && btn && menu.dataset.open==='true' && !menu.contains(e.target) && !btn.contains(e.target)){
      menu.style.display='none'; menu.dataset.open='false'; btn.setAttribute('aria-expanded','false');
    }
  });
  document.addEventListener('keydown', function(e){
    if(e.key==='Escape'){
      const menu=document.getElementById('post-menu'); const btn=document.querySelector('.menu-btn');
      if(menu && menu.dataset.open==='true'){ menu.style.display='none'; menu.dataset.open='false'; btn && btn.focus(); btn && btn.setAttribute('aria-expanded','false'); }
    }
  });

  // 댓글/답글/수정 폼 토글 (델리게이션)
  document.addEventListener('click', function(e){
    const replyBtn=e.target.closest('[data-action="reply"]');
    if(replyBtn){
      e.preventDefault();
      const id=replyBtn.getAttribute('data-id');
      const form=document.getElementById('reply-form-'+id);
      if(form){
        const hidden=getComputedStyle(form).display==='none';
        form.style.setProperty('display', hidden ? 'block' : 'none', 'important');
      }
      return;
    }

    const editBtn=e.target.closest('[data-action="edit"]');
    if(editBtn){
      e.preventDefault();
      const id=editBtn.getAttribute('data-id');
      const form=document.getElementById('edit-form-'+id);
      if(form){
        const hidden=getComputedStyle(form).display==='none';
        form.style.setProperty('display', hidden ? 'block' : 'none', 'important');
      }
      return;
    }

    const toggleBtn=e.target.closest('[data-toggle="replies"]');
    if(toggleBtn){
      e.preventDefault();
      const targetId=toggleBtn.getAttribute('data-target');
      const box=document.getElementById(targetId);
      const card=toggleBtn.closest('.comment-block');
      if(!box || !card) return;

      const willOpen=getComputedStyle(box).display==='none';
      box.classList.toggle('open', willOpen);
      box.style.setProperty('display', willOpen ? 'block' : 'none', 'important');
      toggleBtn.setAttribute('aria-expanded', String(willOpen));
      card.classList.toggle('is-open', willOpen);
      return;
    }
  });

  // 🔒 JSP만으로 content null 방지: 제출 직전 기본 문구/트림 처리
  document.querySelectorAll('form.comment-form').forEach(function(form){
    form.addEventListener('submit', function(){
      var ta=form.querySelector('textarea[name="content"]');
      if(!ta) return;
      var v=(ta.value||'').replace(/\s+/g,' ').trim();
      ta.value = v ? v : '새 댓글이 달렸습니다.'; // 비어있으면 기본 문구
    });
  });
</script>
</body>
</html>
