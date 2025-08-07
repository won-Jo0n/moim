package com.spring.mbti.repository;

import com.spring.mbti.dto.MbtiTestDTO;
import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class MbtiTestRepository {

    private final SqlSessionTemplate sql;

    public MbtiTestRepository(SqlSession sqlSession) {
        this.sql = (SqlSessionTemplate) sqlSession;
    }

    // 1. MBTI 테스트 문항 전체 조회
    public List<MbtiTestDTO> findAllQuestions() {
        return sql.selectList("MbtiTest.findAllQuestions");
    }

    // 2. MBTI 문자열(예: "ENFP")로 mbti 테이블의 id 조회
    public int findMbtiIdByCode(String mbti) {
        return sql.selectOne("MbtiTest.findMbtiIdByCode", mbti);
    }

    // 3. 사용자 ID로 user 테이블의 mbtiId 업데이트
    public void updateUserMbti(int userId, int mbtiId) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("mbtiId", mbtiId);
        sql.update("MbtiTest.updateUserMbti", param);
    }

    // 4. 로그인 ID로 사용자 ID 조회
    public int findUserIdByLoginId(String loginId) {
        return sql.selectOne("MbtiTest.findUserIdByLoginId", loginId);
    }
}
