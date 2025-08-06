package com.spring.mbti.repository;

import com.spring.mbti.dto.MbtiBoardCommentDTO;
import com.spring.mbti.dto.MbtiBoardDTO;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class MbtiBoardRepository {

    private final SqlSessionTemplate sql;

    private static final String NAMESPACE = "MbtiBoard."; // 매퍼 네임스페이스

    public int save(MbtiBoardDTO dto) {
        return sql.insert(NAMESPACE + "save", dto);
    }

    public List<MbtiBoardDTO> findAllByMbtiId(int mbtiId) {
        return sql.selectList(NAMESPACE + "findAllByMbtiId", mbtiId);
    }

    public MbtiBoardDTO findById(int id) {
        return sql.selectOne(NAMESPACE + "findById", id);
    }

    public int update(MbtiBoardDTO dto) {
        return sql.update(NAMESPACE + "update", dto);
    }

    public int delete(int id) {
        return sql.delete(NAMESPACE + "delete", id);
    }
    public int saveComment(MbtiBoardCommentDTO dto) {
        return sql.insert(NAMESPACE + "saveComment", dto);
    }

    public List<MbtiBoardCommentDTO> findCommentsByBoardId(int boardId) {
        return sql.selectList(NAMESPACE + "findCommentsByBoardId", boardId);
    }

//    public List<MbtiBoardDTO> findByAuthor(Long targetUserId) {
//    }
}
