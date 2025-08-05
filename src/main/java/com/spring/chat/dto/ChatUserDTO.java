package com.spring.chat.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ChatUserDTO {
    int id, status, unreadCount, fileId;
    String nickName, gender, mbti, lastChatContent;
    LocalDateTime lastLoginTime, lastChatTime;
}