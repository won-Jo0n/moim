<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>게시글 상세</title>
    <meta name="${_csrf.parameterName}" content="${_csrf.token}"/>
    <style>
       /* ================== Purple Theme Tokens ================== */
       :root{
         /* Palette */
         --lavender:#B18FCF;   /* 메인 배경, 큰 버튼 */
         --purple:#7E57C2;     /* 로고/강조 텍스트 */
         --royal:#5E35B1;      /* 헤더/네비게이션 */
         --lilac:#CBAACB;      /* 카드/섹션 배경 */
         --deep:#4527A0;       /* CTA/하이라이트 */

         /* Surfaces & text */
         --bg:#F7F2FA;         /* 라벤더 톤을 연하게 확장한 배경 */
         --paper:#ffffff;
         --ink:#121226;
         --muted:#7b7f95;
         --line:#ece6f5;

         /* Animated gradient (Purple spectrum) */
         --grad-1: var(--purple);
         --grad-2: var(--royal);
         --grad-3: var(--deep);
       }
       @keyframes gradientShift{
         0%{background-position:0% 50%}
         50%{background-position:100% 50%}
         100%{background-position:0% 50%}
       }

       /* ================== Layout ================== */
       body {
           font-family: 'Noto Sans KR', 'Arial', sans-serif;
           background-color: var(--bg);
           margin: 0;
           display: flex;
           justify-content: center;
           padding: 60px 12px;
           color: var(--ink);
       }
       .detail-container {
           background-color: var(--paper);
           padding: 32px 32px 40px;
           border-radius: 20px;
           width: min(900px, 92vw);
           box-shadow: 0 18px 40px rgba(69,39,160,.10); /* deep purple 그림자 */
           word-break: break-word;
       }

       /* ================== Title + Menu ================== */
       .title-bar{
           display:flex; align-items:flex-start; justify-content:space-between; gap:12px;
           margin-bottom: 8px;
       }
       h1 {
           font-size: 26px; margin: 0; line-height: 1.3; color: var(--royal);
       }
       .meta {
           color: var(--muted);
           margin: 8px 0 20px;
           font-size: 14px;
       }

       /* 큰 버튼: 라벤더 기반 + 퍼플 스펙트럼 그라데이션 */
       .grad-btn{
           display:inline-flex; align-items:center; gap:6px;
           color:#fff; font-weight:800; border:none; cursor:pointer;
           padding:10px 12px; border-radius:12px;
           background-image: linear-gradient(90deg, var(--lavender), var(--grad-2), var(--grad-3));
           background-size:200% 200%; animation:gradientShift 8s linear infinite;
           box-shadow:0 10px 26px rgba(69,39,160,.20);
           transition: transform .12s ease, filter .18s ease, box-shadow .18s ease, background-position .3s linear;
       }
       .grad-btn:hover{ transform:translateY(-1px); filter:brightness(1.02); }

       .menu-btn{ font-size:20px; line-height:1; }
       .dropdown{
           position:fixed; display:none; z-index:1000; min-width:180px;
           background:var(--paper); border-radius:12px; padding:8px;
           box-shadow:0 18px 42px rgba(69,39,160,.18); backdrop-filter:saturate(140%) blur(2px);
           border:1px solid var(--line);
       }
       .dropdown a, .dropdown button{
           display:block; width:100%; text-align:left;
           padding:10px 12px; border-radius:8px; border:none;
           background:transparent; color:var(--ink); font-weight:700; text-decoration:none;
           cursor:pointer; transition:background .15s ease, transform .12s ease;
       }
       .dropdown a:hover, .dropdown button:hover{ background: rgba(193,168,211,.16); transform:translateY(-1px); }

       /* ================== Media ================== */
       .media{ width:100%; margin: 12px 0 18px; }
       .media img{
           width:100%; max-width:900px;
           aspect-ratio:16/9; object-fit:cover;
           border-radius: 16px;
           background:#efe8f6;
           box-shadow:0 12px 30px rgba(69,39,160,.15);
       }

       .content {
           font-size: 16px;
           line-height: 1.7;
           color: #2b2b40;
           margin: 14px 0 8px;
           white-space: pre-wrap;
       }

       /* ================== YouTube-like Comments ================== */
       .comment-section { margin-top: 36px; }
       .comment-header{ font-size:18px; font-weight:900; margin-bottom:12px; color: var(--purple); }

       .ytc-list{ margin-top:12px }
       .ytc-c{ display:flex; gap:12px; padding:14px 0; border-top:1px solid var(--line); }
       .ytc-avatar{
            flex:0 0 40px; height:40px; border-radius:50%;
            background:linear-gradient(90deg, var(--grad-1), var(--grad-2), var(--grad-3));
            background-size:200% 200%; animation:gradientShift 8s linear infinite;
            box-shadow:0 6px 18px rgba(69,39,160,.22);
       }
       .ytc-body{ flex:1 1 auto; min-width:0; }
       .ytc-head{ display:flex; align-items:center; gap:8px; font-weight:900; }
       .ytc-name{ color:#1d1833; }
       .ytc-time{ color:#8a8fa3; font-size:13px; font-weight:700; }
       .ytc-text{ margin:6px 0 4px; color:#241e3f; line-height:1.65; white-space:pre-wrap; }

       .ytc-actions{ display:flex; align-items:center; gap:14px; margin-top:6px; }
       .ytc-btn{
           background:transparent; border:none; padding:6px 8px; border-radius:8px; cursor:pointer;
           color: var(--royal); font-weight:900;
       }
       .ytc-btn:hover{ background:#efe8f6; }

       .ytc-toggle{
           display:inline-flex; align-items:center; gap:6px; color:var(--deep);
           font-weight:900; cursor:pointer; margin-top:8px; padding:6px 8px; border-radius:8px;
           background: rgba(193,170,203,.18);
       }
       .ytc-toggle:hover{ background: rgba(193,170,203,.28); }
       .ytc-caret{ transition:transform .15s ease; }
       .ytc-toggle[aria-expanded="true"] .ytc-caret{ transform:rotate(180deg) }

       .ytc-children{
         margin-left:52px; display:none;
         border-left:2px solid rgba(126,87,194,.25); padding-left:12px;
         background: linear-gradient(180deg, rgba(203,170,203,.12), transparent 40%);
         border-radius: 0 0 0 8px;
       }
       .ytc-children.open{ display:block; }

       .comment-form textarea, .reply-form textarea, form textarea{
           width:100%; padding:10px; border-radius:12px; border:1px solid var(--line);
           box-sizing:border-box; font-size:14px; resize:vertical; min-height:84px;
           background: #fff;
       }
       .comment-form input[type="submit"], .reply-form input[type="submit"], form input[type="submit"]{
           margin-top:10px; color:#fff; font-weight:900; border:none; cursor:pointer;
           padding:10px 14px; border-radius:999px;
           background-image: linear-gradient(90deg, var(--lavender), var(--grad-2), var(--deep));
           background-size:200% 200%; animation:gradientShift 8s linear infinite;
           box-shadow:0 10px 26px rgba(69,39,160,.22);
           transition: transform .12s ease, filter .18s ease;
       }
       .comment-form input[type="submit"]:hover,
       .reply-form input[type="submit"]:hover,
       form input[type="submit"]:hover{ transform:translateY(-1px); filter:brightness(1.02); }

       .hidden{ display:none; }

       @media (max-width:640px){
         .detail-container{ padding:24px; }
         .ytc-avatar{ flex-basis:32px; height:32px }
         .ytc-children{ margin-left:44px }
       }
    </style>
</head>
<body>
<div class="detail-container">

    <!-- Title + hamburger -->
    <div class="title-bar">
        <h1>${board.title}</h1>

        <c:if test="${isAuthor}">
            <button class="grad-btn menu-btn" type="button" onclick="toggleMenu(this)" aria-expanded="false" aria-controls="post-menu">☰</button>
            <nav class="dropdown" id="post-menu" aria-label="게시글 메뉴">
                <a href="/mbti/board/edit/${board.id}">수정</a>
                <form action="/mbti/board/delete/${board.id}" method="post" style="margin:0;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <input type="hidden" name="boardId" value="${board.id}" />
                    <button type="submit">삭제</button>
                </form>
            </nav>
        </c:if>
    </div>

    <div class="meta">작성자: ${board.authorInfo} · 작성일: ${board.formattedCreatedAt}</div>

    <!-- Fixed-size media on top -->
    <c:if test="${board.fileId != 0}">
        <div class="media">
            <img src="/file/preview?fileId=${board.fileId}" alt="이미지"
                 onerror="this.src='/resources/images/default-thumb.jpg'"/>
        </div>
    </c:if>

    <!-- Content under image -->
    <div class="content">${board.content}</div>

    <!-- ===== Comments (YouTube-like) ===== -->
    <div class="comment-section">
        <div class="comment-header">댓글</div>

        <div class="ytc-list">
            <c:forEach var="comment" items="${commentList}">
                <c:if test="${comment.parentId == 0}">
                    <%-- reply count --%>
                    <c:set var="replyCount" value="0"/>
                    <c:forEach var="r" items="${commentList}">
                        <c:if test="${r.parentId == comment.id}">
                            <c:set var="replyCount" value="${replyCount + 1}"/>
                        </c:if>
                    </c:forEach>

                    <article class="ytc-c" id="c-${comment.id}">
                        <div class="ytc-avatar" aria-hidden="true"></div>
                        <div class="ytc-body">
                            <div class="ytc-head">
                                <span class="ytc-name">${comment.authorNickname}</span>
                                <span class="ytc-time">${comment.createdAt}</span>
                            </div>

                            <div id="content-${comment.id}" class="ytc-text">${comment.content}</div>

                            <div class="ytc-actions">
                                <c:if test="${sessionScope.userId == comment.author}">
                                    <button class="ytc-btn" onclick="toggleEdit(${comment.id})">수정</button>
                                    <form action="/mbti/board/comment/delete/${comment.id}" method="post" style="display:inline;">
                                      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                      <input type="hidden" name="boardId" value="${board.id}" />
                                      <input type="submit" class="ytc-btn" value="삭제"/>
                                    </form>
                                </c:if>
                                <button class="ytc-btn" onclick="toggleReplyForm(${comment.id})">답글</button>
                            </div>

                            <form id="edit-form-${comment.id}" action="/mbti/board/comment/update" method="post" style="display:none; margin-top:8px;">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <input type="hidden" name="id" value="${comment.id}" />
                                <input type="hidden" name="boardId" value="${board.id}" />
                                <textarea name="content">${comment.content}</textarea>
                                <input type="submit" value="수정 완료" />
                            </form>

                            <form id="reply-form-${comment.id}" class="reply-form" action="/mbti/board/comment/save" method="post" style="display:none; margin-top:8px;">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <input type="hidden" name="boardId" value="${board.id}" />
                                <input type="hidden" name="parentId" value="${comment.id}" />
                                <textarea name="content" placeholder="답글을 입력하세요" required></textarea>
                                <input type="submit" value="작성" />
                            </form>

                            <c:if test="${replyCount > 0}">
                              <div class="ytc-toggle" role="button" aria-expanded="false" onclick="toggleReplies(${comment.id})">
                                <svg class="ytc-caret" width="16" height="16" viewBox="0 0 20 20" fill="currentColor"><path d="M5.23 7.21a.75.75 0 011.06.02L10 11.06l3.71-3.83a.75.75 0 111.08 1.04l-4.24 4.38a.75.75 0 01-1.08 0L5.21 8.27a.75.75 0 01.02-1.06z"/></svg>
                                답글 ${replyCount}개
                              </div>
                            </c:if>

                            <div id="children-${comment.id}" class="ytc-children">
                                <c:forEach var="reply" items="${commentList}">
                                    <c:if test="${reply.parentId == comment.id}">
                                        <article class="ytc-c reply" id="c-${reply.id}" style="border-top:none;">
                                            <div class="ytc-avatar" aria-hidden="true"></div>
                                            <div class="ytc-body">
                                                <div class="ytc-head">
                                                    <span class="ytc-name">${reply.authorNickname}</span>
                                                    <span class="ytc-time">${reply.createdAt}</span>
                                                </div>
                                                <div id="content-${reply.id}" class="ytc-text">${reply.content}</div>
                                                <div class="ytc-actions">
                                                    <c:if test="${sessionScope.userId == reply.author}">
                                                        <button class="ytc-btn" onclick="toggleEdit(${reply.id})">수정</button>
                                                        <form action="/mbti/board/comment/delete/${reply.id}" method="post" style="display:inline;">
                                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                            <input type="hidden" name="boardId" value="${board.id}" />
                                                            <input type="submit" class="ytc-btn" value="삭제"/>
                                                        </form>
                                                    </c:if>
                                                </div>

                                                <form id="edit-form-${reply.id}" action="/mbti/board/comment/update" method="post" style="display:none; margin-top:8px;">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                    <input type="hidden" name="id" value="${reply.id}" />
                                                    <input type="hidden" name="boardId" value="${board.id}" />
                                                    <textarea name="content">${reply.content}</textarea>
                                                    <input type="submit" value="수정 완료" />
                                                </form>
                                            </div>
                                        </article>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>
                    </article>
                </c:if>
            </c:forEach>
        </div>

        <!-- 새 댓글 -->
        <form class="comment-form" action="/mbti/board/comment/save" method="post" style="margin-top:14px;">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <input type="hidden" name="boardId" value="${board.id}" />
            <input type="hidden" name="parentId" value="0" />
            <textarea name="content" placeholder="댓글을 입력하세요" required></textarea>
            <input type="submit" value="댓글 작성"/>
        </form>
    </div>
</div>

<script>
  // 햄버거 바로 아래 드롭다운
  function toggleMenu(btn){
      const menu = document.getElementById('post-menu');
      if(!menu || !btn) return;

      const open = menu.dataset.open === 'true';
      if(!open){
          const r = btn.getBoundingClientRect();
          const w = Math.max(180, menu.offsetWidth || 180);
          menu.style.position = 'fixed';
          menu.style.top = (r.bottom + 8) + 'px';
          const left = Math.max(12, Math.min(window.innerWidth - w - 12, r.right - w));
          menu.style.left = left + 'px';
          menu.style.display = 'block';
          menu.dataset.open = 'true';
          btn.setAttribute('aria-expanded','true');
          const first = menu.querySelector('a,button'); first && setTimeout(()=>first.focus(),0);
      }else{
          menu.style.display = 'none';
          menu.dataset.open = 'false';
          btn.setAttribute('aria-expanded','false');
      }
  }
  document.addEventListener('click', (e)=>{
      const menu = document.getElementById('post-menu');
      const btn = document.querySelector('.menu-btn');
      if(!menu || !btn) return;
      if(menu.dataset.open === 'true' && !menu.contains(e.target) && !btn.contains(e.target)){
          menu.style.display='none'; menu.dataset.open='false'; btn.setAttribute('aria-expanded','false');
      }
  });
  document.addEventListener('keydown', (e)=>{
      if(e.key==='Escape'){
          const menu = document.getElementById('post-menu');
          const btn = document.querySelector('.menu-btn');
          if(menu && menu.dataset.open==='true'){ menu.style.display='none'; menu.dataset.open='false'; btn?.focus(); btn?.setAttribute('aria-expanded','false'); }
      }
  });

  // 댓글 토글
  function toggleReplies(id){
    const box = document.getElementById('children-' + id);
    const toggle = document.querySelector(`#c-${id} .ytc-toggle`);
    if(!box || !toggle) return;
    const open = box.classList.toggle('open');
    toggle.setAttribute('aria-expanded', String(open));
  }
  function toggleReplyForm(id){
    const f = document.getElementById('reply-form-' + id);
    if(f) f.style.display = (f.style.display === 'none' || !f.style.display) ? 'block' : 'none';
  }
  function toggleEdit(id){
    const f = document.getElementById('edit-form-' + id);
    if(f) f.style.display = (f.style.display === 'none' || !f.style.display) ? 'block' : 'none';
  }
</script>
</body>
</html>
