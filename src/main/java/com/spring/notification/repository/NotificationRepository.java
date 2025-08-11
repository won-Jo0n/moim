package com.spring.notification.repository;

import com.spring.notification.dto.NotificationDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class NotificationRepository {
    private final SqlSessionTemplate sql;

    public void createNotification(NotificationDTO notificationDTO) {
        sql.insert("Notification.createNotification", notificationDTO);
    }

    public List<NotificationDTO> findAllByUserId(int userId) {
        return sql.selectList("Notification.findAllByUserId", userId);
    }

    public int readNotification(int notificationId) {
        return sql.update("Notification.readNotification", notificationId);
    }
}
