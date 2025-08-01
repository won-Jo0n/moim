package com.spring.mbti.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class MbtiBoardDTO {
    private int id;
    private int mbtiId;
    private int author;
    private String title;
    private String content;
    private int fileId;
    private LocalDateTime createdAt;
    private int status;
}
