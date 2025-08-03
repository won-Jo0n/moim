package com.spring.oauth.repository;

import com.spring.user.dto.UserDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class OAuthRepository {
    private final SqlSessionTemplate sql;

    public UserDTO getUser(String id) {
        return sql.selectOne("OAuth.getUser", id);
    }

    public void OAuthJoin(UserDTO userDTO) {
        sql.insert("OAuth.join",userDTO);
    }
}
