package com.spring.groupboard.dto;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class GroupBoardDTO {
    private int id;
    private int groupId;
    private int author; // userId
    private String title;
    private String content;
    private Integer fileId; // 파일 만들고 int로 수정해두기
    private Timestamp createdAt;
    private int status;
    private int hits;

    // 닉네임 조인용 (JOIN user)
    private String authorNickName;

}
