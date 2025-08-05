package com.spring.profile.repository;

import com.spring.mbti.dto.MbtiBoardDTO;
import com.spring.profile.dto.ProfileDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class ProfileRepository {
    private final SqlSessionTemplate sql;

    public ProfileDTO findProfileByUserId(int userId) {
        return sql.selectOne("Profile.findByUserId", userId);
    }

    public void updateRating(int userId, int change) {
        sql.update("Profile.updateRating", Map.of("userId", userId, "change", change));
    }

    public void updatePoint(int userId, int change) {
        sql.update("Profile.updatePoint", Map.of("userId", userId, "change", change));
    }

    public List<MbtiBoardDTO> findBoardsByUserId(int userId) {
        return sql.selectList("Profile.findBoardsByUserId", userId);
    }
}

