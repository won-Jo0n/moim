<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<link
  rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
/>
<style>
  :root {
    --sidebar-width-desktop: 250px;
    --sidebar-width-tablet: 72px;
    --sidebar-nav-icon-size: 30px;
    --sidebar-height-mobile: 80px;
  }
  body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
      Helvetica, Arial, sans-serif;
    background-color: #fafafa;
    margin: 0;
    padding: 0px 0px 0px var(--sidebar-width-desktop);
  }

  .sidebar {
    width: var(--sidebar-width-desktop);
    height: 100vh;
    background-color: #ffffff;
    border-right: 1px solid #dbdbdb;
    position: fixed;
    top: 0;
    left: 0;
    box-sizing: border-box;
    z-index: 1000;
  }

  .sidebar-inner {
    display: flex;
    flex-direction: column;
    height: 100%;
    padding: 20px 10px;
  }

  .sidebar-header {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 10px;
    margin-bottom: 20px;
  }

  .sidebar-nav {
    flex-grow: 1;
  }

  .sidebar-nav ul {
    list-style: none;
    padding: 0;
    margin: 0;
  }

  .sidebar-nav li {
    margin-bottom: 5px;
  }

  .sidebar-nav a {
    display: flex;
    align-items: center;
    padding: 12px 10px;
    text-decoration: none;
    color: #262626;
    font-size: 1rem;
    font-weight: 600;
    border-radius: 8px;
    transition: background-color 0.2s ease, color 0.2s ease;
    cursor: pointer;
  }

  .sidebar-nav a:hover {
    background-color: #f0f0f0;
  }

  .sidebar-nav a.active {
    background-color: #dbdbdb;
  }

  .sidebar-nav a i {
    display: inline-block;
    width: var(--sidebar-nav-icon-size);
    font-size: 1.25rem;
    text-align: center;
    margin-right: 15px;
    transition: margin-right 0.3s ease;
  }

  .sidebar-nav a span {
    white-space: nowrap;
    opacity: 1;
    transition: opacity 0.3s ease;
  }

  .logo-svg {
    width: 100px;
    height: auto;
    animation: logo-bounce 2s ease-in-out infinite;
  }

  @keyframes logo-bounce {
    0%,
    100% {
      transform: translateY(3px);
    }
    50% {
      transform: translateY(-3px);
    }
  }

  /* 메시지 컨테이너 start */

  #message-container {
    position: fixed;
    bottom: 30px;
    right: 30px;
    z-index: 1001;
  }
  .common-popup {
    position: absolute;
    bottom: 0;
    right: 0;
    width: 380px;
    height: 500px;
    background-color: #ffffff;
    border: 1px solid #dbdbdb;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
    overflow: hidden;
    display: flex;
    flex-direction: column;
  }
  .hide {
    display: none !important;
  }

  #message-btn {
    background-color: #ffffff;
    border: 1px solid #dbdbdb;
    border-radius: 30px;
    width: 60px;
    height: 60px;
    display: flex;
    justify-content: center;
    box-sizing: border-box;
    align-items: center;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
    cursor: pointer;
    transition: transform 0.2s ease-in-out;
  }

  #message-btn:hover {
    background-color: #f0f0f0;
  }

  #message-btn i {
    font-size: 1.5rem;
    color: #262626;
  }

  /* 헤더 스타일 */
  .header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 15px 20px;
    border-bottom: 1px solid #dbdbdb;
  }
  .header h2 {
    margin: 0;
    font-size: 1.1rem;
    font-weight: 600;
    color: #262626;
  }
  .close-btn {
    cursor: pointer;
    font-size: 1.2rem;
    color: #8e8e8e;
    transition: color 0.2s ease;
  }
  .close-btn:hover {
    color: #262626;
  }

  /* 탭 스타일 */
  .tabs {
    display: flex;
    border-bottom: 1px solid #dbdbdb;
  }
  .tab-button {
    flex: 1;
    padding: 15px 0;
    background-color: #f8f8f8;
    border: none;
    cursor: pointer;
    font-size: 1rem;
    font-weight: 600;
    color: #8e8e8e;
  }
  .tab-button.active {
    color: #262626;
    background-color: #ffffff;
    border-bottom: 2px solid #0095f6;
  }
  .tab-content {
    flex: 1;
    overflow-y: auto;
  }

  /* 메시지 목록 스타일 */
  .message-list {
    padding: 10px;
  }
  .message-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 15px;
    border-radius: 10px;
    margin-bottom: 5px;
    cursor: pointer;
  }
  .message-item:hover {
    background-color: #f0f0f0;
  }
  .message-item .avatar {
    width: 44px;
    height: 44px;
    border-radius: 50%;
    margin-right: 15px;
    border: 1px solid #dbdbdb;
    flex-shrink: 0;
  }
  .message-item-content {
    flex-grow: 1;
  }
  .message-item-content h3 {
    margin: 0 0 4px 0;
    font-size: 0.95rem;
    font-weight: 600;
    color: #262626;
  }
  .message-item-content p {
    margin: 0;
    font-size: 0.85rem;
    color: #8e8e8e;
  }
  .action-buttons {
    display: flex;
    gap: 8px;
    flex-shrink: 0;
  }
  .action-buttons button {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    border: 1px solid #dbdbdb;
    background-color: #ffffff;
    cursor: pointer;
    transition: background-color 0.2s ease;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .action-buttons .accept-btn {
    color: #38a169;
  }
  .action-buttons .decline-btn {
    color: #e53e3e;
  }
  .action-buttons button:hover {
    background-color: #f0f0f0;
  }

  /* 검색/랜덤 매칭 스타일 */
  .search-controls {
    padding: 15px;
    border-bottom: 1px solid #dbdbdb;
  }
  .search-box {
    position: relative;
    margin-top: 10px;
  }
  .search-box input {
    width: 100%;
    padding: 10px 15px 10px 40px;
    border: 1px solid #dbdbdb;
    border-radius: 8px;
    font-size: 0.9rem;
    box-sizing: border-box;
  }
  .search-box .search-icon {
    position: absolute;
    left: 15px;
    top: 50%;
    transform: translateY(-50%);
    color: #8e8e8e;
  }
  .random-match-btn {
    width: 100%;
    padding: 10px;
    background-color: #0095f6;
    color: white;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-size: 0.95rem;
    font-weight: 600;
  }

  /* 채팅 팝업 스타일 */
  #chat-popup {
    z-index: 1002;
  }
  #chat-popup .header {
    padding: 10px 20px;
  }
  #chat-popup .header .user-info {
    display: flex;
    align-items: center;
  }
  #chat-popup .header .user-info img {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    margin-right: 10px;
  }
  #chat-popup .header .user-info h3 {
    font-size: 1rem;
  }
  .chat-body {
    flex: 1;
    padding: 15px;
    overflow-y: auto;
    display: flex;
    flex-direction: column-reverse;
  }
  .chat-footer {
    padding: 10px 15px;
    border-top: 1px solid #dbdbdb;
    display: flex;
  }
  .chat-footer input {
    flex: 1;
    padding: 10px 15px;
    border: 1px solid #dbdbdb;
    border-radius: 20px;
    font-size: 0.9rem;
    outline: none;
  }
  .chat-footer button {
    background-color: transparent;
    border: none;
    color: #0095f6;
    font-size: 1.2rem;
    margin-left: 10px;
    cursor: pointer;
  }
  .chat-message {
    max-width: 70%;
    padding: 10px;
    margin-bottom: 10px;
    border-radius: 15px;
    line-height: 1.4;
  }
  .chat-message.sent {
    background-color: #0095f6;
    color: white;
    align-self: flex-end;
    border-bottom-right-radius: 5px;
  }
  .chat-message.received {
    background-color: #efefef;
    color: #262626;
    align-self: flex-start;
    border-bottom-left-radius: 5px;
  }

  /* 메시지 컨테이너 end */

  @media (min-width: 768px) and (max-width: 1023px) {
    body {
      padding-left: var(--sidebar-width-tablet);
    }

    .sidebar {
      width: var(--sidebar-width-tablet);
    }

    .logo-svg {
      width: var(--sidebar-nav-icon-size);
      animation: none;
    }

    .sidebar-nav a {
      justify-content: center;
      padding: 12px 0;
    }

    .sidebar-nav a i {
      margin-right: 0;
    }

    .sidebar-nav a span {
      display: none;
    }
  }

  @media (max-width: 767px) {
    body {
      padding-left: 0px;
      padding-bottom: var(--sidebar-height-mobile);
    }

    #message-container {
      width: 60px;
      bottom: calc(var(--sidebar-height-mobile) + 30px);
    }

    .sidebar {
      width: 100%;
      height: auto;
      top: auto;
      bottom: 0;
      border-right: none;
      border-top: 1px solid #dbdbdb;
    }

    .sidebar-inner {
      flex-direction: row;
      justify-content: space-around;
      padding: 10px 0;
    }

    .sidebar-header {
      display: none;
    }

    .sidebar-nav {
      width: 100%;
    }

    .sidebar-nav ul {
      display: flex;
      justify-content: space-around;
      width: 100%;
    }

    .sidebar-nav li {
      margin: 0;
    }

    .sidebar-nav a {
      padding: 10px;
      flex-direction: column;
      align-items: center;
    }

    .sidebar-nav a i {
      margin-right: 0;
      font-size: 1.5rem;
    }

    .sidebar-nav a span {
      font-size: 0.625rem;
    }
  }
