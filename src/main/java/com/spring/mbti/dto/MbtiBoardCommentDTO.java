package com.spring.mbti.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class MbtiBoardCommentDTO {
    private Long id;
    private Long boardId;
    private int author; // 유저 ID
    private String authorNickname; // 닉네임 출력용
    private String content;
    private LocalDateTime createdAt;
    private Long parentId; // 원댓글이면 null

}
