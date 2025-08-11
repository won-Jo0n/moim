package com.spring.websocket;

import com.spring.chat.dto.ChatMessageDTO;
import com.spring.chat.dto.ChatUserDTO;
import com.spring.chat.service.ChatService;
import com.spring.friends.dto.FriendsDTO;
import com.spring.friends.service.FriendsService;
import com.spring.notification.service.NotificationService;
import com.spring.friends.dto.FriendsDTO;
import com.spring.friends.service.FriendsService;
import com.spring.user.dto.UserDTO;
import com.spring.user.service.UserService;
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
import java.util.concurrent.ConcurrentLinkedDeque;
import java.util.concurrent.ConcurrentLinkedQueue;

@Controller
@RequiredArgsConstructor
public class WebSocketController {
    private final SimpMessagingTemplate messagingTemplate;
    private final NotificationService notificationService;
    private final FriendsService friendsService;
    private final ChatService chatService;
    private final FriendsService friendsService;
    private final UserService userService;
    private final Map<String, String> sessionToUser = new ConcurrentHashMap<>();
    private final Map<String, Integer> sessionCount = new ConcurrentHashMap<>();
    private final Queue<String> matchingQueue = new ConcurrentLinkedQueue<>();
    private final Object matchingLock = new Object();

    @MessageMapping("/notification")
    public void notification(@Header("type") String type, @Payload Map<String, Object> data, Principal principal){
        String userId = principal.getName();
        if(type.equals("READ_NOTIFICATION")) {
            int notificationId = (int)data.get("notificationId");
            notificationService.readNotification(Integer.parseInt(userId), notificationId);
            messagingTemplate.convertAndSendToUser(userId, "/queue/main", Map.of("notificationId", notificationId), Map.of("type", type));
        }else if(type.equals("ACCEPT_FRIEND")){
            FriendsDTO friendsDTO = new FriendsDTO();
            friendsDTO.setRequestUserId((int)data.get("requestUserId"));
            friendsDTO.setResponseUserId(Integer.parseInt(userId));
            friendsDTO.setStatus(1);
            friendsService.updateFriend(friendsDTO);
        }
    }

    /*
    @MessageMapping("/connect")
    @SendToUser("/queue/main")
    public Map<String, Object> connect(SimpMessageHeaderAccessor headerAccessor, Principal principal){//내가 연결하면 나의 친구들에게 나의 접속을 알린다. 그리고 나에게 접속한 친구들의 리스트를 보낸다.
        String sessionId = headerAccessor.getSessionId();
        String userId = principal.getName();

        return Map.of("userId", userId, "type", "FRIEND_ONLINE");
    }
     */

    @MessageMapping("/match")
    public void matchMaking(@Payload String s, Principal principal){
        String userId = principal.getName();
        if(matchingQueue.contains(userId)) return;
        String opponentId = matchingQueue.poll();
        if(opponentId != null){
            //이미 친구여도 매칭이 되는 상태임. 고쳐야함
            chatService.requestChat(Integer.parseInt(opponentId), Integer.parseInt(userId));
            ChatUserDTO userDTO1 = chatService.getChatFriendById(Integer.parseInt(userId), Integer.parseInt(opponentId));
            messagingTemplate.convertAndSendToUser(userId, "/queue/main", userDTO1, Map.of("type", "MATCH_FOUND"));
            ChatUserDTO userDTO2 = chatService.getChatFriendById(Integer.parseInt(opponentId), Integer.parseInt(userId));
            messagingTemplate.convertAndSendToUser(opponentId, "/queue/main", userDTO2, Map.of("type", "MATCH_FOUND"));
        }else{
            matchingQueue.add(userId);
            messagingTemplate.convertAndSendToUser(userId, "/queue/main", "", Map.of("type", "MATCH_JOIN"));
        }
    }

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
            if(readCount > 0) {
                Map<String, Object> map = new HashMap<>();
                map.put("reader", userId);
                map.put("sender", chatUserId);
                map.put("chatId", chatId);
                map.put("readCount", readCount);
                messagingTemplate.convertAndSendToUser(userId, "/queue/main", map, Map.of("type", "READ_MESSAGE_SELF"));
                messagingTemplate.convertAndSendToUser(chatUserId, "/queue/main", map, Map.of("type", "READ_MESSAGE_OTHER"));
            }
        }else if(type.equals("SEND_REQUEST")){
            chatService.requestChat(Integer.parseInt(userId), Integer.parseInt(chatUserId));
            messagingTemplate.convertAndSendToUser(userId, "/queue/main", Map.of("id", Integer.parseInt(chatUserId)), Map.of("type", type));
            ChatUserDTO chatUserDTO = chatService.getChatFriendById(Integer.parseInt(chatUserId), Integer.parseInt(userId));
            messagingTemplate.convertAndSendToUser(chatUserId, "/queue/main", chatUserDTO, Map.of("type", "RECEIVE_REQUEST"));
        }else if(type.equals("SEND_REQUEST_RESPONSE")){
            boolean accept = ((String)data.get("action")).equals("accept");
            if(accept) chatService.acceptChat(Integer.parseInt(userId), Integer.parseInt(chatUserId));
            else chatService.declineChat(Integer.parseInt(userId), Integer.parseInt(chatUserId));
            messagingTemplate.convertAndSendToUser(userId, "/queue/main", Map.of("id", Integer.parseInt(chatUserId)), Map.of("type", type));
            if(accept){
                ChatUserDTO chatUserDTO1 = chatService.getChatFriendById(Integer.parseInt(userId), Integer.parseInt(chatUserId));
                messagingTemplate.convertAndSendToUser(userId, "/queue/main", chatUserDTO1, Map.of("type", "FRIEND_NEW"));
                ChatUserDTO chatUserDTO2 = chatService.getChatFriendById(Integer.parseInt(chatUserId), Integer.parseInt(userId));
                messagingTemplate.convertAndSendToUser(chatUserId, "/queue/main", chatUserDTO2, Map.of("type", "FRIEND_NEW"));
            }
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

            synchronized (matchingLock) {
                matchingQueue.remove(userId);
            }

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