</style>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@stomp/stompjs@7.0.0/bundles/stomp.umd.min.js"></script>
<script>
  window.addEventListener("DOMContentLoaded", () => {
    if (window.location.pathname == "/chat") {
      document.getElementById("message-container").classList.add("hide");
    }
  });

  function togglePopup(popupId, show) {
    document.getElementById(popupId).classList.toggle("hide", !show);
  }

  function openTab(tabName) {
    document
      .querySelectorAll(".tab-content")
      .forEach((tab) => tab.classList.add("hide"));
    document
      .querySelectorAll(".tab-button")
      .forEach((btn) => btn.classList.remove("active"));

    document.getElementById(tabName + "-tab").classList.remove("hide");
    document.getElementById("tab-" + tabName).classList.add("active");

    const messageList = $("#" + tabName + "-tab .message-list");
    messageList.empty();
    //chat spinner 활성화
    if (tabName == "friends") {
      $.ajax({
        url: "/friends/chat",
        type: "GET",
        contentType: "application/json",
        success: function (data) {
          data.forEach((friend) => {
            console.log(friend.nickName);
            let friendItem = `<div>${friend.nickName}</div>`;
            /*
            const friendItem = $(`
                        <div
                          class="message-item"
                          data-user-id="friend-${friend.id}"
                          onclick="openChat(this)"
                        >
                          <img src="${friend.avatar}" class="avatar" />
                          <div class="message-item-content">
                            <h3>${friend.nickName}</h3>
                            <p>@${friend.loginId} · 1시간 전</p>
                          </div>
                        </div>
                      `);
            */
            messageList.append(friendItem);
          });
        },
      });
    }
  }

  function openChat(element) {
    togglePopup("message-popup", false);
    togglePopup("chat-popup", true);

    /*
        document.getElementById("chat-user-name").textContent = userName;
        document.getElementById("chat-user-avatar").src = userAvatar;

        $("#chat-body").empty();
        //spinner gif 활성화

        $.ajax({
          url: '/get-chat-history', // 실제 서버 엔드포인트로 변경
          type: 'POST',
          contentType: 'application/json',
          data: JSON.stringify({
            userName: userName
          }),
          success: function(data) {
            // 성공적으로 데이터를 받아왔을 때의 처리
            console.log('채팅 기록:', data);
            // displayChatMessages(data);
          },
          error: function(xhr, status, error) {
            // 요청 실패 시 처리
            console.error('채팅 기록을 가져오는 중 오류 발생:', error);
          }
        });
        */
  }

  function closeChat() {
    togglePopup("chat-popup", false);
    togglePopup("message-popup", true);
  }

  function sendMessage() {
    const inputElement = document.getElementById("chat-input");
    const message = inputElement.value.trim();

    if (message) {
      const chatBody = document.getElementById("chat-body");
      const messageElement = document.createElement("div");
      messageElement.classList.add("chat-message", "sent");
      messageElement.textContent = message;
      chatBody.prepend(messageElement);

      inputElement.value = ""; // 입력창 비우기
      console.log("메시지 전송: " + message);
    }
  }

  function handleFriendRequest(action, buttonElement) {
    const messageItem = buttonElement.closest(".message-item");
    const userName = messageItem.querySelector("h3").textContent;

    if (action === "accept") {
      console.log(`${userName}님의 친구 요청을 수락했습니다.`);
      // 여기에 친구 수락 로직 (예: 서버 API 호출) 추가
      alert(`${userName}님을 친구로 추가했습니다!`);
    } else if (action === "decline") {
      console.log(`${userName}님의 친구 요청을 거절했습니다.`);
      // 여기에 친구 거절 로직 (예: 서버 API 호출) 추가
      alert(`${userName}님의 요청을 거절했습니다.`);
    }

    // 요청 처리 후 해당 항목 숨기기
    messageItem.style.display = "none";
  }

  const stompClient = new StompJs.Client({
    webSocketFactory: () => new SockJS("/ws-stomp"),
  });
  stompClient.onWebSocketError = (error) => {
    console.error("Error with websocket", error);
  };
  stompClient.onStompError = (frame) => {
    console.error("Broker reported error: " + frame.headers["message"]);
    console.error("Additional details: " + frame.body);
  };
  stompClient.onDisconnect = (frame) => {
    console.error("Server Disconnect");
  };
  stompClient.onConnect = (frame) => {
    stompClient.subscribe("/user/queue/main", (msg) => {
      const map = JSON.parse(msg.body);
      switch (map.type) {
        case "FRIEND_ONLINE":
          console.log(map.sender);
          break;
        case "FRIEND_OFFLINE":
          console.log(map.sender);
          break;
      }
    });
  };

  $(function () {
    stompClient.activate();
  });
