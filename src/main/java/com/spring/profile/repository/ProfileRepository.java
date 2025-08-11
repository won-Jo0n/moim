package com.spring.profile.repository;

import com.spring.group.dto.GroupDTO;
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

    public ProfileDTO findByUserId(Long userId) {
        return sql.selectOne("Profile.findByUserId", userId);
    }

    public List<ProfileDTO> findFriendsByUserId(Long userId) {
        return sql.selectList("Profile.findFriendsByUserId", userId);
    }

    public MbtiBoardDTO findById(Long id) {
        return sql.selectOne("MbtiBoard.findById", id);
    }

    public int updateFileId(Long userId, Integer fileId) {
        Map<String, Object> p = new HashMap<>();
        p.put("userId", userId);
        p.put("fileId", fileId);
        // Mapper의 id는 "Profile.updateFileId" (아래 XML과 일치)
        return sql.update("Profile.updateFileId", p);
    }
    public String selectPasswordHash(Long userId) {
        return sql.selectOne("Profile.selectPasswordHash", userId);
    }

    public int deleteUser(Long userId) {
        return sql.update("Profile.deleteUser", userId);   // ← UPDATE로 변경
    }

    public List<GroupDTO> findGroupsByUserId(Long userId) {
        return sql.selectList("Profile.findGroupsByUserId", userId);
    }
}
