package com.spring.user.service;

import com.spring.user.dto.UserDTO;
import com.spring.user.dto.UserScheduleDTO;
import com.spring.user.repository.UserRepository;
import com.spring.utils.CheckedUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    public int join(UserDTO userDTO) {
        boolean result = CheckedUtil.isValidPhone(userDTO.getMobile());
        if(result){
            return userRepository.join(userDTO);
        }else{
            throw new IllegalArgumentException("잘못된 전화번호 형식입니다.");
        }
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

    public void createUserSchedule(UserScheduleDTO userScheduleDTO) {
        userRepository.createUserSchedule(userScheduleDTO);
    }

    public UserScheduleDTO isJoin(UserScheduleDTO userScheduleDTO) {
        return userRepository.isJoin(userScheduleDTO);
    }

    public void cancleUserSchedule(UserScheduleDTO result) {
        userRepository.cancleUserSchedule(result);
    }
}