</script>

<aside class="sidebar" id="sidebar">
  <div class="sidebar-inner">
    <div class="sidebar-header">
      <svg
        version="1.1"
        class="logo-svg"
        width="181.25076"
        height="236.72769"
        viewBox="0 0 181.25076 236.72769"
        xmlns="http://www.w3.org/2000/svg"
        xmlns:svg="http://www.w3.org/2000/svg"
      >
        <defs>
          <lineargradient id="grad">
            <stop offset="0%">
              <animate
                attributeName="stop-color"
                values="#9708CC; #43CBFF; #9708CC"
                dur="4s"
                repeatCount="indefinite"
              ></animate>
            </stop>

            <stop offset="100%">
              <animate
                attributeName="stop-color"
                values="#43CBFF; #9708CC; #43CBFF"
                dur="4s"
                repeatCount="indefinite"
              ></animate>
            </stop>
          </lineargradient>
        </defs>
        <g transform="translate(-210.63925,-109.55234)">
          <path
            style="fill: url(#grad)"
            d="M 297.10209,345.74186 C 289.93075,343.18128 288.2348,334.82402 293.84584,329.69585 299.85573,324.20314 310.11212,328.63952 310.11212,336.73178 310.11212,343.15919 303.22573,347.92834 297.10209,345.74186 Z M 298.43832,318.54907 C 286.02644,315.07482 295.15761,297.73245 314.28007,288.46164 352.65972,269.85472 375.54939,236.14557 375.60088,198.15579 375.69928,125.52802 278.9476,97.858054 238.23027,158.86923 223.44572,181.02251 223.05256,213.95442 237.30083,236.72069 240.94424,242.54223 239.74477,247.48734 234.23384,249.3651 227.61664,251.61981 222.8901,247.22951 217.41595,233.74358 191.62378,170.20298 243.03168,102.42572 311.15411,110.15723 354.72002,115.10172 385.01611,145.00085 391.13166,189.08691 397.12673,232.30437 367.01124,280.83055 320.83064,302.36556 311.44557,306.742 311.57334,306.63855 309.08677,311.87534 306.33735,317.66571 302.92431,319.80476 298.43832,318.54907 Z M 277.05188,257.18732 C 274.80026,255.66995 274.8436,255.96379 274.747,241.56015 274.6926,233.45639 274.7732,228.26764 274.96453,227.55729 276.04356,223.55004 281.93503,222.95274 283.6266,226.67909 284.46788,228.53234 284.52336,253.81143 283.6898,255.47055 282.5259,257.78716 279.21331,258.6439 277.05189,257.18732 Z M 295.59598,257.26432 C 293.38437,255.91588 293.44265,256.35721 293.4414,240.94824 293.4394,225.8472 293.3957,226.24961 295.23871,224.6988 296.93509,223.27139 300.32661,223.68193 302.04639,225.52287 302.76314,226.29012 302.76314,226.29012 304.07806,225.07806 308.20074,221.27792 315.57332,221.75643 319.19382,226.05913 319.94113,226.94726 319.94113,226.94726 321.50184,225.53651 328.1003,219.57206 338.61305,222.46562 341.4205,231.01897 342.35812,233.87561 342.63338,253.77886 341.75866,255.4705 340.23742,258.41244 335.79756,258.69478 333.8013,255.97654 333.2145,255.17752 333.17724,254.65261 333.02985,245.11009 332.85792,233.97878 332.82342,233.77112 330.85995,232.04716 328.33935,229.83405 324.51859,230.69011 322.83096,233.84609 322.19394,235.03737 322.16389,235.46106 322.02056,245.27546 321.84962,256.97966 321.68817,257.49034 318.06383,257.79089 313.37428,258.17979 312.97644,257.18519 312.79152,244.60998 312.6643,235.95965 312.57133,234.35783 312.15214,233.59397 310.20376,230.04355 305.66653,229.94023 303.63269,233.39999 302.81819,234.78552 302.81819,234.78552 302.66933,244.96123 302.52746,254.65962 302.49155,255.17631 301.9039,255.97654 300.55923,257.80756 297.50848,258.43038 295.59598,257.26432 Z M 277.95931,219.71516 C 275.14706,218.59706 274.18895,215.13911 276.0715,212.90182 279.6171,208.68812 286.10225,212.79334 283.61182,217.67498 282.62475,219.60978 280.0404,220.54257 277.95931,219.71516 Z M 324.69996,202.33709 C 306.99247,198.33748 305.96162,171.78018 323.3012,166.30155 338.6775,161.44323 352.07332,177.95177 344.81184,192.81049 341.31581,199.96418 332.55883,204.11219 324.69996,202.33709 Z M 332.90864,193.16432 C 341.81023,188.61642 338.63526,174.36019 328.71905,174.35229 318.76423,174.34429 315.91201,189.57434 325.14652,193.42847 327.5043,194.41252 330.67686,194.30455 332.90864,193.16432 Z M 256.79142,200.91495 C 254.71309,199.52653 254.73882,199.73183 254.73831,184.5372 254.73771,169.5196 254.73331,169.55396 256.56695,168.16254 258.59041,166.62654 261.20734,166.74516 263.10421,168.45887 264.28997,169.53013 264.28997,169.53013 265.24485,168.61154 269.25966,164.74925 276.27555,165.02141 280.43148,169.20066 281.99964,170.77763 281.99964,170.77763 282.87122,169.77095 288.62502,163.12531 299.86747,165.25747 303.30581,173.64642 304.4708,176.48879 304.76378,197.47154 303.66806,199.59043 302.28713,202.26084 297.65948,202.27224 295.91258,199.60953 295.43151,198.87625 295.35822,197.76338 295.21073,188.95215 295.00785,176.83055 294.69382,175.77559 290.99181,174.77874 285.36961,173.26484 284.13246,175.74245 283.92164,188.938 283.81565,195.57224 283.65271,198.95582 283.41987,199.35789 281.64497,202.4229 276.92602,202.37643 275.38604,199.27879 274.89161,198.28426 274.81765,197.13133 274.68449,188.34259 274.54987,179.45798 274.48134,178.40878 273.96811,177.37514 272.54969,174.51845 268.42142,173.69283 266.09701,175.80096 264.44463,177.2996 264.42503,177.43378 264.2646,188.34259 264.09959,199.56342 264.05749,199.80878 262.09174,201.00736 260.71185,201.84873 258.12161,201.80357 256.79142,200.91496 Z"
          />
        </g>
      </svg>
    </div>
    <nav class="sidebar-nav">
      <ul>
        <li>
          <a href="#" role="button" class="active"
            ><i class="fas fa-house"></i> <span>홈</span></a
          >
        </li>
        <li>
          <a href="#" role="button"
            ><i class="fas fa-user-gear"></i> <span>마이페이지</span></a
          >
        </li>
        <li>
          <a href="#" role="button"
            ><i class="fas fa-bell"></i> <span>알림</span></a
          >
        </li>
        <li>
          <a href="#" role="button"
            ><i class="fas fa-comments"></i> <span>메시지</span></a
          >
        </li>
        <li>
          <a href="#" role="button"
            ><i class="fas fa-users"></i> <span>모임</span></a
          >
        </li>
        <li>
          <a href="#" role="button"
            ><i class="fas fa-clipboard"></i> <span>게시판</span></a
          >
        </li>
      </ul>
    </nav>
  </div>
