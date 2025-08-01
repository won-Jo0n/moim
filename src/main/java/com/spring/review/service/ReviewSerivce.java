package com.spring.review.service;

import com.spring.review.dto.ReviewDTO;
import com.spring.review.repository.ReviewRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ReviewSerivce {
    private final ReviewRepository reviewRepository;

    public int createReview(ReviewDTO reviewDTO) {
        return reviewRepository.createReview(reviewDTO);
    }
}
