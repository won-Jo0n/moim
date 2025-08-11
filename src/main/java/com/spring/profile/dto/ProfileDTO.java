package com.spring.profile.dto;

import lombok.Data;

@Data
public class ProfileDTO {
    private Long userId;
    private String nickname;
    private String mbti;
    private int rating; // 1~5
    private String joinedAt;
    private Integer point;
    private Integer fileId;
}
