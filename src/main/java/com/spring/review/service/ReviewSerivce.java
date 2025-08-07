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


    public int createReview(ReviewDTO reviewDTO) {
        int result = reviewRepository.createReview(reviewDTO);

        if(result>=1) {
            Double avg = reviewRepository.findAverageScoreByUser(reviewDTO.getUserId());
            if(avg!=null){
                int rounded = (int) Math.round(avg);
                reviewRepository.updateUserRating(reviewDTO.getUserId(), rounded);
            }
        }

        return result;
    }

    public List<UserDTO> findParticipantsExceptReviewer(int groupScheduleId, int reviewer) {
        return reviewRepository.findParticipantsExceptReviewer(groupScheduleId, reviewer);
    }
}
