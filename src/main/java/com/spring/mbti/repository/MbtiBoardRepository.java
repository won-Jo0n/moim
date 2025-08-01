package com.spring.mbti.repository;

import com.spring.mbti.dto.MbtiBoardDTO;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class MbtiBoardRepository {

    private final SqlSession sql;

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
}
