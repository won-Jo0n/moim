package com.spring.review.dto;

import com.spring.review.repository.ReviewRepository;
import lombok.Data;

@Data
public class ReviewDTO {
    private String content,createdAt;
    private int id,groupId,groupScheduleId,reviewer,userId,score,status;

}
