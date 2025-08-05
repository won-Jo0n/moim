package com.spring.report.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ReportDTO {
    private int id,reportUser,reportedUser,status, boardId;
    private String content, type, title;
    private LocalDateTime reportedAt;
    private Integer commentId;
}
