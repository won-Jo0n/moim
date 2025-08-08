package com.spring.friends.repository;

import com.spring.friends.dto.FriendsDTO;
import com.spring.user.dto.UserDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class FriendsRepository {
    private final SqlSessionTemplate sql;

    public List<UserDTO> getFriends(int loginId) {
        return sql.selectList("Friends.getFriends", loginId);
    }

    public List<UserDTO> pendingFriends(int loginId){
        return sql.selectList("Friends.pendingFriends", loginId);
    }

    public int addFriend(FriendsDTO friendsDTO){
        return sql.insert("Friends.addFriend", friendsDTO);
    }

    public int updateFriend(FriendsDTO friendsDTO){
        return sql.update("Friends.updateFriend", friendsDTO);
    }

    public int cancelFriend(FriendsDTO dto){
        return sql.update("Friends.cancelFriend", dto);
    }

}
