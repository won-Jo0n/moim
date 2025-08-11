package com.spring.homefeed.dto;

import lombok.Data;

@Data
public class HomeFeedDTO {
    private int id, author, fileId, hits, authorFileId, commentCount;
    private String mbti, content, title , createdAt, authorNickName;
}
