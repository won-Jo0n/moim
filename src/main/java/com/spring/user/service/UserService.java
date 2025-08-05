package com.spring.user.service;

import com.spring.user.dto.UserDTO;
import com.spring.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    public int join(UserDTO userDTO) {
        return userRepository.join(userDTO);
    }

    public UserDTO login(UserDTO userDTO) {
        return userRepository.login(userDTO);
    }

    public UserDTO getUserById(int userId) {
        return userRepository.getUserById(userId);
    }

    public int modify(UserDTO userDTO) {
        return userRepository.modify(userDTO);
    }

    public void delete(int userId) {
        userRepository.delete(userId);
    }

    public int nickNameCheck(String nickName) {
        return userRepository.nickNameCheck(nickName);
    }
}
