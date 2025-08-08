package com.spring.websocket;

import com.spring.chat.dto.ChatMessageDTO;
import com.spring.chat.dto.ChatUserDTO;
import com.spring.chat.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;
import org.springframework.web.socket.messaging.SessionSubscribeEvent;

import java.security.Principal;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Controller
@RequiredArgsConstructor
public class WebSocketController {
    private final SimpMessagingTemplate messagingTemplate;
    private final ChatService chatService;
    private final Map<String, String> sessionToUser = new ConcurrentHashMap<>();
    private final Map<String, Integer> sessionCount = new ConcurrentHashMap<>();

    /*
    @MessageMapping("/hello") // 클라이언트가 /app/hello 로 메시지를 보낼 때 매핑됩니다.
    @SendTo("/topic/greetings") // 이 메서드의 반환 값이 /topic/greetings 를 구독하는 모든 클라이언트에게 전송됩니다.
    public Map<String, Object> greeting(Map<String, Object> map, Principal principal) throws Exception {
        //int userId = (int)headerAccessor.getSessionAttributes().get("userId");
        System.out.println("로그인한 사용자 ID: " + principal.getName());
        return map;
    }
     */

    /*
    @MessageMapping("/connect")
    @SendToUser("/queue/main")
    public Map<String, Object> connect(SimpMessageHeaderAccessor headerAccessor, Principal principal){//내가 연결하면 나의 친구들에게 나의 접속을 알린다. 그리고 나에게 접속한 친구들의 리스트를 보낸다.
        String sessionId = headerAccessor.getSessionId();
        String userId = principal.getName();

        return Map.of("userId", userId, "type", "FRIEND_ONLINE");
    }
     */

    @MessageMapping("/chat")
    public void chat(@Header("type") String type, @Payload Map<String, Object> data, Principal principal){
        String userId = principal.getName();
        String chatUserId = (String)data.get("chatUserId");
        if(type.equals("SEND_MESSAGE")) {
            ChatMessageDTO chatMessageDTO = chatService.sendChatMessage(Integer.parseInt(userId), Integer.parseInt(chatUserId), (String)data.get("content"));
            messagingTemplate.convertAndSendToUser(userId, "/queue/main", chatMessageDTO, Map.of("type", type));
            messagingTemplate.convertAndSendToUser(chatUserId, "/queue/main", chatMessageDTO, Map.of("type", "RECEIVE_MESSAGE"));
        }else if(type.equals("READ_MESSAGE")){
            int chatId = (int)data.get("chatId");
            int readCount = chatService.readChatMessage(Integer.parseInt(userId), Integer.parseInt(chatUserId), chatId);
            //if(readCount > 0) { //임시 해제
                Map<String, Object> map = new HashMap<>();
                map.put("reader", userId);
                map.put("sender", chatUserId);
                map.put("chatId", chatId);
                map.put("readCount", readCount);
                messagingTemplate.convertAndSendToUser(userId, "/queue/main", map, Map.of("type", type));
                messagingTemplate.convertAndSendToUser(chatUserId, "/queue/main", map, Map.of("type", "READ_RECEIPT"));
            //}
        }
    }

    @EventListener
    public void handleSubscribed(SessionSubscribeEvent event) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
        String sessionId = accessor.getSessionId();
        String userId = event.getUser().getName();
        boolean firstSession = false;
        if (!sessionToUser.containsKey(sessionId)) {
            sessionToUser.put(sessionId, userId);
            firstSession = sessionCount.merge(userId, 1, Integer::sum) == 1;
        }
        List<ChatUserDTO> chatFriends = chatService.getChatFriends(Integer.parseInt(userId));
        for (ChatUserDTO friend : chatFriends) {
            if (sessionCount.getOrDefault(String.valueOf(friend.getId()), 0) > 0) {
                messagingTemplate.convertAndSendToUser(userId, "/queue/main",
                        Map.of("sender", friend.getId()), Map.of("type", "FRIEND_ONLINE"));
                if (firstSession) {
                    messagingTemplate.convertAndSendToUser(String.valueOf(friend.getId()), "/queue/main",
                            Map.of("sender", userId), Map.of("type", "FRIEND_ONLINE"));
                }
            }
        }
    }

    @EventListener
    public void handleDisconnected(SessionDisconnectEvent event) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
        String sessionId = accessor.getSessionId();
        String userId = sessionToUser.get(sessionId);
        if (userId != null) {
            sessionToUser.remove(sessionId);
            sessionCount.computeIfPresent(userId, (k, v) -> v > 1 ? v - 1 : null);
            if(sessionCount.getOrDefault(userId, 0) <= 0){
                List<ChatUserDTO> chatFriends = chatService.getChatFriends(Integer.parseInt(userId));
                for(ChatUserDTO friend : chatFriends){
                    if(sessionCount.getOrDefault(String.valueOf(friend.getId()), 0) > 0){
                        messagingTemplate.convertAndSendToUser(String.valueOf(friend.getId()), "/queue/main",
                                Map.of("sender", userId), Map.of("type", "FRIEND_OFFLINE"));
                    }
                }
            }
        }

    }


    /*
    @MessageMapping("disconnect")
    public void disconnect(Principal principal){
        List<UserDTO> friends = friendsService.getAllFriends(Integer.parseInt(principal.getName()));
        for(UserDTO friend : friends){
            if(currentUsers.contains(friend.getId())){
                messagingTemplate.convertAndSendToUser(String.valueOf(friend.getId()), "/queue/friendStatus",
                        Map.of("userId", principal.getName(), "status", "off"));
            }

        }
        //currentUsers.remove();
    }
    */
}
