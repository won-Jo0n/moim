package com.spring.profile.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProfileDTO {
    private int userId;
    private String loginId;
    private String nickname;
    private String mbti;
    private int rating;
    private String joinedAt;
}
