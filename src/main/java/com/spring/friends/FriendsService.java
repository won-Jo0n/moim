package com.spring.friends;

import com.spring.user.dto.UserDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FriendsService {
    private final FriendsRepository friendsRepository;
    public List<UserDTO> getAllFriends(int userId) {
        return friendsRepository.getAllFriends(userId);
    }
}
