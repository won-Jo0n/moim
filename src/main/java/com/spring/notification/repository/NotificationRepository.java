package com.spring.notification.repository;

import com.spring.notification.dto.NotificationDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class NotificationRepository {
    private final SqlSessionTemplate sql;

    public void createNotification(NotificationDTO notificationDTO) {
        sql.insert("Notification.createNotification", notificationDTO);
    }
}
