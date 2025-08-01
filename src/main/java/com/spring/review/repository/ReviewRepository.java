package com.spring.review.repository;

import com.spring.review.dto.ReviewDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class ReviewRepository {
    private final SqlSessionTemplate sql;

    public int createReview(ReviewDTO reviewDTO) {
        return sql.insert("Review.create",reviewDTO);
    }
}
