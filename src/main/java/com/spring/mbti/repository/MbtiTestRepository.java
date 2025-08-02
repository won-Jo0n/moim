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

    public int findMbtiIdByCode(String mbti) {
        return sql.selectOne("MbtiTest.findMbtiIdByCode", mbti);
    }

    public void updateUserMbti(int userId, int mbtiId) {
        var param = new java.util.HashMap<String, Object>();
        param.put("userId", userId);
        param.put("mbtiId", mbtiId);
        sql.update("MbtiTest.updateUserMbti", param);
    }

    public int findUserIdByLoginId(String loginId) {
        return sql.selectOne("MbtiTest.findUserIdByLoginId", loginId);
    }
}
