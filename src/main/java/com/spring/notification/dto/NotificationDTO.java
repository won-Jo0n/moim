package com.spring.notification.dto;

import lombok.Data;

@Data
public class NotificationDTO {
    int id, userId, requestUserId, relatedId, status;
    String type, createdAt, readAt, path;
}
