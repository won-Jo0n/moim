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
    public List<UserDTO> pendingFriends(int loginId){
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

    public int cancelFriend(FriendsDTO dto){
        return friendsRepository.cancelFriend(dto);
    }

}

