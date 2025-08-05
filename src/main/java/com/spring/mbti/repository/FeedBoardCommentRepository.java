package com.spring.mbti.repository;

import com.spring.mbti.dto.FeedBoardCommentDTO;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class FeedBoardCommentRepository {

    private final SqlSession sql;
    private static final String NAMESPACE = "FeedBoardComment.";

    public void save(FeedBoardCommentDTO dto) {
        sql.insert(NAMESPACE + "save", dto);
    }

    public List<FeedBoardCommentDTO> findAllByFeedId(Long feedId) {
        return sql.selectList(NAMESPACE + "findAllByFeedId", feedId);
    }

    public void update(FeedBoardCommentDTO dto) {
        sql.update(NAMESPACE + "update", dto);
    }

    public void delete(Long id) {
        sql.delete(NAMESPACE + "delete", id);
    }

    public List<FeedBoardCommentDTO> findRepliesByParentId(Long parentId) {
        return sql.selectList(NAMESPACE + "findRepliesByParentId", parentId);
    }
}
