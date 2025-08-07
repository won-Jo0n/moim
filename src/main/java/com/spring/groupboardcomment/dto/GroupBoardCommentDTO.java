package com.spring.groupboardcomment.dto;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class GroupBoardCommentDTO {
    private int id;
    private int groupId;
    private int boardId;
    private int author;
    private String content;
    private Timestamp createdAt;
    private int status;
    private Integer parentId; // 일반 댓글 = null
    private int depth;        // 들여쓰기 단계

    // 닉네임 조인용 (JOIN user)
    private String authorNickName;

}
