package com.spring.mbti.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class FeedBoardCommentDTO {
    private Long id;
    private Long feedId;
    private int author;
    private int mbtiId;
    private String content;
    private LocalDateTime createdAt;
    private int status;
    private Long parentId;

    // 출력용
    private String authorNickname;
}
