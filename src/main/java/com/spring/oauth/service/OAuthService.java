package com.spring.oauth.service;

import com.spring.oauth.repository.OAuthRepository;
import com.spring.user.dto.UserDTO;
import com.spring.utils.CheckedUtil;
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
        boolean result = CheckedUtil.isValidPhone(userDTO.getMobile());
        if(result){
            oAuthRepository.OAuthJoin(userDTO);
        }else{
            throw new IllegalArgumentException("잘못된 전화번호 형식입니다.");
        }
    }
}
