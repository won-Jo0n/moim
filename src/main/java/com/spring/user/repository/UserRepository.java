package com.spring.user.repository;

import com.spring.user.dto.UserDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class UserRepository {
    private final SqlSessionTemplate sql;
    public int join(UserDTO userDTO) {
        System.out.println(userDTO.getRegion());
        System.out.println(userDTO.getGender());
        System.out.println(userDTO.getLoginId());
        System.out.println(userDTO.getRegion());
        return sql.insert("User.join",userDTO);
    }
}
