const header = {
    notificationUnread : 0,
    chatUnread : 0,
    chatUser : null
};
const stompClient = new StompJs.Client({
  webSocketFactory: () => new SockJS("/ws-stomp"),
});
stompClient.onWebSocketError = (error) => {
  console.error("WEBSOCKET ERROR", error);
};
stompClient.onStompError = (frame) => {
    console.error("STOMP ERROR", frame);
  //console.error("Broker reported error: " + frame.headers["message"]);
  //console.error("Additional details: " + frame.body);
};
stompClient.onDisconnect = (frame) => {
   console.error("DISCONNECT", frame);
};
stompClient.onConnect = (frame) => {
  stompClient.subscribe("/user/queue/main", (msg) => {
    const data = JSON.parse(msg.body);
    let messageItem;
    switch (msg.headers.type) {
      case "FRIEND_ONLINE":
        $(`div[data-user-id="${data.sender}"] .online-indicator`).addClass("online");
        break;
      case "FRIEND_OFFLINE":
        $(`div[data-user-id="${data.sender}"] .online-indicator`).removeClass("online");
        break;
      case "SEND_MESSAGE":
        refreshMessageItem($(`div[data-user-id="${data.responseUserId}"]`), data);
        if(header.chatUser && header.chatUser.id == data.responseUserId){
            createChatItem(data);
        }
        break;
      case "RECEIVE_MESSAGE":
        messageItem = $(`div[data-user-id="${data.requestUserId}"]`);
        refreshMessageItem(messageItem, data);
        if(header.chatUser && header.chatUser.id == data.requestUserId){
            createChatItem(data);
            stompClient.publish({
              destination: "/app/chat",
              headers: { type: "READ_MESSAGE" },
              body: JSON.stringify({
                chatUserId: header.chatUser.id,
                chatId: header.chatUser.lastChatId,
              }),
            });
        }else if(!header.chatUser || header.chatUser.id != data.requestUserId){
            const unreadDiv = messageItem.find(".message-info > div");
            unreadDiv.text(parseInt(unreadDiv.text() || "0") + 1);
            header.chatUnread++;
        }
        break;
      case "READ_MESSAGE_SELF":
        //console.log("내가 " + data.sender + "의 글을 " + data.readCount + "개 읽음");
        messageItem = $(`div[data-user-id="${data.sender}"]`);
        const unreadDiv = messageItem.find(".message-info > div");
        const afterCount = parseInt(unreadDiv.text() || "0") - data.readCount;
        unreadDiv.text(afterCount > 0 ? afterCount : "");
        header.chatUnread -= data.readCount;
        if(header.chatUser && header.chatUser.id == data.sender){
            $(".chat-message-wrapper.received").slice(-data.readCount).addClass("read");
        }
        break;
      case "READ_MESSAGE_OTHER":
        //console.log(data.reader + "가 나의 글을 " + data.readCount + "개 읽음" + ", " + data.chatId);
        if(header.chatUser && header.chatUser.id == data.reader){
            $(".chat-message-wrapper.sent").slice(-data.readCount).addClass("read");
        }
        break;
      case "SEND_REQUEST":
        $(`div[data-user-id="${data.id}"]`).remove();
        break;
      case "RECEIVE_REQUEST":
        $(`div[data-user-id="${data.id}"]`).remove();
        header.chatUnread++;
        createMessageItem(data);
        break;
      case "SEND_REQUEST_RESPONSE":
        $(`div[data-user-id="${data.id}"]`).remove();
        header.chatUnread--;
        break;
      case "FRIEND_NEW":
        createMessageItem(data);
        break;
      case "MATCH_JOIN":
        console.log("MATCH JOIN");
        break;
      case "MATCH_FOUND":
        openChat(createMessageItem(data));
        break;
    }
  });
};

function refreshMessageItem(element, data){
    element.find(".main-text > p").text(data.content);
    element.find(".message-info > span").text(formatLastChatTime(data.sendAt)); //"어제"가 잘 안나오니 그쪽로직 확인
    element.parent().find(".empty-message-box").after(element);
}


