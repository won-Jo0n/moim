package com.spring.groupboardcomment.dto;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class GroupBoardCommentDTO {
    private int id;
    private int groupId;
    private int boardId;
    private String author;
    private String content;
    private Timestamp createdAt;
    private int status;

}
