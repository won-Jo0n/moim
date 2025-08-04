package com.spring.friends;

import com.spring.user.dto.UserDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class FriendsRepository {
    private final SqlSessionTemplate sql;
    public List<UserDTO> getAllFriends(int userId) {
        return sql.selectList("Friends.getAllFriends", userId);
    }
}
