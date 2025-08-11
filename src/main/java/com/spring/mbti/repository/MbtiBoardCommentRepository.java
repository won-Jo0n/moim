package com.spring.mbti.repository;

import com.spring.mbti.dto.MbtiBoardCommentDTO;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class MbtiBoardCommentRepository {

    private final SqlSession sql;

    private static final String NAMESPACE = "MbtiBoardComment.";

    public void save(MbtiBoardCommentDTO commentDTO) {
        sql.insert("MbtiBoardComment.save", commentDTO);
    }

    public List<MbtiBoardCommentDTO> findAllByBoardId(Long boardId) {
        return sql.selectList("MbtiBoardComment.findAllByBoardId", boardId);
    }

    public MbtiBoardCommentDTO findById(Long id) {
        return sql.selectOne("MbtiBoardComment.findById", id);
    }

    public void update(MbtiBoardCommentDTO commentDTO) {
        sql.update("MbtiBoardComment.update", commentDTO);
    }

    public void delete(Long id) {
        sql.update("MbtiBoardComment.delete", id); // 논리 삭제
    }
    public int saveComment(MbtiBoardCommentDTO dto) {
        return sql.insert(NAMESPACE + "saveComment", dto);
    }

    public List<MbtiBoardCommentDTO> findCommentsByBoardId(int boardId) {
        return sql.selectList(NAMESPACE + "findCommentsByBoardId", boardId);
    }

}
