package com.spring.chat.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ChatMessageDTO {
    int id, requestUserId, responseUserId, isRead, status;
    LocalDateTime sendAt;
    String content;
}
