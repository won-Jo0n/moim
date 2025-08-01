package com.spring.websocket;

import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.stereotype.Controller;
import org.springframework.web.util.HtmlUtils;

@Controller
@RequiredArgsConstructor
public class WebSocketController {
    private final SimpMessagingTemplate messagingTemplate;

    @MessageMapping("/hello") // 클라이언트가 /app/hello 로 메시지를 보낼 때 매핑됩니다.
    @SendTo("/topic/greetings") // 이 메서드의 반환 값이 /topic/greetings 를 구독하는 모든 클라이언트에게 전송됩니다.
    public WebSocketResponseMessage greeting(WebSocketMessage webSocketMessage, SimpMessageHeaderAccessor headerAccessor) throws Exception {
        String userId = (String) headerAccessor.getSessionAttributes().get("userId");
        System.out.println("로그인한 사용자 ID: " + userId);
        //onlineUsers.add(userId);
        //System.out.println("Received message: " + onlineUsers);
        return new WebSocketResponseMessage("Hello, " + HtmlUtils.htmlEscape(webSocketMessage.getName()) + "!");
    }

    @MessageMapping("/connect")
    @SendToUser("/queue/onlineFriends") //내가 연결할때 내 온라인 친구들을 Response 받는다.
    public WebSocketResponseMessage connect(){
        //
        return new WebSocketResponseMessage("");
    }
    /*
    private void sendOnlineStatusToFriends(String userId) {
        List<String> friends = friendService.getFriendsOf(userId);

        for (String friendId : friends) {
            List<String> onlineFriends = friendService.getFriendsOf(friendId).stream()
                    .filter(onlineUsers::contains)
                    .toList();

            messagingTemplate.convertAndSendToUser(
                    friendId,
                    "/queue/onlineFriends",
                    onlineFriends
            );
        }
    }
    */
}
