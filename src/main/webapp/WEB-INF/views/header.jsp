<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link rel="stylesheet" href="/resources/css/header.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@stomp/stompjs@7.0.0/bundles/stomp.umd.min.js"></script>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
    <script src="/resources/js/header.js"></script>
    <aside class="sidebar" id="sidebar">
      <div class="sidebar-inner">
        <div class="sidebar-header">
            <img class="logo-svg" src="/resources/images/logo.png"/>
        </div>
        <nav class="sidebar-nav">
          <ul>
            <li>
              <a href="/home" role="button"
                ><i class="fas fa-house"></i> <span>홈</span></a
              >
            </li>
            <li>
              <a href="/profile" role="button"
                ><i class="fas fa-user-gear"></i> <span>마이페이지</span></a
              >
            </li>
            <li>
              <a role="button" onclick="toggleNotificationSidebar(true)">
              <i class="fas fa-bell"></i> <span>알림</span></a
              >
            </li>
            <li>
              <a href="/group/list" role="button"
                ><i class="fas fa-users"></i> <span>모임</span></a
              >
            </li>
            <li>
              <a href="/mbti/board" role="button"
                ><i class="fas fa-clipboard"></i> <span>게시판</span></a
              >
            </li>
          </ul>
        </nav>
      </div>
    </aside>

    <aside class="notification-sidebar" id="notification-sidebar">
      <div class="notification-sidebar-inner">
        <div class="notification-header">
          <h2>알림</h2>
          <i
            class="fas fa-xmark close-notification-btn"
            onclick="toggleNotificationSidebar(false)"
          ></i>
        </div>
        <div class="notification-list">
        </div>
      </div>
    </aside>

    <div id="message-container">
      <div
        id="message-btn"
        onclick="togglePopup('message-popup', true);"
      >
        <i class="far fa-comments"></i>
      </div>

      <div id="message-popup" class="common-popup hide">
        <div class="message-container-header">
          <h2>메시지</h2>
          <i
            class="fas fa-xmark close-btn"
            onclick="togglePopup('message-popup', false)"
          ></i>
        </div>
        <div class="tabs">
          <button
            id="tab-button-0"
            class="tab-button active"
            onclick="openTab('0')"
          >
            친구
          </button>
          <button
            id="tab-button-1"
            class="tab-button"
            onclick="openTab('1')"
          >
            임시
          </button>
          <button
            id="tab-button-2"
            class="tab-button"
            onclick="openTab('2')"
          >
            검색
          </button>
        </div>
        <div id="tab-0" class="tab-content">
          <div class="message-list">
            <p class="empty-message-box">친구가 없습니다.</p>
          </div>
        </div>
        <div id="tab-1" class="tab-content hide">
          <div class="message-list">
            <p class="empty-message-box">임시 친구가 없습니다.</p>
          </div>
        </div>
        <div id="tab-2" class="tab-content hide">
          <div class="search-controls">
            <button class="random-match-btn" onclick="matching()">랜덤 매칭 시작</button>
            <div class="search-box">
              <input type="text" placeholder="닉네임으로 검색..." onkeyup="searchUserList(this.value)"/>
              <i class="fas fa-search search-icon"></i>
            </div>
          </div>
          <div class="message-list">
            <p class="empty-message-box">
              검색어를 입력하거나 랜덤 매칭을 시작하세요.
            </p>
          </div>
        </div>
      </div>

      <div id="chat-popup" class="common-popup hide">
        <div class="message-container-header">
            <div class="user-info">
              <img
                id="chat-user-avatar"
                src=""
              />
              <div class="user-details">
                <h2 id="chat-user-name">상대방 닉네임</h2>
                <p id="chat-user-mbti">MBTI 정보</p>
              </div>
            </div>
            <i class="fas fa-xmark close-btn" onclick="closeChat()"></i>
          </div>
        <div id="chat-body" class="chat-body"></div>
        <div class="chat-footer">
          <input type="text" id="chat-input" placeholder="메시지 보내기..." autocomplete="off" />
          <button onclick="sendMessage()">
            <i class="fas fa-paper-plane"></i>
          </button>
        </div>
      </div>
    </div>