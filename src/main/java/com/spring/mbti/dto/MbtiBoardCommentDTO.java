package com.spring.mbti.dto;

import lombok.Data;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
public class MbtiBoardCommentDTO {
    private Long id;
    private Long boardId;
    private int author; // 유저 ID
    private String authorNickname; // 닉네임 출력용
    private String content;
    private LocalDateTime createdAt;
    private Long parentId; // 원댓글이면 null
    private Integer profileFileId;



    // ▼ JSP에서 ${comment.formattedCreatedAt} 로 사용
    public String getFormattedCreatedAt() {
        if (createdAt == null) return "";
        return createdAt.format(DateTimeFormatter.ofPattern("MM/dd HH:mm"));
    }

    // (옵션) 더 길게 쓰고 싶을 때
    public String getLongCreatedAt() {
        if (createdAt == null) return "";
        return createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
    }
}
