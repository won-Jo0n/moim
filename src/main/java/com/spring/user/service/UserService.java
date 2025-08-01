package com.spring.user.service;

import com.spring.user.dto.UserDTO;
import com.spring.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

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
}
