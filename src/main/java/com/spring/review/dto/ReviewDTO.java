package com.spring.review.dto;

import com.spring.review.repository.ReviewRepository;
import lombok.Data;

@Data
public class ReviewDTO {
    private String content,createdAt;
    private int id;
    private int groupId;
    private int groupScheduleId;
    private int reviewer;
    private int userId;
    private int score; // 점수 avg -> 평균점수 user의 rating으로 나타내기 > int로 변환
    private int status;



}