</aside>

<div id="message-container">
  <div
    id="message-btn"
    onclick="openTab('friends'); togglePopup('message-popup', true);"
  >
    <i class="far fa-comments"></i>
  </div>

  <div id="message-popup" class="common-popup hide">
    <div class="header">
      <h2>메시지</h2>
      <i
        class="fas fa-xmark close-btn"
        onclick="togglePopup('message-popup', false)"
      ></i>
    </div>
    <div class="tabs">
      <button
        id="tab-friends"
        class="tab-button active"
        onclick="openTab('friends')"
      >
        친구
      </button>
      <button
        id="tab-non-friends"
        class="tab-button"
        onclick="openTab('non-friends')"
      >
        임시
      </button>
      <button id="tab-search" class="tab-button" onclick="openTab('search')">
        검색
      </button>
    </div>
    <div id="friends-tab" class="tab-content">
      <div class="message-list">
        <div class="message-item" onclick="openChat(this)">
          <img src="" class="avatar" />
          <div class="message-item-content">
            <h3>Taek June</h3>
            <p>@taekjune · 1시간 전</p>
          </div>
        </div>
      </div>
    </div>
    <div id="non-friends-tab" class="tab-content hide">
      <div class="message-list">
        <div class="message-item">
          <img src="" class="avatar" />
          <div class="message-item-content">
            <h3>@user123</h3>
            <p>임시 채팅 요청</p>
          </div>
          <div class="action-buttons">
            <button
              class="accept-btn"
              onclick="handleFriendRequest('accept', this)"
            >
              <i class="fas fa-check"></i>
            </button>
            <button
              class="decline-btn"
              onclick="handleFriendRequest('decline', this)"
            >
              <i class="fas fa-xmark"></i>
            </button>
          </div>
        </div>
      </div>
    </div>
    <div id="search-tab" class="tab-content hide">
      <div class="search-controls">
        <button class="random-match-btn">랜덤 매칭 시작</button>
        <div class="search-box">
          <input type="text" placeholder="닉네임으로 검색..." />
          <i class="fas fa-search search-icon"></i>
        </div>
      </div>
      <div class="message-list">
        <p style="text-align: center; color: #8e8e8e; padding: 20px">
          검색어를 입력하거나 랜덤 매칭을 시작하세요.
        </p>
      </div>
    </div>
  </div>

  <div id="chat-popup" class="common-popup hide">
    <div class="header">
      <div class="user-info">
        <img id="chat-user-avatar" src="" alt="유저 아바타" />
        <h3 id="chat-user-name"></h3>
      </div>
      <i class="fas fa-xmark close-btn" onclick="closeChat()"></i>
    </div>
    <div id="chat-body" class="chat-body">
      <div class="chat-message received">안녕하세요!</div>
      <div class="chat-message sent">안녕하세요</div>
    </div>
    <div class="chat-footer">
      <input type="text" id="chat-input" placeholder="메시지 보내기..." />
      <button onclick="sendMessage()">
        <i class="fas fa-paper-plane"></i>
      </button>
    </div>
  </div>
</div>
