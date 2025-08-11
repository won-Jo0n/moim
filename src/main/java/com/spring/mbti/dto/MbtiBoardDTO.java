package com.spring.mbti.dto;

import lombok.Data;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

@Data
public class MbtiBoardDTO {
    private int id;
    private int mbtiId;
    private int author;
    private String nickName;
    private String title;
    private String content;
    private Integer fileId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private int status;
    private String authorInfo;
    private Integer hits;


    public Date getCreatedAtAsDate() {
        return Timestamp.valueOf(createdAt);
    }

    public String getFormattedCreatedAt() {
        if (createdAt == null) return "";
        return createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
    }


}
