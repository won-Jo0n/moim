package com.spring.mbti.repository;

import com.spring.mbti.dto.MbtiTestDTO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class MbtiTestRepository {

    private final SqlSession sql;

    public MbtiTestRepository(SqlSession sqlSession) {
        this.sql = sqlSession;
    }

    public List<MbtiTestDTO> findAllQuestions() {
        return sql.selectList("MbtiTest.findAllQuestions");
    }
}
