package com.spring.report.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ReportDTO {
    private int id,reportUser,reportedUser,type,status;
    private String content;
    private LocalDateTime reportedAt;
}
