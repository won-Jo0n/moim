package com.spring.chat.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

@Data
public class ChatMessageDTO {
    int id, requestUserId, responseUserId, isRead, status;
    String sendAt;
    String content;
}
