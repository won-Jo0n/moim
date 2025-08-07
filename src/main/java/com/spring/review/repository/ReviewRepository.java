package com.spring.review.repository;

import com.spring.review.dto.ReviewDTO;
import com.spring.user.dto.UserDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class ReviewRepository {
    private final SqlSessionTemplate sql;

    public int createReview(ReviewDTO reviewDTO) {
        return sql.insert("Review.create",reviewDTO);
    }

    // serschedule에서 status = 1인 사람 조회
    public List<ReviewDTO> findParticipantsForReview(int groupScheduleId) {
        return sql.selectList("Review.findParticipantsForReview", groupScheduleId);
    }

    // review 테이블에서 userId 기준으로 평균점수 구하기
    public Double findAverageScoreByUser(int userId) {
        return sql.selectOne("Review.findAverageScoreByUser", userId);
    }

    // review 저장 후 rating 업데이트
    public void updateUserRating(int userId, int rating) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("rating", rating);
        sql.update("Review.updateUserRating", param);
    }

    // 참여한 사람들 중 reviwer를 제외한 리뷰 대상자
    public List<UserDTO> findParticipantsExceptReviewer(int groupScheduleId, int reviewer) {
        Map<String, Object> param = new HashMap<>();
        param.put("groupScheduleId", groupScheduleId);
        param.put("reviewer", reviewer);
        return sql.selectList("Review.findParticipantsExceptReviewer", param);
    }
}
