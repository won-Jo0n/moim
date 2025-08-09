<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>MBTI 게시판</title>
    <style>
        body { font-family: 'Noto Sans KR', Arial, sans-serif; background:#fafafa; margin:0; }
        .wrap { max-width:1200px; margin:24px auto; padding:0 16px; }
        .header { display:flex; align-items:center; justify-content:space-between; margin:8px 0 16px; }
        .title { font-size:22px; font-weight:700; }
        .write-btn { display:inline-block; padding:10px 14px; background:#3897f0; color:#fff; border-radius:10px; text-decoration:none; font-weight:600; }
        .write-btn:hover { background:#2878c9; }

        .grid { display:grid; grid-template-columns:repeat(auto-fill, minmax(240px,1fr)); gap:16px; }
        .card { background:#fff; border-radius:14px; overflow:hidden; box-shadow:0 2px 10px rgba(0,0,0,.06); cursor:pointer; transition:transform .15s ease; outline:none; }
        .card:hover { transform:translateY(-4px); }
        .card:focus-visible { box-shadow:0 0 0 3px rgba(56,151,240,.35); }

        .thumb { width:100%; height:200px; object-fit:cover; background:#e9e9e9; display:block; }
        .body { padding:12px 14px; }
        .t1 { font-size:15px; font-weight:700; margin:0 0 6px; color:#111; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .meta { font-size:12px; color:#666; line-height:1.5; }
        .meta-row { display:flex; align-items:center; justify-content:space-between; }

        .to-top { position:fixed; right:16px; bottom:16px; display:none; padding:10px 12px; font-size:12px; border:0; border-radius:999px; background:#000; color:#fff; cursor:pointer; }
        .to-top.show { display:block; }
    </style>
</head>
<body>
<%-- 컨텍스트 안전 경로 --%>
<c:set var="fallbackThumb" value="<c:url value='/resources/images/default-thumb.jpg'/>" />

<div class="wrap">
    <div class="header">
        <div class="title">MBTI 게시판</div>
        <a href="/mbti/board/write" class="write-btn">글쓰기</a>
    </div>

    <div class="grid" id="boardGrid">
        <c:set var="fallbackThumb" value="<c:url value='/resources/images/default-thumb.jpg'/>" />

        <c:forEach var="board" items="${boardList}">
            <c:set var="thumbSrc" value="${empty previews ? null : previews[board.id]}"/>
            <c:if test="${empty thumbSrc && board.fileId != 0}">
                <c:url var="fileUrl" value="/file/preview">
                    <c:param name="fileId" value="${board.fileId}" />
                </c:url>
                <c:set var="thumbSrc" value="${fileUrl}" />
            </c:if>

            <div class="card" data-id="${board.id}">
                <img class="thumb" loading="lazy"
                     src="${fallbackThumb}"
                     <c:if test="${not empty thumbSrc}">data-src="${thumbSrc}"</c:if>
                     alt="${board.title}"
                     onerror="this.onerror=null; this.src='${fallbackThumb}';" />
                <div class="body">
                    <div class="t1">${board.title}</div>
                    <div class="meta">${board.author} · ${board.formattedCreatedAt}</div>
                    <span>조회수${board.hits}</span>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<button class="to-top" id="toTopBtn" aria-label="맨 위로">TOP</button>

<script>
/* 카드 클릭/Enter 이동 */
(function () {
  var grid = document.getElementById('boardGrid');
  if (!grid) return;

  grid.addEventListener('click', function (e) {
    var card = e.target.closest('.card');
    if (!card) return;
    var id = card.getAttribute('data-id');
    if (id) location.href = '<c:url value="/mbti/board/detail/" />' + id;
  });

  grid.addEventListener('keydown', function (e) {
    if (e.key !== 'Enter') return;
    var card = e.target.closest('.card');
    if (!card) return;
    var id = card.getAttribute('data-id');
    if (id) location.href = '<c:url value="/mbti/board/detail/" />' + id;
  });
})();

/* 지연 로딩 + 오류 대체 */
(function () {
  var imgs = document.querySelectorAll('img.thumb[data-src]');
  var fallback = '<c:url value="/resources/images/default-thumb.jpg"/>';

  function load(img) {
    var real = img.getAttribute('data-src');
    if (!real) return;
    img.onerror = function(){ img.src = fallback; };
    img.src = real;
    img.removeAttribute('data-src');
  }

  if ('IntersectionObserver' in window) {
    var io = new IntersectionObserver(function (entries, obs) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) { load(entry.target); obs.unobserve(entry.target); }
      });
    }, { rootMargin: '200px 0px' });
    imgs.forEach(function (img) { io.observe(img); });
  } else {
    imgs.forEach(load);
  }
})();

/* 호버 프리페치 */
(function () {
  var grid = document.getElementById('boardGrid');
  if (!grid) return;
  var prefetched = new Set();
  grid.addEventListener('mouseenter', function (e) {
    var card = e.target.closest('.card'); if (!card) return;
    var id = card.getAttribute('data-id'); if (!id || prefetched.has(id)) return;
    var link = document.createElement('link');
    link.rel = 'prefetch';
    link.href = '<c:url value="/mbti/board/detail/" />' + id;
    document.head.appendChild(link);
    prefetched.add(id);
  }, true);
})();

/* 맨 위로 */
(function () {
  var btn = document.getElementById('toTopBtn'); if (!btn) return;
  window.addEventListener('scroll', function () {
    if (window.scrollY > 400) btn.classList.add('show'); else btn.classList.remove('show');
  });
  btn.addEventListener('click', function () {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });
})();
</script>
</body>
</html>
