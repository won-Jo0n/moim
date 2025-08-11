package com.spring.notification.service;

import com.spring.notification.dto.NotificationDTO;
import com.spring.notification.repository.NotificationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class NotificationService {
    private final NotificationRepository notificationRepository;
    private final SimpMessagingTemplate messagingTemplate;

    public void createNotification(NotificationDTO notificationDTO){
        notificationRepository.createNotification(notificationDTO);
        messagingTemplate.convertAndSendToUser(String.valueOf(notificationDTO.getUserId()), "/queue/main", notificationDTO, Map.of("type", "RECEIVE_NOTIFICATION"));
    }

    public void readNotification(int userId, int notificationId){
        if(notificationRepository.readNotification(notificationId) > 0){
            messagingTemplate.convertAndSendToUser(String.valueOf(userId), "/queue/main", Map.of("notificationId", notificationId), Map.of("type", "READ_NOTIFICATION"));
        }
    }

    public List<NotificationDTO> findAllByUserId(int userId){
        return notificationRepository.findAllByUserId(userId);
    }

    public void createBoardNotification() {
        /*
        List<Notification> notifications = new ArrayList<>();
        // 게시글 알림에 대한 동적 경로 생성
        String postLink = "/board/posts/" + postId;

        for (Integer userId : userIds) {
            Notification notification = new Notification();
            notification.setRecipientId(userId);
            notification.setContent("새로운 게시글 '" + postTitle + "'이(가) 등록되었습니다.");
            notification.setLink(postLink); // 생성된 경로를 link에 설정
            notification.setRead(false);
            notifications.add(notification);
        }

        if (!notifications.isEmpty()) {
            notificationMapper.insertBatch(notifications);
        }
        */
    }
}
