package com.spring.friends.service;

import com.spring.friends.dto.FriendsDTO;
import com.spring.friends.repository.FriendsRepository;
import com.spring.user.dto.UserDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FriendsService {
    private final FriendsRepository friendsRepository;
    public List<UserDTO> getFriends(int loginId) {
        return friendsRepository.getFriends(loginId);
    }

    public List<UserDTO> pendingFriends(int loginId){
        return friendsRepository.pendingFriends(loginId);
    }

    public int addFriend(FriendsDTO friendsDTO){
        return friendsRepository.addFriend(friendsDTO);
    }

    public int updateFriend(FriendsDTO friendDTO){
        return friendsRepository.updateFriend(friendDTO);
    }


}
