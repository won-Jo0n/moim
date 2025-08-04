package com.spring.oauth.service;

import com.spring.oauth.repository.OAuthRepository;
import com.spring.user.dto.UserDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OAuthService {
    private final OAuthRepository oAuthRepository;

    public UserDTO getUser(String id) {
        return oAuthRepository.getUser(id);
    }

    public void OAuthJoin(UserDTO userDTO) {
        oAuthRepository.OAuthJoin(userDTO);
    }
}
