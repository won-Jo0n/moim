package com.spring.chat.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ChatUserDTO {
    int id, status, unreadCount, fileId;
    String nickName, gender, mbti, lastChatContent, lastLoginTime, lastChatTime;
}