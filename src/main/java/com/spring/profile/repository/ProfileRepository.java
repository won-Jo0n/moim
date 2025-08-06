// ✅ 클래스 이름: ProfileRepository (인터페이스 X)
package com.spring.profile.repository;

import com.spring.profile.dto.ProfileDTO;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class ProfileRepository {

    private final SqlSession sql;
    private final String namespace = "com.spring.profile.repository.ProfileRepository.";

    public ProfileDTO findByUserId(Long userId) {
        return sql.selectOne(namespace + "findByUserId", userId);
    }

    public void updateProfile(ProfileDTO dto) {
        sql.update(namespace + "updateProfile", dto);
    }

    public List<ProfileDTO> findAcceptedFriends(Long userId) {
        return sql.selectList(namespace + "findAcceptedFriends", userId);
    }
}
