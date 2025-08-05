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
}

function createMessageItem(friendStatus, friend) {
  return $(`<div class="message-item"
                    data-user-id='${friend.id}'
                    ${
                      friendStatus == "FRIENDS" || friendStatus == "TEMPORARY"
                        ? " onclick='openChat(this)'"
                        : ""
                    }
                  >
                    <div class="avatar">
                      <img src="${friend.avatar}" />
                      ${
                        friendStatus == "FRIENDS"
                          ? "<div class='online-indicator'></div>"
                          : ""
                      }
                    </div>
                    <div class="user-info">
                      <h3>${friend.nickName}</h3>
                      <p>${friend.mbti}</p>
                    </div>
                    <div class="main-text">
                      <p>${friend.msg}</p>
                    </div>
                    ${
                      friendStatus == "FRIENDS" || friendStatus == "TEMPORARY"
                        ? "<div class='message-info'><span>" +
                          friend.lastSend +
                          "</span><div>" +
                          friend.notread +
                          "</div></div>"
                        : ""
                    }
                    ${
                      friendStatus == "PENDING"
                        ? "<button class='accept-btn' onclick='handleFriendRequest('accept', this)'><i class='fas fa-check'></i></button><button class='decline-btn' onclick='handleFriendRequest('decline', this)'><i class='fas fa-xmark'></i></button>"
                        : ""
                    }
                    ${
                      friendStatus == "NONE"
                        ? "<button class='request-btn' onclick='handleFriendRequest('request', this)'>채팅</button>"
                        : ""
                    }
              </div>`);
}

function openChat(element) {
  $("#chat-body").empty();
  /*
  $.ajax({
    url: "/chat/friends", // 서버 엔드포인트로 변경
    type: "GET",
    contentType: "application/json",
    success: function (data) {
      togglePopup("message-popup", false);
      togglePopup("chat-popup", true);

      console.log("채팅 기록:", data);

      document.getElementById("chat-user-name").textContent = data.userName;
      document.getElementById("chat-user-avatar").src = data.userAvatar;
    },
    error: function (xhr, status, error) {
      console.error("채팅 기록을 가져오는 중 오류 발생:", error);
    },
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
    inputElement.value = "";
    /*
    $.ajax({
        url: "/chat/send/1",
        // 1을 buttonElement의 부모에 있는 data-user-id로 보내줘야한다
        type: "GET",
        contentType: "application/json",
        success: function (data) {
          togglePopup("message-popup", false);
          togglePopup("chat-popup", true);

          console.log("채팅 기록:", data);

          document.getElementById("chat-user-name").textContent = data.userName;
          document.getElementById("chat-user-avatar").src = data.userAvatar;
        },
        error: function (xhr, status, error) {
          console.error("채팅 기록을 가져오는 중 오류 발생:", error);
        },
      });
      */
  }
}

function handleFriendRequest(action, buttonElement) {
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
    /*
    $.ajax({
      url: "/chat/friends",
      type: "GET",
      contentType: "application/json",
      success: function (data) {
        console.log(data); //후처리 해야함

        const messageList = $("#" + tabName + "-tab .message-list");

          const data = [
            {
              id: 0,
              nickName: "권택준",
              mbti: "ISFP",
              msg: "ㅇㅇㅇㅇㅇㅇㅇㅇㅇ",
            },
            {
              id: 1,
              nickName: "권택준1",
              mbti: "ENTJ",
              msg: "ㅇㅇㅇㅇㅇㅇㅇㅇㅇdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
            },
            {
              id: 2,
              nickName: "권택준2",
              mbti: "ISFP",
              msg: "ㅇㅇㅇㅇㅇㅇㅇㅇㅇ",
            },
            {
              id: 3,
              nickName: "권택준3",
              mbti: "ISFP",
              msg: "ㅇㅇㅇㅇㅇㅇㅇㅇㅇ",
            },
            {
              id: 4,
              nickName: "권택준4",
              mbti: "ISFP",
              msg: "ㅇㅇㅇㅇㅇㅇㅇㅇㅇ",
            },
            {
              id: 5,
              nickName: "권택준5",
              mbti: "ISFP",
              msg: "ㅇㅇㅇㅇㅇㅇㅇㅇㅇ",
            },
            {
              id: 6,
              nickName: "권택준6",
              mbti: "ISFP",
              msg: "ㅇㅇㅇㅇㅇㅇㅇㅇㅇ",
            },
          ];

          data.forEach((friend) => {
            if (tabName == "friends")
              messageList.append(createMessageItem("FRIENDS", friend));
            else if (tabName == "non-friends") {
              messageList.append(createMessageItem("PENDING", friend));
              messageList.append(createMessageItem("TEMPORARY", friend));
            } else {
              messageList.append(createMessageItem("NONE", friend));
            }

            //const sender = 0;
            //$(`div[data-user-id="${sender}"]`).append("asdf");
          });
      },
      error: function (xhr, status, error) {
        console.error("채팅 기록을 가져오는 중 오류 발생:", error);
      },
    });
    */
});
