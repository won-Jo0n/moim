<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<html>
<head>
<c:set var="fid" value="${friendPhotoMap[friend.id]}" />
<c:set var="ctx" value="${pageContext.request.contextPath}" />
    <title>${profile.nickname}님의 마이페이지</title>
    <style>
        :root { --paper:#fff; --bg:#f5f6fa; --brand:#7E57C2; --text:#333; --grad-1:#7E57C2; --grad-2:#5E35B1; --grad-3:#4527A0; }
        @keyframes gradientShift { 0%{background-position:0% 50%} 50%{background-position:100% 50%} 100%{background-position:0% 50%} }
        body{ margin:0; font-family:'Noto Sans KR',sans-serif;
              background:linear-gradient(180deg, rgba(203,170,203,.08), rgba(177,143,207,.08)), var(--bg); }
        .container{ max-width:1000px; margin:40px auto; background:var(--paper); border-radius:14px; box-shadow:0 8px 22px rgba(0,0,0,.08); padding:20px; position:relative; }
        .top-bar{ display:flex; justify-content:space-between; align-items:center; gap:10px; }
        .top-bar > a{ display:inline-flex; align-items:center; gap:6px; color:#fff; text-decoration:none; font-weight:800; padding:10px 14px; border-radius:999px; border:none;
                      background-image:linear-gradient(90deg,var(--grad-1),var(--grad-2),var(--grad-3)); background-size:200% 200%; animation:gradientShift 8s linear infinite;
                      box-shadow:0 8px 22px rgba(94,53,177,.18); transition:transform .12s, box-shadow .18s, filter .18s; }
        .top-bar > a:hover{ transform:translateY(-1px); filter:brightness(1.02); box-shadow:0 12px 28px rgba(94,53,177,.22); }
        .menu-btn{ font-size:22px; cursor:pointer; border:none; color:#fff; border-radius:12px; padding:10px 12px;
                   background-image:linear-gradient(90deg,var(--grad-1),var(--grad-2),var(--grad-3)); background-size:200% 200%; animation:gradientShift 8s linear infinite;
                   box-shadow:0 8px 22px rgba(94,53,177,.18); transition:transform .12s, box-shadow .18s, filter .18s; }
        .dropdown{ position:fixed; display:none; background:var(--paper); box-shadow:0 12px 30px rgba(15,23,42,.12); padding:8px; border-radius:10px; z-index:1000; min-width:180px; }
        .dropdown a{ display:block; padding:10px 12px; text-decoration:none; color:var(--text); font-weight:700; border-radius:8px; }
        .profile-section{ text-align:center; margin-top:30px; }
        .profile-section img{ width:100px; height:100px; border-radius:50%; object-fit:cover; background:#eee; }
        .profile-section h2{ margin:10px 0 5px; }
        .badge{ display:inline-block; padding:4px 10px; border-radius:20px; background:#B18FCF; color:#fff; font-size:13px; font-weight:700; }
        .rating{ color:#f5c518; font-size:18px; margin-top:5px; letter-spacing:2px; }

        .tabs{ display:flex; margin-top:30px; gap:6px; }
        .tab{ flex:1; text-align:center; padding:12px; cursor:pointer; font-weight:800; color:#666; border-bottom:3px solid transparent; position:relative; }
        .tab.active{ color:#1c2f6b; background:#fff; box-shadow:0 8px 18px rgba(15,23,42,.06); }
        .tab.active::after{ content:""; position:absolute; left:16px; right:16px; bottom:0; height:4px; border-radius:4px;
                             background-image:linear-gradient(90deg,var(--grad-1),var(--grad-2),var(--grad-3)); background-size:200% 200%; animation:gradientShift 8s linear infinite; }

        .section{ display:none; padding:20px 0; }
        .section.active{ display:block; }

        .post-grid{ display:grid; grid-template-columns:repeat(auto-fill,minmax(280px,1fr)); gap:20px; }
        .post{ background:var(--paper); border-radius:14px; box-shadow:0 10px 26px rgba(0,0,0,0.06); overflow:hidden; cursor:pointer; display:flex; flex-direction:column; border:none; transition:transform .18s, box-shadow .18s; }
        .post:hover{ transform:translateY(-3px); box-shadow:0 16px 38px rgba(94,53,177,.14); }
        .post img{ width:100%; height:180px; object-fit:cover; background:#f0f0f0; }
        .post-content{ padding:15px; }
        .post-content h4{ margin:0; font-size:16px; font-weight:800; color:var(--text); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }

        .card-list{ display:grid; grid-template-columns:repeat(auto-fill,minmax(160px, 1fr)); gap:15px; }
        .tile{ border-radius:14px; background:#fff; box-shadow:0 10px 26px rgba(0,0,0,0.06); padding:16px 12px; text-align:center; cursor:pointer; border:none; transition:transform .18s, box-shadow .18s; }
        .tile:hover{ transform:translateY(-2px); box-shadow:0 16px 36px rgba(94,53,177,.14); }
        .tile .icon{ font-size:30px; margin-bottom:8px; }

        .empty-msg{ text-align:center; color:#999; margin-top:30px; font-size:15px; }

        #friendBtn{ appearance:none; margin-top:12px; color:#fff; font-weight:800; padding:10px 14px; border-radius:999px; border:none;
            background-image:linear-gradient(90deg,var(--grad-1),var(--grad-2),var(--grad-3)); background-size:200% 200%; animation:gradientShift 8s linear infinite;
            box-shadow:0 8px 22px rgba(94,53,177,.18); transition:transform .12s, box-shadow .18s, filter .18s; cursor:pointer; }
        #friendBtn:hover{ transform:translateY(-1px); filter:brightness(1.02); }

        @media (max-width:600px){ .post img{ height:140px; } }
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
            <a href="${ctx}/mbti/test">MBTI 테스트</a>
            <a href="user/logout">로그아웃</a>
        </div>
    </div>

    <div class="profile-section">
       <c:choose>
         <c:when test="${profile.fileId != null && profile.fileId > 0}">
           <img src="${ctx}/file/preview?fileId=${profile.fileId}" alt="프로필 이미지"
                style="width:100px;height:100px;border-radius:50%;object-fit:cover;background:#eee;"
                onerror="this.onerror=null; this.src='${ctx}/resources/images/default-profile.jpg'">
         </c:when>
         <c:otherwise>
           <img src="${ctx}/resources/images/default-profile.jpg" alt="기본 프로필 이미지"
                style="width:100px;height:100px;border-radius:50%;object-fit:cover;background:#eee;">
         </c:otherwise>
       </c:choose>

        <h2>${profile.nickname}</h2>
        <span class="badge">${profile.mbti}</span>
        <div class="rating">
            <c:forEach begin="1" end="5" var="i">
                <c:choose>
                    <c:when test="${i <= profile.rating}">★</c:when>
                    <c:otherwise>☆</c:otherwise>
                </c:choose>
            </c:forEach>
        </div>

        <!-- ✅ 친구 상태 버튼 영역 (이 블록으로 교체) -->
        <!-- 상태 정규화: null/빈값 -> NONE, trim + upper-case -->
        <c:set var="rawStatus" value="${friendshipStatus}" />
        <c:if test="${empty rawStatus}">
            <c:set var="rawStatus" value="NONE" />
        </c:if>
        <c:set var="status" value="${fn:toUpperCase(fn:trim(rawStatus))}" />

        <c:if test="${sessionScope.userId ne profile.userId}">
            <c:choose>
                <c:when test="${status eq 'ACCEPTED'}">
                    <button id="friendBtn"
                            data-target="${profile.userId}"
                            data-status="ACCEPTED"
                            onclick="toggleFriendRequest(this)">
                        친구 삭제
                    </button>
                </c:when>
                <c:when test="${status eq 'PENDING'}">
                    <button id="friendBtn"
                            data-target="${profile.userId}"
                            data-status="PENDING"
                            onclick="toggleFriendRequest(this)">
                        친구 요청 취소
                    </button>
                </c:when>
                <c:otherwise>
                    <button id="friendBtn"
                            data-target="${profile.userId}"
                            data-status="NONE"
                            onclick="toggleFriendRequest(this)">
                        친구 요청
                    </button>
                </c:otherwise>
            </c:choose>
        </c:if>
        <!-- ✅ 교체 끝 -->
    </div>

    <div class="tabs">
        <div class="tab active" data-target="posts">작성 글</div>
        <div class="tab" data-target="friends">친구 목록</div>
        <div class="tab" data-target="groups"> 나의 그룹</div>
    </div>

    <!-- 작성 글 -->
    <div class="section active" id="posts">
        <c:if test="${empty boardList}">
            <div class="empty-msg">작성한 글이 없습니다.</div>
        </c:if>
        <div class="post-grid">
            <c:forEach var="board" items="${boardList}">
                <div class="post" onclick="location.href='/mbti/board/detail/${board.id}'">
                    <c:choose>
                      <c:when test="${board.fileId != null && board.fileId > 0}">
                        <img src="${ctx}/file/preview?fileId=${board.fileId}" alt="썸네일"
                             onerror="this.onerror=null; this.src='${ctx}/resources/images/default-thumb.jpg'">
                      </c:when>
                      <c:otherwise>
                        <img src="${ctx}/resources/images/default-thumb.jpg" alt="기본 썸네일">
                      </c:otherwise>
                    </c:choose>
                    <div class="post-content">
                        <h4>${board.title}</h4>
                        <div class="meta-info"><span class="date">${board.formattedCreatedAt}</span></div>
                        <p>${fn:substring(board.content, 0, 50)}...</p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- 친구 목록 -->
    <div class="section" id="friends">
      <c:if test="${empty friendList}">
        <div class="empty-msg">친구가 없어요 😢<br>친구를 추가해보세요!</div>
      </c:if>

      <div class="card-list">
        <c:forEach var="friend" items="${friendList}">
          <div class="tile" onclick="location.href='${ctx}/profile/view/${friend.id}'">
            <c:set var="fid" value="${friendPhotoMap[friend.id]}" />
            <c:choose>
              <c:when test="${fid != null && fid > 0}">
                <img src="${ctx}/file/preview?fileId=${fid}" alt="${friend.nickName}"
                     style="width:84px;height:84px;border-radius:50%;object-fit:cover;border:1px solid #ececec;display:block;margin:0 auto 8px;"
                     onerror="this.onerror=null; this.src='${ctx}/resources/images/default-profile.jpg'">
              </c:when>
              <c:otherwise>
                <img src="${ctx}/resources/images/default-profile.jpg" alt="${friend.nickName}"
                     style="width:84px;height:84px;border-radius:50%;object-fit:cover;border:1px solid #ececec;display:block;margin:0 auto 8px;">
              </c:otherwise>
            </c:choose>

            <div style="font-weight:800; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
              ${friend.nickName}
            </div>
            <div>${friendMbtiMap[friend.id]}</div>
          </div>
        </c:forEach>
      </div>
    </div>

    <!-- 그룹 목록 -->
    <div class="section" id="groups">
        <c:if test="${empty groupList}">
            <div class="empty-msg">그룹이 없어요 😢<br>그룹에 가입하거나 새 그룹을 개설해보세요!</div>
        </c:if>

        <div class="card-list">
            <c:forEach var="group" items="${groupList}">
                <div class="tile" onclick="location.href='${ctx}/group/detail?groupId=${group.id}'">
                    <c:choose>
                        <c:when test="${group.fileId != null && group.fileId > 0}">
                            <img src="${ctx}/file/preview?fileId=${group.fileId}" alt="${group.title}"
                                 style="width:100%;height:100px;object-fit:cover;border-radius:10px;margin-bottom:8px;"
                                 onerror="this.onerror=null; this.src='${ctx}/resources/images/default-thumb.jpg'">
                        </c:when>
                        <c:otherwise>
                            <img src="${ctx}/resources/images/default-thumb.jpg" alt="기본 썸네일"
                                 style="width:100%;height:100px;object-fit:cover;border-radius:10px;margin-bottom:8px;">
                        </c:otherwise>
                    </c:choose>
                    <div style="font-weight:800; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
                        ${group.title}
                    </div>
                    <div style="color:#666;">${group.location}</div>
                </div>
            </c:forEach>
        </div>
    </div>

</div>

<script>
    // 탭 전환
    document.addEventListener("DOMContentLoaded", function () {
        const tabs = document.querySelectorAll('.tab');
        const sections = document.querySelectorAll('.section');
        tabs.forEach(tab => {
            tab.addEventListener('click', () => {
                tabs.forEach(t => t.classList.remove('active'));
                sections.forEach(s => s.classList.remove('active'));
                tab.classList.add('active');
                document.getElementById(tab.getAttribute('data-target')).classList.add('active');
            });
        });
    });

    // 메뉴 토글
    function toggleMenu(){
        const menu = document.getElementById('menu');
        const btn  = document.querySelector('.menu-btn');
        if(!menu || !btn) return;
        const isOpen = menu.dataset.open === 'true';
        if(!isOpen){
            const r = btn.getBoundingClientRect();
            const menuWidth = Math.max(180, menu.offsetWidth || 180);
            menu.style.position = 'fixed';
            menu.style.top  = (r.bottom + 8) + 'px';
            const left = Math.max(12, Math.min(window.innerWidth - menuWidth - 12, r.right - menuWidth));
            menu.style.left = left + 'px';
            menu.style.display = 'block';
            menu.dataset.open = 'true';
            btn.setAttribute('aria-expanded','true');
            const first = menu.querySelector('a'); if(first) setTimeout(()=> first.focus(), 0);
        }else{
            menu.style.display = 'none';
            menu.dataset.open = 'false';
            btn.setAttribute('aria-expanded','false');
        }
    }

    // 외부 클릭/ESC 닫기
    document.addEventListener('click', (e)=>{
        const menu = document.getElementById('menu');
        const btn  = document.querySelector('.menu-btn');
        if(!menu || !btn) return;
        if(menu.dataset.open === 'true' && !menu.contains(e.target) && !btn.contains(e.target)){
            menu.style.display='none'; menu.dataset.open='false'; btn.setAttribute('aria-expanded','false');
        }
    });
    document.addEventListener('keydown', (e)=>{
        if(e.key==='Escape'){
            const menu=document.getElementById('menu'); const btn=document.querySelector('.menu-btn');
            if(menu && menu.dataset.open==='true'){ menu.style.display='none'; menu.dataset.open='false'; btn?.focus(); btn?.setAttribute('aria-expanded','false'); }
        }
    });

    // ✅ 여기만 교체: 친구 요청/취소/삭제
    function toggleFriendRequest(btn){
        const targetId = btn.getAttribute("data-target");
        const status   = btn.getAttribute("data-status"); // NONE | PENDING | ACCEPTED

        let url, payload = {}, nextText, nextStatus;

        if (status === "NONE") {
            url = '${ctx}/friends/request';
            payload = { responseUserId: targetId };
            nextText = "친구 요청 취소";
            nextStatus = "PENDING";
        } else if (status === "PENDING") {
            url = '${ctx}/friends/cancel';
            payload = { responseUserId: targetId };
            nextText = "친구 요청";
            nextStatus = "NONE";
        } else if (status === "ACCEPTED") {
            url = '${ctx}/profile/friends/delete';
            payload = { friendId: targetId, responseUserId: targetId };
            nextText = "친구 요청";
            nextStatus = "NONE";
        } else {
            return;
        }

        fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': '${_csrf.token}' },
            body: JSON.stringify(payload)
        })
        .then(res => {
            if(res.ok){
                btn.textContent = nextText;
                btn.setAttribute('data-status', nextStatus);
            } else {
                alert("요청 처리 실패");
            }
        })
        .catch(err => console.error(err));
    }
    // ✅ 교체 끝
</script>
</body>
</html>
