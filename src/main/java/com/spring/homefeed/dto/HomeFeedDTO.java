package com.spring.homefeed.dto;

import lombok.Data;

@Data
public class HomeFeedDTO {
    private int id, mbtiId, author, fileId, status, hits,authorProfile;
    private String title, content, createdAt, authorName, mbti;
}
