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
              <a href="/home" role="button" class="active"
                ><i class="fas fa-house"></i> <span>홈</span></a
              >
            </li>
            <li>
              <a href="/profile" role="button"
                ><i class="fas fa-user-gear"></i> <span>마이페이지</span></a
              >
            </li>
            <li>
              <a href="#" role="button" onclick="toggleNotificationSidebar(true)">
              <i class="fas fa-bell"></i> <span>알림</span></a
              >
            </li>
            <li>
              <a href="/group/list" role="button"
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

    <aside class="notification-sidebar" id="notificationSidebar">
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
              <input type="text" placeholder="닉네임으로 검색..." />
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
          <input type="text" id="chat-input" placeholder="메시지 보내기..." />
          <button onclick="sendMessage()">
            <i class="fas fa-paper-plane"></i>
          </button>
        </div>
      </div>
    </div>