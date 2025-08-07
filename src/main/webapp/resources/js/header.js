const header = {
    chatUnread : 0,
    chatUser : null
};
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
    const data = JSON.parse(msg.body);
    switch (msg.headers.type) {
      case "FRIEND_ONLINE":
        $(`div[data-user-id="${data.sender}"] .online-indicator`).addClass("online");
        break;
      case "FRIEND_OFFLINE":
        $(`div[data-user-id="${data.sender}"] .online-indicator`).removeClass("online");
        break;
      case "SEND_MESSAGE":
      case "RECEIVE_MESSAGE":
        if(msg.headers.type == "RECEIVE_MESSAGE"){
            if(header.chatUser && header.chatUser.id == data.requestUserId){
                createChatItem(data);
                stompClient.publish({
                    destination: "/app/chat",
                    headers: { type : "READ_MESSAGE" },
                    body: JSON.stringify({
                        chatUserId : header.chatUser.id,
                        chatId : header.chatUser.lastChatId,
                    })
                });
            }else{
                header.chatUnread++;
                console.log("현재 채팅을 볼수없는 상태임");
                //$(`div[data-user-id="${header.chatUser.id}"]`)
            }
        }
        break;
      case "READ_RECEIPT":
        break;
    }
  });
};
$(function () {
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
    messageList.append(
      $(`<div class="message-item"
            data-user-id='${user.id}'
            ${user.status <= 2 ? " onclick='openChat(this)'" : ""}
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
              <p>${user.lastChatContent}</p>
            </div>
            ${
              user.status <= 1
                ? "<div class='message-info'><span>" +
                  user.lastChatTime +
                  "</span><div>" +
                  (user.unreadCount > 0 ? user.unreadCount : "") +
                  "</div></div>"
                : ""
            }
            ${
              user.status == 3
                ? "<button class='accept-btn' onclick='handleFriendRequest('accept', this)'><i class='fas fa-check'></i></button><button class='decline-btn' onclick='handleFriendRequest('decline', this)'><i class='fas fa-xmark'></i></button>"
                : ""
            }
            ${
              user.status <= 0
                ? "<button class='request-btn' onclick='handleFriendRequest('request', this)'>채팅</button>"
                : ""
            }
      </div>`)
    );
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
              chatId : header.chatUser.lastChatId,
          })
      });
    },
    error: function (xhr, status, error) {
      console.error("채팅 기록을 가져오는 중 오류 발생:", error);
    },
  });
}

function closeChat() {
    header.chatUser = null;
  togglePopup("chat-popup", false);
  togglePopup("message-popup", true);
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
        const readStatusClass = chat.isRead == 1 ? "" : "hide";
        const chatDateTime = formatDateTime(chat.sendAt);
        header.chatUser.lastChatId = chat.id;
        const chatDate = chatDateTime.date;
        if(chatDate != header.chatUser.lastChatDate){
            //chatDate 날짜 div 새로 생성해야되므로 chatItem에 붙일 문자열 생성
            header.chatUser.lastChatDate = chatDate;
        }
        const chatItem = `
        <div class="chat-message-wrapper ${messageClass}" data-chat-id="${chat.id}">
            <div class="chat-message">${chat.content}</div>
            <div class="chat-message-status">
                <span class="read-status ${readStatusClass}"><i class="fas fa-check"></i></span>
                <span class="message-time">${chatDateTime.time}</span>
            </div>
        </div>
        `;
        chatBody.insertAdjacentHTML("beforeend", chatItem);
        chatBody.scrollTop = chatBody.scrollHeight;
      }

function handleFriendRequest(action, buttonElement) {
    console.log(buttonElement);
  const messageItem = buttonElement.closest(".message-item");
  const userName = messageItem.querySelector("h3").textContent;
    /*
    $.ajax({
        url: `/chat/${action}/1`,
        // 1을 buttonElement의 부모에 있는 data-user-id로 보내줘야한다.
        type: "GET",
        contentType: "application/json",
        success: function (data) {
        },
        error: function (xhr, status, error) {
          console.error("채팅 기록을 가져오는 중 오류 발생:", error);
        },
      });
      */

  if (action === "accept") {
    console.log(`${userName}님의 친구 요청을 수락했습니다.`);
    // 여기에 친구 수락 로직 (예: 서버 API 호출) 추가
    alert(`${userName}님을 친구로 추가했습니다!`);
  } else if (action === "decline") {
    console.log(`${userName}님의 친구 요청을 거절했습니다.`);
    // 여기에 친구 거절 로직 (예: 서버 API 호출) 추가
    alert(`${userName}님의 요청을 거절했습니다.`);
  } else if (action === "request") {
    alert("chat");
  }

  messageItem.style.display = "none"; //요청 처리 후 삭제? 일단 accept나 decline은 삭제해야됨
}
