package com.spring.mbti.dto;

import lombok.Data;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
public class MbtiBoardDTO {
    private int id;
    private int mbtiId;
    private int author;
    private String nickName;
    private String title;
    private String content;
    private int fileId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private int status;

    public String getFormattedCreatedAt() {
        if (createdAt == null) return "";
        return createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
    }
}
