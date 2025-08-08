package com.spring.review.service;

import com.spring.review.dto.ReviewDTO;
import com.spring.review.repository.ReviewRepository;
import com.spring.user.dto.UserDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ReviewSerivce {
    private final ReviewRepository reviewRepository;

    public boolean existsReview(int groupScheduleId, int reviewer, int userId) {
        Integer cnt = reviewRepository.countByScheduleReviewerTarget(groupScheduleId, reviewer, userId);
        return cnt != null && cnt > 0;
    }

    // 리뷰 저장 + 평점 업데이트
    public int createReviewAndUpdateRating(ReviewDTO reviewDTO) {
        // 리뷰 저장
        int result = reviewRepository.createReview(reviewDTO);
        // 저장 성공 시 평균 평점 계산 후 업데이트
        if (result > 0) {
            Double avgScore = reviewRepository.calculateAverageScore(reviewDTO.getUserId());
            if (avgScore == null) {
                avgScore = 0.0;
            }
            reviewRepository.updateUserRating(reviewDTO.getUserId(), avgScore);
        }
        return result;
    }


    public List<UserDTO> findParticipantsExceptReviewer(int groupScheduleId, int reviewer) {
        return reviewRepository.findParticipantsExceptReviewer(groupScheduleId, reviewer);
    }


}
