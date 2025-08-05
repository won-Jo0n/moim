package com.spring.profile.dto;

import lombok.Data;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Date;

@Data
public class ProfileDTO {
    private int userId;
    private String nickName;
    private String mbti;
    private int rating;
    private String grade;
    private int point;
    private LocalDateTime joinedAt;

    public Date getJoinedAtAsDate() {
        return Timestamp.valueOf(joinedAt);
    }
}