$(function () {
    const navLinks = $(".sidebar-nav li > a");
    const currentPath = window.location.pathname;
    navLinks.each((index, element) => {
        if ($(element).attr("href") == currentPath) {
            $(element).addClass('active');
        }else{
            $(element).removeClass('active');
        }
    });

    //stompClient.heartbeat.outgoing = 20000; // 20초마다 서버로 하트비트 신호 전송
    //stompClient.heartbeat.incoming = 20000;
    stompClient.activate();
    $.ajax({
      url: "/chat/friends",
      type: "GET",
      contentType: "application/json",
      success: function (data) {
        //user.status가 3이면 임시 요청 중
        //user.status가 2이면 임시 친구
        //user.status가 1이면 친구
        //user.status가 0 이나 -1이면 친구 아님
        data.forEach((user) => {
          createMessageItem(user);
          if(user.status <= 2){
            header.chatUnread += user.unreadCount;
          }else{
            header.chatUnread++;
          }
        });
      },
      error: function (xhr, status, error) {
        console.error("채팅 기록을 가져오는 중 오류 발생:", error);
      },
    });
    $('#chat-input').keypress(function(event) {
      if (event.which === 13) {
        sendMessage();
      }
    });


// 목업 데이터
    const mockNotifications = [
      {
        id: 1,
        userId: 101,
        requestUserId: 201,
        type: 'FRIEND_REQUEST',
        relatedId: 201,
        content: '권택준',
        createdAt: '2025-08-10T10:00:00Z',
        readAt: null,
        path: null,
        status: 1
      },
      {
        id: 2,
        userId: 101,
        type: 'NEW_SCHEDULE',
        relatedId: 301,
        content: '스터디 모임',
        createdAt: '2025-08-10T11:30:00Z',
        readAt: '2025-08-10T12:00:00Z',
        path: '/groups/301/schedule',
        status: 1
      },
      {
        id: 3,
        userId: 101,
        requestUserId: 401,
        type: 'NEW_COMMENT',
        relatedId: 501,
        content: '권택준',
        createdAt: '2025-08-10T14:20:00Z',
        readAt: null,
        path: '/feed/501',
        status: 1
      },
      {
        id: 4,
        userId: 101,
        type: 'REPORT_COMPLETED',
        relatedId: 601,
        content: '회원님께서 신고하신 건에 대한 처리가 완료되었습니다.',
        createdAt: '2025-08-10T09:00:00Z',
        readAt: '2025-08-10T09:10:00Z',
        path: '/report/601',
        status: 1
      },
      {
        id: 5,
        userId: 101,
        type: 'FRIEND_REQUEST',
        relatedId: 202,
        content: '홍길동',
        createdAt: '2025-08-10T16:00:00Z',
        readAt: null,
        path: null,
        status: 1
      }
    ];
    const notificationList = $("#notification-sidebar .notification-list");
    console.log(notificationList);
    mockNotifications.forEach((notification) => {
        notificationList.append(createNotificationItem(notification));
    });


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

  document.getElementById("tab-"+tabName).classList.remove("hide");
  document.getElementById("tab-button-" + tabName).classList.add("active");
}
function createMessageItem(user) {
    const messageList= $("#tab-" + ((Math.min(2, Math.max(0, user.status)) + 2) % 3) + " .message-list");
    const messageItem = $(`<div class="message-item"
           data-user-id='${user.id}'
           ${user.status == 1 || user.status == 2 ? " onclick='openChat(this)'" : ""}
         >
           <div class="avatar">
             <img src="/file/preview/?id=${user.fileId}" />
             ${user.status == 1 ? "<div class='online-indicator'></div>" : ""}
           </div>
           <div class="user-info">
             <h3>${user.nickName}</h3>
             <p>${user.mbti}</p>
           </div>
           <div class="main-text">
             <p>${(user.status == 1 || user.status == 2) && user.lastChatContent ? user.lastChatContent : "" }</p>
           </div>
           ${
             user.status == 1 || user.status == 2
               ? "<div class='message-info'><span>" +
                 (user.lastChatTime ? formatLastChatTime(user.lastChatTime) : "") +
                 "</span><div>" +
                 (user.unreadCount > 0 ? user.unreadCount : "") +
                 "</div></div>"
               : ""
           }
           ${
             user.status == 3
               ? "<button class='accept-btn' onclick='handleFriendRequest(\"accept\", this.parentElement)'><i class='fas fa-check'></i></button><button class='decline-btn' onclick='handleFriendRequest(\"decline\", this.parentElement)'><i class='fas fa-xmark'></i></button>"
               : ""
           }
           ${
             user.status <= 0
               ? "<button class='request-btn' onclick='handleFriendRequest(\"request\", this.parentElement)'>채팅</button>"
               : ""
           }
     </div>`)
    messageList.append(messageItem);
    return messageItem;
}
function openChat(element) {
  const elem = $(element);
  const imgSrc = elem.find(".avatar > img").attr("src");
  const nickName = elem.find(".user-info > h3").text();
  const mbti = elem.find(".user-info > p").text();
  const userId = elem.attr("data-user-id");
  header.chatUserId = userId;
  $.ajax({
    url: `/chat/messages/${userId}`,
    type: "GET",
    contentType: "application/json",
    success: function (data) {
      $("#chat-body").empty();
      togglePopup("message-popup", false);
      togglePopup("chat-popup", true);
      document.getElementById("chat-user-avatar").src = imgSrc;
      document.getElementById("chat-user-name").textContent = nickName;
      document.getElementById("chat-user-mbti").textContent = mbti;
      header.chatUser = {
        id : userId,
      };
      data.forEach((chat) => {
        createChatItem(chat);
      });
      stompClient.publish({
          destination: "/app/chat",
          headers: { type : "READ_MESSAGE" },
          body: JSON.stringify({
              chatUserId : header.chatUser.id,
              chatId : header.chatUser.lastChatId ?? -1,
          })
      });
      $("#chat-input").focus();
    },
    error: function (xhr, status, error) {
      console.error("채팅 기록을 가져오는 중 오류 발생:", error);
    },
  });
}

function toggleNotificationSidebar(show) {
        if (show) {
          $("#notification-sidebar").addClass("show");
        } else {
          $("#notification-sidebar").removeClass("show");
        }
}

function update(reqId, status, element){
    $.ajax({
          url: "/friends/update",
          type: "GET",
          contentType: "application/json",
          data : {
            reqId : reqId,
            status : status
          },
          success: function (data) {
            element.parentElement.remove();
          },
          error: function (xhr, status, error) {
            console.error("알림 가져오는 중 오류 발생:", error);
          }
      });
}

function createNotificationItem(notification) {
  const typeClass = notification.type == "FRIEND_REQUEST" ? "" : "notification-btn";
  let iconClass = "";
  let notificationText = "";
  let actionsHtml = "";
  switch (notification.type) {
    case "FRIEND_REQUEST":
      iconClass = "fas fa-user-plus";
      notificationText = `<strong>${notification.content}</strong>님이 친구를 요청했습니다.`;
      actionsHtml = `
        <div class="notification-actions">
          <button class="accept-btn" onclick="acceptFriendRequest(${notification.requestUserId})">
            수락
          </button>
          <button class="decline-btn" onclick="declineFriendRequest(${notification.requestUserId})">
            거절
          </button>
        </div>
      `;
      break;
    case "NEW_SCHEDULE":
      iconClass = "fas fa-calendar-alt";
      notificationText = `<strong>${notification.content}</strong> 모임에 새로운 일정이 등록되었습니다.`;
      break;
    case "NEW_COMMENT":
      iconClass = 'fas fa-comment';
      notificationText = `<strong>${notification.content}</strong>님이 내 피드에 댓글을 남겼습니다.`;
      break;
    case "REPORT_COMPLETED":
      iconClass = 'fas fa-check-circle';
      notificationText = notification.content;
      break;
    default:
      iconClass = "fas fa-bell";
      notificationText = '새로운 알림이 도착했습니다.';
      break;
  }
  const notificationItem =
  $(`
     <div class="notification-item ${typeClass}">
       <div class="notification-content">
         <i class="${iconClass} notification-icon"></i>
         <span class="notification-text">
           ${notificationText}
         </span>
       </div>
       ${actionsHtml}
     </div>
   `);
  if (notification.type != "FRIEND_REQUEST") {
    notificationItem.on("click", () => {
      // 읽음 처리 API 호출 등의 추가 로직
      markAsRead(notification.id);
      // 페이지 이동
      window.location.href = notification.path;
    });
  }
  return notificationItem;
}

function searchUserList(search){
    if(search){
        $.ajax({
              url: "/chat/searchUserList",
              type: "GET",
              contentType: "application/json",
              data: {
                search : search
              },
              success: function (data) {
                $("#tab-2 .message-list").children().not(".empty-message-box").remove();
                data.forEach((user)=>{
                    createMessageItem(user);
                });
              },
              error: function (xhr, status, error) {
                console.log("유저 검색 실패");
              }
          });
      }
}


function closeChat() {
    header.chatUser = null;
  togglePopup("chat-popup", false);
  togglePopup("message-popup", true);
}

function matching(){
    stompClient.publish({
      destination: "/app/match",
      body: "asdf"
    });
}

function formatLastChatTime(sendAtString) {
  const sendAt = new Date(sendAtString);
  const now = new Date();
  const isToday = sendAt.toDateString() === now.toDateString();
  const diffInDays = Math.floor((now - sendAt) / (1000 * 60 * 60 * 24));
  const isYesterday = diffInDays === 1 && now.toDateString() !== sendAt.toDateString();
  if (isToday) {
    let hours = sendAt.getHours();
    const minutes = String(sendAt.getMinutes()).padStart(2, '0');
    const ampm = hours >= 12 ? '오후' : '오전';
    hours = hours % 12;
    hours = hours === 0 ? 12 : hours;
    return `${ampm} ${hours}:${minutes}`;
  }
  if (isYesterday) {
    return '어제';
  }
  if (sendAt.getFullYear() === now.getFullYear()) {
    const month = String(sendAt.getMonth() + 1).padStart(2, '0');
    const day = String(sendAt.getDate()).padStart(2, '0');
    return `${month}-${day}`;
  }
  const year = sendAt.getFullYear();
  const month = String(sendAt.getMonth() + 1).padStart(2, '0');
  const day = String(sendAt.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

function formatDateTime(datetimeString) {
  const date = datetimeString.substring(0, 10);
  const time = datetimeString.substring(11, 16);
  const [hours, minutes] = time.split(':');
  let formattedHours = parseInt(hours);
  const ampm = formattedHours >= 12 ? '오후' : '오전';
  if (formattedHours > 12) {
    formattedHours -= 12;
  } else if (formattedHours === 0) {
    formattedHours = 12;
  }
  const formattedTime = `${ampm} ${formattedHours}:${minutes}`;
  return {
    date: date,
    time: formattedTime
  };
}

function sendMessage() {
    const inputElement = document.getElementById("chat-input");
    const message = inputElement.value.trim();
    if (message && header.chatUser) {
        inputElement.value = "";
        stompClient.publish({
            destination: "/app/chat",
            headers: { type : "SEND_MESSAGE" },
            body: JSON.stringify({
                chatUserId : header.chatUser.id,
                content : message
            })
        });
    }
}

function createChatItem(chat) {
        const chatBody = document.getElementById("chat-body");
        const messageClass = chat.requestUserId == header.chatUser.id ? "received" : "sent";
        const readStatusClass = chat.isRead == 1 ? "read" : "";
        const chatDateTime = formatDateTime(chat.sendAt);
        header.chatUser.lastChatId = chat.id;
        const chatDate = chatDateTime.date;
        if(chatDate != header.chatUser.lastChatDate){
            //날짜 div 새로 생성해야됨. chatItem에 붙일 문자열 생성
            //예를들어, 2025년 8월 9일에 채팅하다가 10일로 넘어갔을 때 2025. 8. 10 표시
            header.chatUser.lastChatDate = chatDate;
        }
        const chatItem = `
        <div class="chat-message-wrapper ${messageClass} ${readStatusClass}" data-chat-id="${chat.id}">
            <div class="chat-message">${chat.content}</div>
            <div class="chat-message-status">
                <span class="read-status"><i class="fas fa-check"></i></span>
                <span class="message-time">${chatDateTime.time}</span>
            </div>
        </div>
        `;
        chatBody.insertAdjacentHTML("beforeend", chatItem);
        chatBody.scrollTop = chatBody.scrollHeight;
      }

function handleFriendRequest(action, element) {
    const userId = $(element).attr("data-user-id");
    if(action == "request"){
        stompClient.publish({
          destination: "/app/chat",
          headers: { type: "SEND_REQUEST" },
          body: JSON.stringify({
            chatUserId: userId
          }),
        });
    }else{
        stompClient.publish({
          destination: "/app/chat",
          headers: { type: "SEND_REQUEST_RESPONSE" },
          body: JSON.stringify({
            chatUserId: userId,
            action : action
          }),
        });
    }
}
