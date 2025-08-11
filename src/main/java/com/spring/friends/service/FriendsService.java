package com.spring.friends.service;

import com.spring.chat.dto.ChatUserDTO;
import com.spring.chat.service.ChatService;
import com.spring.friends.dto.FriendsDTO;
import com.spring.friends.repository.FriendsRepository;
import com.spring.notification.dto.NotificationDTO;
import com.spring.notification.service.NotificationService;
import com.spring.user.dto.UserDTO;
import com.spring.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class FriendsService {
    private final NotificationService notificationService;
    private final ChatService chatService;
    private final UserService userService;

    private final SimpMessagingTemplate messagingTemplate;

    private final FriendsRepository friendsRepository;
    public List<UserDTO> getFriends(int loginId) {
        return friendsRepository.getFriends(loginId);
    }
    public List<UserDTO> pendingFriends(int loginId) {
        return friendsRepository.pendingFriends(loginId);
    }

    public int addFriend(FriendsDTO friendsDTO){
        NotificationDTO notificationDTO = new NotificationDTO();
        notificationDTO.setUserId(friendsDTO.getResponseUserId());
        notificationDTO.setRequestUserId(friendsDTO.getRequestUserId());
        notificationDTO.setRelatedId(friendsDTO.getRequestUserId());
        notificationDTO.setType("FRIEND_REQUEST");
        notificationDTO.setContent(userService.getUserById(friendsDTO.getRequestUserId()).getNickName());
        notificationService.createNotification(notificationDTO);
        return friendsRepository.addFriend(friendsDTO);
    }

    public int updateFriend(FriendsDTO friendDTO){
        if(friendDTO.getStatus() == 1){
            UserDTO userDTO1 = userService.getUserById(friendDTO.getResponseUserId());
            messagingTemplate.convertAndSendToUser(String.valueOf(friendDTO.getRequestUserId()), "/queue/main", userDTO1, Map.of("type", "FRIEND_NEW"));
            UserDTO userDTO2 = userService.getUserById(friendDTO.getRequestUserId());
            messagingTemplate.convertAndSendToUser(String.valueOf(friendDTO.getResponseUserId()), "/queue/main", userDTO2, Map.of("type", "FRIEND_NEW"));
        }
        //임시, update가 되기 전에 ChatUser를 받아올수는 없으므로 나중에 수정하자
        return friendsRepository.updateFriend(friendDTO);
    }

    public int cancelFriend(FriendsDTO dto) {
        return friendsRepository.cancelFriend(dto);
    }

    public int deleteFriendship(Long userId, Long friendId) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("friendId", friendId);
        return friendsRepository.deleteFriendship(param);
    }

    /**
     * 친구 상태를 JSP에서 쓰는 표준 문자열로 변환해서 반환.
     * - DB status == 1  -> "ACCEPTED"
     * - DB status == 0  -> "PENDING"
     * - 그 외 / null     -> "NONE"
     * - 만약 문자열로 오는 경우(accepted/pending/none, "1"/"0")도 전부 흡수
     */
    public String getFriendshipStatus(Long userId, Long targetUserId) {
        Map<String, Object> p = new HashMap<>();
        p.put("userId", userId);
        p.put("targetUserId", targetUserId);

        Object raw = friendsRepository.getFriendshipStatus(p); // Integer 또는 String, 없으면 null
        if (raw == null) return "NONE";

        // 숫자로 온 경우(권장: 0/1)
        if (raw instanceof Integer) {
            int v = (Integer) raw;
            if (v == 1) return "ACCEPTED";
            if (v == 0) return "PENDING";
            return "NONE";
        }

        // 문자열로 온 경우(예: "1","0","ACCEPTED","accepted"," PENDING " 등)
        String s = raw.toString().trim().toUpperCase();
        if ("1".equals(s) || "ACCEPTED".equals(s)) return "ACCEPTED";
        if ("0".equals(s) || "PENDING".equals(s))  return "PENDING";
        // 혹시 "NONE" 그대로면 유지
        if ("NONE".equals(s)) return "NONE";

        return "NONE";
    }
}
