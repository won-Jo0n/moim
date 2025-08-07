package com.spring.profile.repository;

import com.spring.mbti.dto.MbtiBoardDTO;
import com.spring.profile.dto.ProfileDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class ProfileRepository {
    private final SqlSessionTemplate sql;

    public ProfileDTO findByUserId(Long userId) {
        return sql.selectOne("Profile.findByUserId", userId);
    }

    public List<ProfileDTO> findFriendsByUserId(Long userId) {
        return sql.selectList("Profile.findFriendsByUserId", userId);
    }

    public MbtiBoardDTO findById(Long id) {
        return sql.selectOne("MbtiBoard.findById", id);
    }

}
